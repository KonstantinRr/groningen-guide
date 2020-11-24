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
/// 
/// Written by Konstantin Rolf 2020

/// This class gives all possible tokens that may be encountered in the input
/// message. Note that this list may be split into two different kinds of tokens.
/// 1. S tokens which are allowed at any point in the expression
/// 2. L tokens which need at least a single S token in between
enum TokenType {
  // S tokens, they are allowed everywhere
  PARANTHESIS_OPEN,
  PARANTHESIS_CLOSE,
  WHITESPACE,
  // L tokens, they require at least one S token in between
  AND, OR, XOR, THEN, NOT,
  IDENT, VALUE,
}


class Token {
  final TokenType type;
  final String value;
  /// Checks whether this token is a (s)mall token
  bool isSToken() => type == TokenType.PARANTHESIS_OPEN ||
    type == TokenType.PARANTHESIS_CLOSE || type == TokenType.WHITESPACE;
  /// Checks whether this token is a (l)arge token
  bool isLToken() => !isSToken();

  /// Creates a new token using the supplied parameters
  Token({this.type, this.value});
  /// Creates a new token using the definition of a matcher
  Token.fromMatcher(List list)
    : type = list[1], value = list[0];

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

/// Ret
String _nextSubstring(String s, int i) {
  var spaceIndex = s.indexOf(' ', i);
  if (spaceIndex == -1) spaceIndex = s.length;
  var sub = s.substring(i, spaceIndex);
  return sub.length == 0 ? null : sub;
}

Token parseValue(String s, int i) {
  var sub = _nextSubstring(s, i);
  if (sub == null) return null;

  var parse = int.tryParse(sub);
  if (parse == null) return null;
  return Token(type: TokenType.VALUE, value: sub);
}

Token parseIdent(String s, int i) {
  var sub = _nextSubstring(s, i);
  if (sub == null) return null;
  
  return Token(type: TokenType.IDENT, value: sub);
}

int _addLToken(Token lToken, List<Token> tokens) {
  if (lToken != null) {
    if (tokens.isNotEmpty && tokens.last.isLToken())
      throw Exception('Could not parse expression: two l tokens in a row');
    tokens.add(lToken);
    return lToken.value.length;
  }
  return 0;
}

List<Token> tokenize(String s) {
  const sMatchers = [
    [' ', TokenType.WHITESPACE],
    ['(', TokenType.PARANTHESIS_OPEN],
    [')', TokenType.PARANTHESIS_CLOSE],
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

    var valueToken = parseValue(s, i);
    var valueAdvance = _addLToken(valueToken, tokens);
    if (valueAdvance != 0) { i += valueAdvance; continue; }

    var identToken = parseIdent(s, i);
    var identAdvance = _addLToken(identToken, tokens);
    if (identAdvance != 0) { i += identAdvance; continue; }

    throw Exception('Unknown token at position $i');
  }
  return tokens;
}


class ContextModel {
  Map<String, int> model;
  bool assumeFalse;

  void setVar(String variable, int value) {
    model[variable] = value;
  }

  void deleteVar(String variable) {
    model.remove(variable);
  }

  int getVar(String name) {
    if (!model.containsKey(name)) {
      if (assumeFalse) return 0;
      throw Exception('ContextModel does not contain variable $name');
    }
    return model[name];
  }
}

class TreeElement {
  static int funcAND(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) && elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int funcOR(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) || elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int funcXOR(TreeElement elem, ContextModel cm)
    => elem.values[0].evaluateBool(cm) != elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int funcTHEN(TreeElement elem, ContextModel cm)
    => !elem.values[0].evaluateBool(cm) || elem.values[1].evaluateBool(cm) ? 1 : 0;
  static int funcNOT(TreeElement elem, ContextModel cm)
    => !elem.values[0].evaluateBool(cm) ? 1 : 0; 
  static int funcIDENT(TreeElement elem, ContextModel cm) => elem.values[0]; 
  static int funcVALUE(TreeElement elem, ContextModel cm) => cm.getVar(elem.values[0]); 

  static const Map<TokenType, int Function(TreeElement, ContextModel)> evalMap = {
    TokenType.AND : funcAND, TokenType.OR : funcOR, TokenType.XOR : funcXOR,
    TokenType.THEN : funcTHEN, TokenType.NOT : funcNOT, TokenType.IDENT: funcIDENT,
    TokenType.VALUE: funcVALUE,
  };
  
  static String stringINLINE(TreeElement elem, String ct) => '(${elem.values[0].istr()} $ct ${elem.values[1].istr()})';
  static String stringAND(TreeElement elem) => stringINLINE(elem, 'AND');
  static String stringOR(TreeElement elem) => stringINLINE(elem, 'OR');
  static String stringXOR(TreeElement elem) => stringINLINE(elem, 'XOR');
  static String stringTHEN(TreeElement elem) => stringINLINE(elem, 'THEN');
  static String stringNOT(TreeElement elem)=> '(NOT ${elem.values[0].istr()})'; 
  static String stringIDENT(TreeElement elem) => elem.values[0].toString();
  static String stringVALUE(TreeElement elem) => elem.values[0].toString();

  static const Map<TokenType, String Function(TreeElement)> stringMap = {
    TokenType.AND : stringAND, TokenType.OR : stringOR, TokenType.XOR : stringXOR,
    TokenType.THEN : stringTHEN, TokenType.NOT : stringNOT, TokenType.IDENT: stringIDENT,
    TokenType.VALUE: stringVALUE,
  };

  TokenType expression;
  List<dynamic> values;

  TreeElement(this.expression, this.values);
  TreeElement.unary(this.expression, dynamic val)
    : values = [val];

  int evaluate(ContextModel model) {
    if (!evalMap.containsKey(expression))
      throw Exception('Unknwon expression $expression');
    return evalMap[expression](this, model);
  }
  bool evaluateBool(ContextModel model) => evaluate(model) != 0;

  String istr() {
    if (!stringMap.containsKey(expression))
      throw Exception('Unknwon expression $expression');
    return stringMap[expression](this);
  } 

  @override
  String toString() => '$expression:[$values]';
}

class PReturn {
  int i;
  TreeElement x;
  PReturn(this.i, this.x);

  @override
  String toString() => '($i $x)';
}

Token nextToken(List<Token> a, int i, {bool canBeNull=false}) {
  if (i >= a.length) {
    if (canBeNull) return null;
    throw Exception('Expected Token');
  }
  return a[i];
}

//PReturn parseXOR(List<Token> a, int i) {
//
//}
//PReturn parseTHEN(List<Token> a, int i) {
//
//}
PReturn parseAtom(List<Token> a, int i) {
  var t = nextToken(a, i);
  if (t.type == TokenType.IDENT) {
    return PReturn(i + 1, TreeElement.unary(TokenType.IDENT, t.value));
  } else if (t.type == TokenType.VALUE) {
    return PReturn(i + 1, TreeElement.unary(TokenType.VALUE, t.value));
  } else if (t.type == TokenType.PARANTHESIS_OPEN) {
    var r = parseExpression(a, i + 1);
    if (nextToken(a, r.i).type != TokenType.PARANTHESIS_CLOSE)
      throw Exception('Mismatching bracket');

    return PReturn(r.i + 1, r.x);
  } else {
    throw Exception('Unknown symbol');
  }
}
PReturn parseNOT(List<Token> a, int i) {
  if (a[i].type == TokenType.NOT) {
    var r = parseNOT(a, i + 1);
    return PReturn(r.i, TreeElement.unary(TokenType.NOT, r.x));
  }
  return parseAtom(a, i);
}
PReturn parseAND(List<Token> a, int i) {
  var r = parseNOT(a, i);
  var next = nextToken(a, r.i, canBeNull: true);
  while (next?.type == TokenType.AND) {
    var r2 = parseNOT(a, r.i + 1);
    r = PReturn(r2.i, TreeElement(TokenType.AND, [r.x, r2.x]));
    next = nextToken(a, r.i, canBeNull: true);
  }
  return r;
}
PReturn parseOR(List<Token> a, int i) {
  var r = parseAND(a, i);
  var next = nextToken(a, r.i, canBeNull: true);
  while (next?.type == TokenType.OR) {
    var r2 = parseAND(a, r.i + 1);
    r = PReturn(r2.i, TreeElement(TokenType.OR, [r.x, r2.x]));
    next = nextToken(a, r.i, canBeNull: true);
  }
  return r;
}
PReturn parseExpression(List<Token> a, int i) {
  return parseOR(a, i);
}

TreeElement buildExpression(String exp) {
  // creates the list of tokens
  var tokens = tokenize(exp);
  tokens = tokens.where((element) => element.type != TokenType.WHITESPACE).toList();
  print(tokens);

  // parses the expression
  var ret = parseExpression(tokens, 0);
  print(ret.x);
  // checks if all elements have been used
  if (ret.i != tokens.length)
    throw Exception('Unexpected element at end of stream');
  return  ret.x;
}