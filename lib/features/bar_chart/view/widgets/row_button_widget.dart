import 'package:finance/core/constants/date_type.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/view/widgets/button_date_widget.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RowButtonWidget extends StatefulWidget {
  const RowButtonWidget({super.key});

  @override
  State<RowButtonWidget> createState() => _RowButtonWidgetState();
}

class _RowButtonWidgetState extends State<RowButtonWidget> {
  final List<bool> _activeList = [false, false, false];

  @override
  void initState() {
    _toggleValueInList(_activeList, 2);
    super.initState();
  }

  void _toggleValueInList(List<bool> list, int index) {
    for (int i = 0; i < list.length; i++) {
      if (index != i) {
        list[i] = false;
      } else {
        list[i] = true;
      }
    }
  }

  void _getTransactionsByDate(
      DateTime startDate, DateTime endDate, DateType dateType) {
    getIt<BarChartBloc>().add(
      BarChartGetTransactionsByDateEvent(
        startDate: startDate,
        endDate: endDate,
        userUid: FirebaseAuth.instance.currentUser!.uid,
        rootCategoryUid: getIt<CategoriesBloc>().state.currentCategory!.uid!,
        dateType: dateType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ButtonDateWidget(
              text: 'По годам',
              onPressed: () {
                setState(() {
                  _toggleValueInList(_activeList, 0);
                });

                DateTime endDate = DateTime.now();
                DateTime startDate = DateTime(endDate.year - 4, 1, 1);

                _getTransactionsByDate(startDate, endDate, DateType.year);

                getIt<Talker>().info('DATE: $startDate');
              },
              isActive: _activeList[0],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ButtonDateWidget(
              text: 'По месяцам',
              onPressed: () {
                setState(() {
                  _toggleValueInList(_activeList, 1);
                });
                DateTime endDate = DateTime.now();
                DateTime startDate = DateTime(endDate.year, endDate.month - 4, 1);

                _getTransactionsByDate(startDate, endDate, DateType.month);

                getIt<Talker>().info('DATE: $startDate');
                getIt<Talker>().info('DATE: $endDate');

              },
              isActive: _activeList[1],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ButtonDateWidget(
              text: 'По дням',
              onPressed: () {
                setState(() {
                  _toggleValueInList(_activeList, 2);
                });
                DateTime endDate = DateTime.now();
                DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day - 4);

                _getTransactionsByDate(startDate, endDate, DateType.weekDay);

                getIt<Talker>().info('DATE: $startDate');

              },
              isActive: _activeList[2],
            ),
          ),
        ],
      ),
    );
  }
}
