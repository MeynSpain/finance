import 'package:flutter/material.dart';

class ListItemContainer extends StatelessWidget {
  const ListItemContainer(
      {super.key,
      this.margin,
      this.padding,
      this.boxDecoration,
      required this.leftText,
      required this.rightText,
      this.textOverflow,
      this.leftTextStyle,
      this.rightTextStyle});

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? boxDecoration;
  final String leftText;
  final String rightText;
  final TextOverflow? textOverflow;
  final TextStyle? leftTextStyle;
  final TextStyle? rightTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin,
      padding: padding,
      decoration: boxDecoration ??
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 2),
          ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftText,
              overflow: textOverflow ?? TextOverflow.ellipsis,
              style: leftTextStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              rightText,
              style: rightTextStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
