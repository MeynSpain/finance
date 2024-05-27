import 'package:finance/core/injection.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/view/widgets/data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RowDataWidgets extends StatefulWidget {
  const RowDataWidgets({super.key});

  @override
  State<RowDataWidgets> createState() => _RowDataWidgetsState();
}

class _RowDataWidgetsState extends State<RowDataWidgets> {
  DateTime today = DateTime.now();

  late DateTime yesterday;

  int selectedIndex = 0;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    yesterday = DateTime(today.year, today.month, today.day - 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });

                getIt<CategoriesBloc>()
                    .add(CategoriesSelectNewDateEvent(newDate: today));
              },
              child: DataWidget(
                isSelected: selectedIndex == 0 ? true : false,
                date: '${today.day}.${today.month}',
                dayName: 'Сегодня',
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });

                getIt<CategoriesBloc>()
                    .add(CategoriesSelectNewDateEvent(newDate: yesterday));
              },
              child: DataWidget(
                isSelected: selectedIndex == 1 ? true : false,
                date: '${yesterday.day}.${yesterday.month}',
                dayName: 'Вчера',
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  selectedIndex = 2;
                });

                DateTime? dateTime = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(3000),
                  initialDate: selectedDate,
                );

                if (dateTime != null) {
                  setState(() {
                    selectedDate = dateTime;
                  });

                  getIt<CategoriesBloc>()
                      .add(CategoriesSelectNewDateEvent(newDate: selectedDate));
                }
              },
              child: DataWidget(
                isSelected: selectedIndex == 2 ? true : false,
                date: selectedIndex == 2
                    ? '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'
                    : 'Выбрать',
                dayName: selectedIndex == 2 ? 'Выбранная' : 'дату',
                childrenWidgets: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.date_range_rounded,
                    color: selectedIndex == 2 ? Colors.white : Colors.black,
                    size: 30,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
