import 'package:flutter/material.dart';

class DataWidget extends StatefulWidget {
  const DataWidget(
      {super.key,
      required this.isSelected,
      required this.date,
      required this.dayName,
      this.childrenWidgets});

  final bool isSelected;
  final String date;
  final String dayName;

  final List<Widget>? childrenWidgets;

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isSelected == true ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            width: 2,
            color: widget.isSelected == true ? Colors.black : Colors.grey),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                widget.date,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: widget.isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                widget.dayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: widget.isSelected ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
          ...?widget.childrenWidgets
        ],
      ),
    );
  }
}
