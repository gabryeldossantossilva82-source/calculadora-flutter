import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  double? firstNumber;
  String? operator;
  bool dark = true;

  void numberPressed(String value) {
    setState(() {
      if (display == '0' || display == 'Erro') {
        display = value;
      } else {
        display += value;
      }
    });
  }

  void decimal() {
    setState(() {
      if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void selectOperator(String op) {
    setState(() {
      firstNumber = double.tryParse(display);
      operator = op;
      display = '0';
    });
  }

  void calculate() {
    if (firstNumber == null || operator == null) return;

    double secondNumber = double.tryParse(display) ?? 0;
    double result = 0;

    switch (operator) {
      case '+':
        result = firstNumber! + secondNumber;
        break;
      case '-':
        result = firstNumber! - secondNumber;
        break;
      case '×':
        result = firstNumber! * secondNumber;
        break;
      case '÷':
        if (secondNumber == 0) {
          setState(() {
            display = 'Erro';
            firstNumber = null;
            operator = null;
          });
          return;
        }
        result = firstNumber! / secondNumber;
        break;
    }

    setState(() {
      if (result % 1 == 0) {
        display = result.toInt().toString();
      } else {
        display = result.toStringAsFixed(2);
      }

      firstNumber = null;
      operator = null;
    });
  }

  void clear() {
    setState(() {
      display = '0';
      firstNumber = null;
      operator = null;
    });
  }

  void percent() {
    setState(() {
      double value = double.tryParse(display) ?? 0;
      display = (value / 100).toString();
    });
  }

  void changeSignal() {
    setState(() {
      if (display != '0') {
        if (display.startsWith('-')) {
          display = display.substring(1);
        } else {
          display = '-$display';
        }
      }
    });
  }

  void backspace() {
    setState(() {
      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = '0';
      }
    });
  }

  Widget button(
    String text, {
    VoidCallback? onPressed,
    bool blue = false,
    bool gray = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: blue
                ? const Color(0xFF4655FF)
                : gray
                    ? (dark
                        ? const Color(0xFF55555D)
                        : const Color(0xFFD5D9DC))
                    : (dark
                        ? const Color(0xFF29292F)
                        : Colors.white),
            foregroundColor: dark || blue ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: FittedBox(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget calculatorRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        children: buttons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          dark ? const Color(0xFF15151B) : const Color(0xFFEFF7F7),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
              maxHeight: 750,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              children: [
                // Botão de tema
                SizedBox(
                  height: 35,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        dark = !dark;
                      });
                    },
                    child: Container(
                      width: 58,
                      height: 30,
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF44444D)
                            : const Color(0xFFD5D9DC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment:
                            dark ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: dark
                                ? const Color(0xFF303038)
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            dark ? Icons.dark_mode : Icons.light_mode,
                            size: 17,
                            color: const Color(0xFF4655FF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Display
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        display,
                        style: TextStyle(
                          fontSize: 65,
                          fontWeight: FontWeight.w300,
                          color: dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Botões
                calculatorRow([
                  button('C', onPressed: clear, gray: true),
                  button('±', onPressed: changeSignal, gray: true),
                  button('%', onPressed: percent, gray: true),
                  button(
                    '÷',
                    onPressed: () => selectOperator('÷'),
                    blue: true,
                  ),
                ]),

                calculatorRow([
                  button('7', onPressed: () => numberPressed('7')),
                  button('8', onPressed: () => numberPressed('8')),
                  button('9', onPressed: () => numberPressed('9')),
                  button(
                    '×',
                    onPressed: () => selectOperator('×'),
                    blue: true,
                  ),
                ]),

                calculatorRow([
                  button('4', onPressed: () => numberPressed('4')),
                  button('5', onPressed: () => numberPressed('5')),
                  button('6', onPressed: () => numberPressed('6')),
                  button(
                    '−',
                    onPressed: () => selectOperator('-'),
                    blue: true,
                  ),
                ]),

                calculatorRow([
                  button('1', onPressed: () => numberPressed('1')),
                  button('2', onPressed: () => numberPressed('2')),
                  button('3', onPressed: () => numberPressed('3')),
                  button(
                    '+',
                    onPressed: () => selectOperator('+'),
                    blue: true,
                  ),
                ]),

                calculatorRow([
                  button('.', onPressed: decimal),
                  button('0', onPressed: () => numberPressed('0')),
                  button('⌫', onPressed: backspace, gray: true),
                  button(
                    '=',
                    onPressed: calculate,
                    blue: true,
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
