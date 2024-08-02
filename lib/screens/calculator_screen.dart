import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() {
    return _CalculatorScreenState();
  }
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operator = "";
  String number2 = "";

  // ####################################
  Widget buttonValue(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: getBtnColor(value),
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => btnOnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ####################################
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.subtract,
            Btn.add,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  // ####################################

  void btnOnTap(String value) {
    if (value == Btn.del) {
      delete(value);
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

// ############
// calculate
  void calculate() {
    if (number1.isEmpty) return;
    if (operator.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;

    switch (operator) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;

      default:
    }
    setState(() {
      number1 = '$result';

      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operator = "";
      number2 = "";
    });
  }

  // ############
  // convert output to %
  void convertToPercentage() {
    if (number1.isNotEmpty && number2.isNotEmpty && operator.isNotEmpty) {
      calculate();
    }

    if (operator.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);

    setState(() {
      number1 = "${(number / 100)}";
      operator = "";
      number2 = '';
    });
  }

  // ##############################
  // clear all the values
  void clearAll() {
    setState(() {
      number1 = "";
      operator = "";
      number2 = "";
    });
  }

  // ##################################
  // delete one from the end
  void delete(String value) {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  // ####################################
  void appendValue(String value) {
    // number1 operator number2
    // 10         +       10

    if (value != Btn.dot && int.tryParse(value) == null) {
      //
      if (operator.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operator = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operator.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;

      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" || "0"
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operator.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;

      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number1 = "" || "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //..output...
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    textAlign: TextAlign.end,
                    '$number1$operator$number2'.isEmpty
                        ? '0'
                        : '$number1$operator$number2',
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            //.....buttons....
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buttonValue(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
