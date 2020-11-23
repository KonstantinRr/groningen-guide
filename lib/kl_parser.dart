/// This project is build during the course Knowledge Technology Practical at the
/// UNIVERSITY OF GRONINGEN (WBAI014-05).
/// The project was build by:
/// Konstantin Rolf (S3750558) k.rolf@student.rug.nl
/// Nicholas Koundouros (S3726444) n.koundouros@student.rug.nl
/// Livia Regus (S3354970): l.regus@student.rug.nl

import 'package:math_expressions/math_expressions.dart';

enum TokenType {
  AND, OR, XOR, THEN, NOT,
  PARANTHESIS_OPEN,
  PARANTHESIS_CLOSE,
  WHITESPACE,
}

class Token {
  final TokenType type;
  final String name;

  bool isSToken() => type == TokenType.PARANTHESIS_OPEN ||
    type == TokenType.PARANTHESIS_CLOSE || type == TokenType.WHITESPACE;
  bool isLToken() => !isSToken();

  Token({this.type, this.name});
  Token.fromMatcher(List list)
    : type = list[0], name = list[1];
}

Token findMatches(List matchers, String s, int i) {
  for (var matcher in matchers) {
    // The token and the string match
    if (s.startsWith(matcher[0], i)) {
      return Token.fromMatcher(matcher);
    }
  }
  return null;
}

class TreeElement {
  TokenType expression;
  TreeElement arg1, arg2;

  TreeElement(this.expression, this.arg1, this.arg2);
  TreeElement.unary(this.expression, this.arg1);
}

class PReturn {
  int i;
  TreeElement x;
  PReturn(this.i, this.x);
}
//PReturn parseXOR(List<Token> a, int i) {
//
//}
//PReturn parseTHEN(List<Token> a, int i) {
//
//}
PReturn parseBracket(List<Token> a, int i) {
  if (a[i].type == TokenType.PARANTHESIS_OPEN) {
    var r = parseExpression(a, i + 1);
    if (a[r.i].type != TokenType.PARANTHESIS_CLOSE)
      throw Exception('Mismatching bracket');

    return PReturn(r.i + 1, r.x);
  }
}
PReturn parseNOT(List<Token> a, int i) {
  if (a[i].type == TokenType.NOT) {
    var r = parseBracket(a, i + 1);
    return PReturn(r.i, TreeElement.unary(TokenType.NOT, r.x));
  }
  return parseBracket(a, i);
}
PReturn parseAND(List<Token> a, int i) {
  var r = parseNOT(a, i);
  while (a[r.i].type == TokenType.AND) {
    var r2 = parseNOT(a, i + 1);
    r = PReturn(r2.i, TreeElement(TokenType.AND, r.x, r2.x));
  }
  return r;
}
PReturn parseOR(List<Token> a, int i) {
  var r = parseAND(a, i);
  while (a[r.i].type == TokenType.OR) {
    var r2 = parseAND(a, i + 1);
    r = PReturn(r2.i, TreeElement(TokenType.OR, r.x, r2.x));
  }
  return r;
}
PReturn parseExpression(List<Token> a, int i) {
  return parseOR(a, i);
}

void tokenize(String s) {
  const sMatchers = [
    [' ', TokenType.WHITESPACE],
    ['(', TokenType.PARANTHESIS_OPEN],
    [')', TokenType.PARANTHESIS_CLOSE],
  ];
  const lMatchers = [
    ['AND', TokenType.AND],
    ['OR', TokenType.OR],
    ['XOR', TokenType.XOR],
    ['THEN', TokenType.THEN]
  ];

  var tokens = <Token>[ ];
  for (int i = 0; i < s.length;) {
    var sToken = findMatches(sMatchers, s, i);
    if (sToken != null) {
      i += sToken.name.length; // advance the pointer
      tokens.add(sToken);
      continue;
    }

    var lToken = findMatches(lMatchers, s, i);
    if (lToken != null) {
      if (tokens.isNotEmpty && tokens.last.isLToken())
        throw Exception('Could not parse expression: two l tokens in a row at position $i');
      i += lToken.name.length;
      tokens.add(lToken);
      continue;
    }

    throw Exception('Unknown token at position $i');
  }
}

class KlExpression {

}

class KlParser {

}