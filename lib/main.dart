import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart' hide Stack;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PremiumCalculator(),
  ));
}

class PremiumCalculator extends StatefulWidget {
  const PremiumCalculator({super.key});

  @override
  State<PremiumCalculator> createState() => _PremiumCalculatorState();
}

class _PremiumCalculatorState extends State<PremiumCalculator> {
  String equation = "0";
  String result = "0";

  void onBtnClick(String val) {
    setState(() {
      if (val == "AC") {
        equation = "0";
        result = "0";
      } else if (val == "=") {
        try {
          // Replace display symbols with math logic symbols
          String finalEquation = equation
              .replaceAll('x', '*')
              .replaceAll('÷', '/')
              .replaceAll('sin(', 'sin(')
              .replaceAll('cos(', 'cos(')
              .replaceAll('tan(', 'tan(')
              .replaceAll('%', '/100');

          // Check if brackets are closed, if not close them automatically
          int openBrackets = '('.allMatches(finalEquation).length;
          int closeBrackets = ')'.allMatches(finalEquation).length;
          while (openBrackets > closeBrackets) {
            finalEquation += ')';
            closeBrackets++;
          }

          Parser p = Parser();
          Expression exp = p.parse(finalEquation);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          
          result = eval.toString();
          if (result.endsWith(".0")) result = result.substring(0, result.length - 2);
        } catch (e) {
          result = "Syntax Error"; 
        }
      } else {
        // Smart Scientific Logic: Adds function with opening bracket
        if (val == "sin" || val == "cos" || val == "tan") {
          equation = (equation == "0") ? "$val(" : equation + "$val(";
        } else if (equation == "0") {
          equation = val;
        } else {
          equation += val;
        }
      }
    });
  }

  Widget buildButton(String text, Color bgColor, {Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () => onBtnClick(text),
          borderRadius: BorderRadius.circular(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor, 
                      fontSize: 18, 
                      fontWeight: FontWeight.w300, // Thin font for 2026 look
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020408),
      body: SafeArea(
        child: Column(
          children: [
            // --- DISPLAY SECTION ---
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(equation, style: const TextStyle(color: Colors.white38, fontSize: 24, fontWeight: FontWeight.w200)),
                      const SizedBox(height: 12),
                      Text(result, style: const TextStyle(color: Colors.white, fontSize: 58, fontWeight: FontWeight.w100)),
                    ],
                  ),
                ),
              ),
            ),
            // --- BUTTONS SECTION ---
            Container(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row 1: Scientific Functions
                  Row(children: [
                    buildButton("sin", Colors.white), 
                    buildButton("cos", Colors.white), 
                    buildButton("tan", Colors.white), 
                    buildButton("%", Colors.white)
                  ]),
                  // Row 2: Numbers and Operator
                  Row(children: [
                    buildButton("7", Colors.white), 
                    buildButton("8", Colors.white), 
                    buildButton("9", Colors.white), 
                    buildButton("÷", Colors.blueAccent)
                  ]),
                  // Row 3: Numbers and Operator
                  Row(children: [
                    buildButton("4", Colors.white), 
                    buildButton("5", Colors.white), 
                    buildButton("6", Colors.white), 
                    buildButton("x", Colors.blueAccent)
                  ]),
                  // Row 4: Numbers and Operator
                  Row(children: [
                    buildButton("1", Colors.white), 
                    buildButton("2", Colors.white), 
                    buildButton("3", Colors.white), 
                    buildButton("-", Colors.blueAccent)
                  ]),
                  // Row 5: AC, Zero, Dot and Plus
                  Row(children: [
                    buildButton("AC", Colors.white, textColor: Colors.redAccent),
                    buildButton("0", Colors.white), 
                    buildButton(".", Colors.white), 
                    buildButton("+", Colors.blueAccent)
                  ]),
                  // Row 6: Equals
                  Row(children: [buildButton("=", Colors.blueAccent)]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}