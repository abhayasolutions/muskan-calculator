import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = "";
  final List<String> specialChars = ["%", "*", "/", "-", "+", "="];

  // Define function to calculate based on button clicked.
  void calculate(String btnValue) {
    setState(() {
      if (btnValue == "=" && output.isNotEmpty) {
        // If output has '%', replace with '/100' before evaluating.
        Parser p = Parser();
        Expression exp = p.parse(output.replaceAll("%", "/100"));
        output = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
      } else if (btnValue == "AC") {
        output = "";
      } else if (btnValue == "DEL") {
        // If DEL button is clicked, remove the last character from the output.
        output = output.substring(0, output.length - 1);
      } else {
        // If output is empty and button is specialChars then return
        if (output.isEmpty && specialChars.contains(btnValue)) return;
        output += btnValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 300),
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CalculatorDisplay(output: output),
              SizedBox(height: 10),
              Expanded(
                child: CalculatorButtons(
                  buttons: buttons,
                  onPressed: calculate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> buttons = [
    "AC", "DEL", "%", "/",
    "7", "8", "9", "*",
    "4", "5", "6", "-",
    "1", "2", "3", "+",
    "0", "00", ".", "=",
  ];
}

class CalculatorDisplay extends StatelessWidget {
  final String output;

  CalculatorDisplay({required this.output});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: output),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      style: TextStyle(fontSize: 25, color: Colors.black),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final List<String> buttons;
  final Function(String) onPressed;

  CalculatorButtons({required this.buttons, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        String btnValue = buttons[index];
        return ElevatedButton(
          onPressed: () => onPressed(btnValue),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),
            primary: Colors.grey[300],
          ),
          child: Text(
            btnValue,
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
