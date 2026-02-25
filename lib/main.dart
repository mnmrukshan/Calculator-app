import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart' hide Stack;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ModernGlassCalculator(),
  ));
}

class ModernGlassCalculator extends StatefulWidget {
  const ModernGlassCalculator({super.key});

  @override
  _ModernGlassCalculatorState createState() => _ModernGlassCalculatorState();
}

class _ModernGlassCalculatorState extends State<ModernGlassCalculator> {
  String equation = "0";
  String result = "0";

  void onBtnClick(String val) {
    setState(() {
      if (val == "C") {
        equation = "0";
        result = "0";
      } else if (val == "=") {
        try {
          String finalEquation = equation.replaceAll('x', '*');
          Parser p = Parser();
          Expression exp = p.parse(finalEquation);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
          if (result.endsWith(".0")) {
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = val;
        } else {
          equation += val;
        }
      }
    });
  }

  Widget buildGlassBtn(String txt, Color clr, {bool isLarge = false}) {
    return Expanded(
      flex: isLarge ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => onBtnClick(txt),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  color: clr.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    txt,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background blobs for glass effect
            Positioned(
              top: 100,
              right: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent.withOpacity(0.25),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        equation,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 32),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        result,
                        style: const TextStyle(color: Colors.white, fontSize: 85, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, thickness: 1, indent: 30, endIndent: 30),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(children: [
                        buildGlassBtn("C", Colors.redAccent),
                        buildGlassBtn("(", Colors.white10),
                        buildGlassBtn(")", Colors.white10),
                        buildGlassBtn("/", Colors.orangeAccent),
                      ]),
                      Row(children: [
                        buildGlassBtn("7", Colors.white10),
                        buildGlassBtn("8", Colors.white10),
                        buildGlassBtn("9", Colors.white10),
                        buildGlassBtn("x", Colors.orangeAccent),
                      ]),
                      Row(children: [
                        buildGlassBtn("4", Colors.white10),
                        buildGlassBtn("5", Colors.white10),
                        buildGlassBtn("6", Colors.white10),
                        buildGlassBtn("-", Colors.orangeAccent),
                      ]),
                      Row(children: [
                        buildGlassBtn("1", Colors.white10),
                        buildGlassBtn("2", Colors.white10),
                        buildGlassBtn("3", Colors.white10),
                        buildGlassBtn("+", Colors.orangeAccent),
                      ]),
                      Row(children: [
                        buildGlassBtn("0", Colors.white10, isLarge: true),
                        buildGlassBtn(".", Colors.white10),
                        buildGlassBtn("=", Colors.greenAccent),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}