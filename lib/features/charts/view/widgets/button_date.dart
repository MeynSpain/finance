import 'package:flutter/material.dart';

class ButtonDate extends StatefulWidget {
  ButtonDate(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.isActive});

  final String text;
  final VoidCallback onPressed;
  bool isActive;

  @override
  State<ButtonDate> createState() => _ButtonDateState();
}

class _ButtonDateState extends State<ButtonDate> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: widget.onPressed,
      child: Text(widget.text),
      style: TextButton.styleFrom(
        textStyle: theme.textTheme.bodyMedium,
        foregroundColor: widget.isActive ? Colors.purple : Colors.black,
      ),
    );
  }
}
