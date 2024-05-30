import 'package:flutter/material.dart';

class ButtonDateWidget extends StatefulWidget {
  ButtonDateWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isActive,
  });

  final String text;
  final VoidCallback onPressed;
  bool isActive;

  @override
  State<ButtonDateWidget> createState() => _ButtonDateWidgetState();
}

class _ButtonDateWidgetState extends State<ButtonDateWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: widget.isActive ? Colors.black : Colors.white,
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Column(
          children: [
            Text(
              widget.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: widget.isActive ? Colors.white : Colors.black,
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: 2,
              width: widget.isActive
                  ? _calculateTextSize(widget.text, theme.textTheme.bodyMedium!)
                      .width
                  : 0,
              // Adjust the width as needed
              color: widget.isActive ? Colors.white : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Size _calculateTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }
}
