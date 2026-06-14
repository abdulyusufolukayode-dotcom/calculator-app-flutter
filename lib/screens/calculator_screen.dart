import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;

  void _onButtonTap(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (value == '=') {
        _calculate();
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _setOperator(value);
      } else {
        _appendDigit(value);
      }
    });
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _firstOperand = 0;
    _operator = '';
    _shouldResetDisplay = false;
  }

  void _appendDigit(String digit) {
    if (_shouldResetDisplay) {
      _display = digit == '.' ? '0.' : digit;
      _shouldResetDisplay = false;
    } else {
      if (digit == '.' && _display.contains('.')) return;
      _display = _display == '0' && digit != '.'
          ? digit
          : _display + digit;
    }
  }

  void _setOperator(String op) {
    _firstOperand = double.tryParse(_display) ?? 0;
    _operator = op;
    _expression = '$_display $op';
    _shouldResetDisplay = true;
  }

  void _calculate() {
    if (_operator.isEmpty) return;
    final double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        if (secondOperand == 0) {
          _display = 'Error';
          _expression = '';
          _operator = '';
          return;
        }
        result = _firstOperand / secondOperand;
        break;
    }
    _display = result % 1 == 0
        ? result.toInt().toString()
        : result.toString();
    _expression = '';
    _operator = '';
    _shouldResetDisplay = true;
  }

  final List<List<String>> _buttons = [
    ['C', '±', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['0', '.', '='],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 72,
                          fontWeight: FontWeight.w200,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: _buttons.map((row) {
                    return Expanded(
                      child: Row(
                        children: row.map((label) {
                          return Expanded(
                            flex: label == '0' ? 2 : 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: CalcButton(
                                label: label,
                                onTap: () => _onButtonTap(label),
                                buttonType: _getButtonType(label),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonType _getButtonType(String label) {
    if (label == 'C' || label == '±' || label == '%') {
      return ButtonType.function;
    } else if (['+', '-', '×', '÷', '='].contains(label)) {
      return ButtonType.operator;
    }
    return ButtonType.number;
  }
}