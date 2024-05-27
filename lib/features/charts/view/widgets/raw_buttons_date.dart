import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/charts/view/widgets/button_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RawButtonsDate extends StatefulWidget {
  RawButtonsDate({
    super.key,
    required this.startIndex,
    required this.userUid,
    required this.rootCategoryUid,
    required this.type,
  });

  final int startIndex;
  final String userUid;
  final String rootCategoryUid;
  String type;

  @override
  State<RawButtonsDate> createState() => _RawButtonsDateState();
}

class _RawButtonsDateState extends State<RawButtonsDate> {
  List<bool> selectedList = [false, false, false, false];

  DateTimeRange selectedDays = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    selectedList[widget.startIndex] = true;
    super.initState();
  }

  void toggleValueInList(List<bool> list, int index) {
    for (int i = 0; i < list.length; i++) {
      if (index != i) {
        list[i] = false;
      } else {
        list[i] = true;
      }
    }
  }

  void getTransactionsByDate(DateTime startDate, DateTime endDate) {
    getIt<ChartsBloc>().add(ChartsGetTransactionByDateEvent(
      startDate: startDate,
      endDate: endDate,
      rootCategoryUid: widget.rootCategoryUid,
      userUid: widget.userUid,
      type: widget.type,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonDate(
          text: Globals.buttonDataDay,
          isActive: selectedList[0],
          onPressed: () {
            setState(() {
              toggleValueInList(selectedList, 0);
            });
            DateTime endDate = DateTime.now();
            DateTime startDate =
                DateTime(endDate.year, endDate.month, endDate.day);

            getTransactionsByDate(startDate, endDate);
          },
        ),
        ButtonDate(
          text: Globals.buttonDataWeek,
          isActive: selectedList[1],
          onPressed: () {
            setState(() {
              toggleValueInList(selectedList, 1);
            });
            DateTime endDate = DateTime.now();
            DateTime startDate =
                DateTime(endDate.year, endDate.month, endDate.day - 7);

            getIt<Talker>().info('$startDate   -    $endDate');

            getTransactionsByDate(startDate, endDate);
          },
        ),
        ButtonDate(
          text: Globals.buttonDataMonth,
          isActive: selectedList[2],
          onPressed: () {
            setState(() {
              toggleValueInList(selectedList, 2);
            });
            DateTime endDate = DateTime.now();
            DateTime startDate = DateTime(endDate.year, endDate.month, 1);

            getTransactionsByDate(startDate, endDate);
          },
        ),
        ButtonDate(
          text: Globals.buttonDataPeriod,
          isActive: selectedList[3],
          onPressed: () async {
            setState(() {
              toggleValueInList(selectedList, 3);
            });

            DateTimeRange? dateTimeRage = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(3000),
            );

            if (dateTimeRage != null) {
              setState(() {
                selectedDays = dateTimeRage;
              });
              getTransactionsByDate(selectedDays.start, selectedDays.end);
            }

            getIt<Talker>().info('${selectedDays.start}  - ${selectedDays.end}');
          },
        ),
        // Text('${selectedDays.start} - ${selectedDays.end}'),
      ],
    );
  }
}
