import 'package:flutter/material.dart';

enum ButtonType { number, operator, function }

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ButtonType buttonType;

  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.buttonType = ButtonType.number,
  });

  Color _backgroundColor() {
    switch (buttonType) {
      case ButtonType.function:
        return const Color(0xFFA5A5A5);
      case ButtonType.operator:
        return const Color(0xFFFF9F0A);
      case ButtonType.number:
        return const Color(0xFF333333);
    }
  }

  Color _foregroundColor() {
    return buttonType == ButtonType.function ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _foregroundColor(),
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}