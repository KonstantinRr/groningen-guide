/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

/// This class implements a simple expression parser that is able to parse
/// boolean expression statements like (A AND B OR NOT (C OR K))). It builds
/// an abstract syntax tree that consists of the different operators.
/// 
/// Parsing a boolean expression consists of two separate steps.
/// 1. Tokenization, see [TokenType], [Token], [tokenize] for more information
/// 2. Tree building, see [TreeElement], [parseExpression], parseXYZ
/// Both tasks may be performed by a single call to [buildExpression] which
/// returns an abstract syntax tree.
/// Written by Konstantin Rolf 2020

// Parsing is done using the following grammar
// atom  := <ident> | <value> |'(' <or> ')' .
// not   := ['NOT'] <atom>
// and   := <not> { 'NOT' <not> }
// then  := <and> { 'THEN' <and> }
// xor   := <then> { 'XOR' <then> }
// or    := <or> { 'OR' <or> }

//// TOKENIZER SEGMENT ////

/// This class gives all possible tokens that may be encountered in the input
/// message. Note that this list may be split into two different kinds of tokens.
/// 1. S tokens which are allowed at any point in the expression
/// 2. L tokens which need at least a single S token in between
enum TokenType {
  // S tokens, they are allowed everywhere
  PARANTHESIS_OPEN,
  PARANTHESIS_CLOSE,
  WHITESPACE, TAB, NEWLINE,
  EQUAL,

  // L tokens, they require at least one S token in between
  AND, OR, XOR, THEN, NOT,
  IDENT, VALUE,
}

/// A token is a tuple consisting of a [TokenType] and a [String] value
class Token {
  /// The type of this token
  final TokenType type;
  /// The string value
  final String value;

  /// Checks whether this token is a (s)mall token
  bool isSToken() =>
    type == TokenType.PARANTHESIS_OPEN ||
    type == TokenType.PARANTHESIS_CLOSE ||
    type == TokenType.WHITESPACE ||
    type == TokenType.NEWLINE ||
    type == TokenType.TAB ||
    type == TokenType.EQUAL;
  
  bool isBlank() =>
    type == TokenType.WHITESPACE ||
    type == TokenType.NEWLINE || 
    type == TokenType.TAB;

  /// Checks whether this token is a (l)arge token
  bool isLToken() => !isSToken();

  /// Creates a new token using the supplied parameters
  Token({this.type, this.value});

  /// Creates a new token using the definition of a matcher
  Token.fromMatcher(List list)
    : type = list[1], value = list[0];

  /// Override the toString function for easy inspection
  @override
  String toString() => '($type $value)';
}

/// Searches the input [String] if any of the matchers finds a match at
/// position [i]. Returns the [Token], if one was found, or null.
Token _findMatches(List matchers, String s, int i) {
  for (var matcher in matchers) {
    // The matcher finds a match at position i
    if (s.startsWith(matcher[0], i))
      return Token.fromMatcher(matcher);
  }
  return null;
}

/// Finds the end of the next character set. Character sets are
/// discontinued by S tokens. See [TokenType] for more information.
/// The algorithm starts searching the [String] [s] at position [i]
String _nextSubstring(String s, int i) {
  // searches the first S token
  var spaceIndex = s.indexOf(RegExp('[ ()]'), i);
  if (spaceIndex == -1) spaceIndex = s.length;
  var sub = s.substring(i, spaceIndex);
  return sub.length == 0 ? null : sub;
}

/// Tries parsing a value token. Returns null if the parse fails.
/// The algorithm starts searching the [String] [s] at position [i].
Token _parseValue(String s, int i) {
  var sub = _nextSubstring(s, i);
  if (sub == null) return null;

  var parse = int.tryParse(sub);
  if (parse == null) return null;
  return Token(type: TokenType.VALUE, value: sub);
}

/// Tries parsing a identifier token. Returns null if the parse fails.
/// The algorithm starts searching the [String] [s] at position [i].
Token _parseIdent(String s, int i) {
  var sub = _nextSubstring(s, i);
  if (sub == null) return null;
  
  return Token(type: TokenType.IDENT, value: sub);
}

/// Adds an L token to the list of tokens. Throws an exception
/// if this L token would follow on another L token.
int _addLToken(Token lToken, List<Token> tokens) {
  if (lToken != null) {
    if (tokens.isNotEmpty && tokens.last.isLToken())
      throw Exception('Could not parse expression: two L tokens in a row');
    tokens.add(lToken);
    return lToken.value.length;
  }
  return 0;
}

/// Tokenizes the input [String] [s] by creating a List of tokens.
/// The function applies a list of matchers in the following order
/// 1. Is it a S token?
/// 2. Is it a L token?
/// 3. Is it a value?
/// 4. Is it an identifier?
List<Token> tokenize(String s) {
  const sMatchers = [
    [' ', TokenType.WHITESPACE],
    ['\n', TokenType.NEWLINE],
    ['\t', TokenType.TAB],
    ['(', TokenType.PARANTHESIS_OPEN],
    [')', TokenType.PARANTHESIS_CLOSE],
    ['=', TokenType.EQUAL]
  ];
  const lMatchers = [
    ['AND', TokenType.AND],
    ['OR', TokenType.OR],
    ['NOT', TokenType.NOT],
    ['XOR', TokenType.XOR],
    ['THEN', TokenType.THEN]
  ];

  var tokens = <Token>[ ];
  for (int i = 0; i < s.length;) {
    var sToken = _findMatches(sMatchers, s, i);
    if (sToken != null) {
      i += sToken.value.length; // advance the pointer
      tokens.add(sToken);
      continue;
    }

    var lToken = _findMatches(lMatchers, s, i);
    var advance = _addLToken(lToken, tokens);
    if (advance != 0) { i += advance; continue; }

    var valueToken = _parseValue(s, i);
    var valueAdvance = _addLToken(valueToken, tokens);
    if (valueAdvance != 0) { i += valueAdvance; continue; }

    var identToken = _parseIdent(s, i);
    var identAdvance = _addLToken(identToken, tokens);
    if (identAdvance != 0) { i += identAdvance; continue; }

    throw Exception('Unknown token at position $i');
  }
  return tokens;
}

//// EVALUATING SEGMENT ////

/// The context model stores variable/value paris.
class ContextModel {
  /// Stores the variable/value pairs
  final model = <String, int> {};
  /// Whether to assume fails if a variable is non existent
  bool assumeFalse;

  /// Creates a new [ContextModel] that assumes missing variables as false
  ContextModel({this.assumeFalse=true});

  /// Sets a [value] for the given [variable]
  void setVar(String variable, int value) {
    model[variable] = value;
  }

  /// Deletes a variable from this [ContextModel]
  void deleteVar(String variable) {
    model.remove(variable);
  }

  /// loads the given list of [vars] to the knowledge base
  void loadDefaultVars(Set<String> vars) {
    model.addEntries(
      vars.map((e) => MapEntry<String, int>(e, 0)));
  }

  /// Returns the value associated with the variable [name].
  /// Returns false if the variable is non existent and
  /// [assumeFalse] is true. Throws an exception otherwise.
  int getVar(String name) {
    if (!model.containsKey(name)) {
      if (assumeFalse) return 0;
      throw Exception('ContextModel does not contain variable $name');
    }
    return model[name];
  }
}

//// PARSING SEGMENT ////

/// Represents an element in the abstract syntaxt tree
class TreeElement {
  static int _funcAND(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) && elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int _funcOR(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) || elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int _funcXOR(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) != elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int _funcTHEN(TreeElement elem, ContextModel cm)
    => !elem.values[0].evaluateBool(cm) || elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int _funcNOT(TreeElement elem, ContextModel cm)
    => !elem.values[0].evaluateBool(cm) ? 1 : 0; 
  static int _funcIDENT(TreeElement elem, ContextModel cm) => cm.getVar(elem.values[0]); 
  static int _funcVALUE(TreeElement elem, ContextModel cm) => elem.values[0]; 
  static int _funcEQUAL(TreeElement elem, ContextModel cm) {
    var result = elem.values[1].evaluate(cm);
    cm.setVar(elem.values[0].values[0], result);
    return result;
  }
  static const Map<TokenType, int Function(TreeElement, ContextModel)> _evalMap = {
    TokenType.AND : _funcAND, TokenType.OR : _funcOR, TokenType.XOR : _funcXOR,
    TokenType.THEN : _funcTHEN, TokenType.NOT : _funcNOT, TokenType.IDENT: _funcIDENT,
    TokenType.VALUE: _funcVALUE, TokenType.EQUAL : _funcEQUAL
  };
  
  static String _stringINLINE(TreeElement elem, String ct) => '(${elem.values[0].istr()} $ct ${elem.values[1].istr()})';
  static String _stringAND(TreeElement elem) => _stringINLINE(elem, 'AND');
  static String _stringOR(TreeElement elem) => _stringINLINE(elem, 'OR');
  static String _stringXOR(TreeElement elem) => _stringINLINE(elem, 'XOR');
  static String _stringTHEN(TreeElement elem) => _stringINLINE(elem, 'THEN');
  static String _stringNOT(TreeElement elem)=> '(NOT ${elem.values[0].istr()})'; 
  static String _stringIDENT(TreeElement elem) => elem.values[0].toString();
  static String _stringVALUE(TreeElement elem) => elem.values[0].toString();
  static String _stringEQUAL(TreeElement elem) => _stringINLINE(elem, '=');
  static const Map<TokenType, String Function(TreeElement)> _stringMap = {
    TokenType.AND : _stringAND, TokenType.OR : _stringOR, TokenType.XOR : _stringXOR,
    TokenType.THEN : _stringTHEN, TokenType.NOT : _stringNOT, TokenType.IDENT: _stringIDENT,
    TokenType.VALUE: _stringVALUE, TokenType.EQUAL : _stringEQUAL
  };

  TokenType expression;
  List<dynamic> values;

  /// Creates an expression using a [TokenType] and a list of arguments
  TreeElement(this.expression, this.values);
  /// Creates a unary expression using a [TokenType] and a single value
  TreeElement.unary(this.expression, dynamic val)
    : values = [val];

  /// Evaluates the tree using the given [ContextModel]
  int evaluate(ContextModel model, {bool allowAssignment=true}) {
    if (!_evalMap.containsKey(expression))
      throw Exception('Unknwon expression $expression');
    return _evalMap[expression](this, model);
  }
  /// Evaluates the tree as a boolean using the given [ContextModel]
  bool evaluateBool(ContextModel model) => evaluate(model) != 0;

  Iterable<TreeElement> findOfType(TokenType type) sync* {
    if (expression == type)
      yield this;
    
    for (var child in values) {
      if (child is TreeElement)
        yield* child.findOfType(type);
    }
  }

  void replaceVarByValue(String ident, int value) {
    findOfType(TokenType.IDENT)
      .where((element) => element.values[0] == ident)
      .forEach((element) {
        element.expression = TokenType.VALUE;
        element.values[0] = value;
      });
  }

  /// Creates an infix notation [String] from this expression
  String istr() {
    if (!_stringMap.containsKey(expression))
      throw Exception('Unknwon expression $expression');
    return _stringMap[expression](this);
  } 

  /// Creates an infix notation [String] from this expression. See [istr].
  @override
  String toString() => istr();
}

class PReturn {
  int i;
  TreeElement x;
  PReturn(this.i, this.x);

  @override
  String toString() => '($i $x)';
}

Token _nextToken(List<Token> a, int i, {bool canBeNull=false}) {
  if (i >= a.length) {
    if (canBeNull) return null;
    throw Exception('Expected Token');
  }
  return a[i];
}

/// Parses a general infix element in the form A <operator> B.
PReturn _parseInfixElement(List<Token> a, int i, TokenType type, PReturn Function(List<Token>, int) subparser) {
  var r = subparser(a, i);
  var next = _nextToken(a, r.i, canBeNull: true);
  while (next?.type == type) {
    var r2 = subparser(a, r.i + 1);
    r = PReturn(r2.i, TreeElement(type, [r.x, r2.x]));
    next = _nextToken(a, r.i, canBeNull: true);
  }
  return r;
}

/// Parses an Atom, see the grammar for more information.
PReturn _parseAtom(List<Token> a, int i) {
  var t = _nextToken(a, i);
  if (t.type == TokenType.IDENT) {
    return PReturn(i + 1, TreeElement.unary(TokenType.IDENT, t.value));
  } else if (t.type == TokenType.VALUE) {
    var v = int.parse(t.value);
    return PReturn(i + 1, TreeElement.unary(TokenType.VALUE, v));
  } else if (t.type == TokenType.PARANTHESIS_OPEN) {
    var r = parseExpression(a, i + 1);
    if (_nextToken(a, r.i).type != TokenType.PARANTHESIS_CLOSE)
      throw Exception('Mismatching bracket');

    return PReturn(r.i + 1, r.x);
  } else {
    throw Exception('Unknown symbol');
  }
}

/// Parses a NOT statement, see the grammar for more information.
PReturn _parseNOT(List<Token> a, int i) {
  if (a[i].type == TokenType.NOT) {
    var r = _parseNOT(a, i + 1);
    return PReturn(r.i, TreeElement.unary(TokenType.NOT, r.x));
  }
  return _parseAtom(a, i);
}

/// Parses an AND statement, see the grammar for more information.
PReturn _parseAND(List<Token> a, int i) => _parseInfixElement(a, i, TokenType.AND, _parseNOT);
/// Parses a THEN statement, see the grammar for more information.
PReturn _parseTHEN(List<Token> a, int i) => _parseInfixElement(a, i, TokenType.THEN, _parseAND);
/// Parses a XOR statement, see the grammar for more information.
PReturn _parseXOR(List<Token> a, int i) => _parseInfixElement(a, i, TokenType.XOR, _parseTHEN);
/// Parses an OR statement, see the grammar for more information.
PReturn _parseOR(List<Token> a, int i) => _parseInfixElement(a, i, TokenType.OR, _parseXOR);
/// Parses an Expression, see the grammar for more information.
PReturn parseExpression(List<Token> a, int i) => _parseOR(a, i);

PReturn parseAssignment(List<Token> a, int i) => _parseInfixElement(a, i, TokenType.EQUAL, parseExpression);

void _checkAssignment(TreeElement elem) {
  if (elem.expression == TokenType.EQUAL) {
    if (!(elem.values[0] is TreeElement) || (elem.values[0].expression != TokenType.IDENT))
      throw Exception('Left side of assignment must be variable');
    _checkAssignment(elem.values[1]);
  }

  for (var child in elem.values) {
    if (child is TreeElement)
      _checkAssignment(child);
  }
}

TreeElement buildExpression(String exp) {
  // creates the list of tokens
  var tokens = tokenize(exp);
  tokens = tokens.where((element) => !element.isBlank()).toList();

  // parses the expression
  var ret = parseAssignment(tokens, 0);
  // checks if all elements have been used
  if (ret.i != tokens.length)
    throw Exception('Unexpected element at end of stream');
  _checkAssignment(ret.x);
  return  ret.x;
}
