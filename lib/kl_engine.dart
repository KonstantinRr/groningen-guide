

import 'package:groningen_guide/kl/kl_base.dart';
import 'package:math_expressions/math_expressions.dart';

class KlEngine {
  KlBase klBase;

  KlEngine(this.klBase);


}

void a() {
  Parser p = Parser();
  Expression exp = p.parse("(x^2 + cos(y)) / 3");

  ContextModel cm = ContextModel();
  Variable x = Variable('x'), y = Variable('y'), z = Variable('z');

  cm.bindVariable(x, Number(2.0));
  //cm.bindVariable(y, Number(3.141));

  print(exp.evaluate(EvaluationType.REAL, cm));
}