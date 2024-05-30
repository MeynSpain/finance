import 'package:finance/core/constants/date_type.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class BarChartService {

  /// Возращает Map, который будет содежать в себе все транзакции по годам
  Map<DateTime, List<TransactionModel>> getTransactionsByYear(
      List<TransactionModel> transactions) {
    Map<DateTime, List<TransactionModel>> transactionsByYear = {};

    for (TransactionModel transaction in transactions) {
      DateTime? date = transaction.timestamp?.toDate();

      if (date != null) {
        DateTime monthKey = DateTime(date.year);
        if (!transactionsByYear.containsKey(monthKey)) {
          transactionsByYear[monthKey] = [];
        }
        transactionsByYear[monthKey]!.add(transaction);
      }
    }

    return transactionsByYear;
  }

  /// Возращает Map, который будет содежать в себе все транзакции по месяцам
  Map<DateTime, List<TransactionModel>> getTransactionsByMonth(
      List<TransactionModel> transactions) {
    Map<DateTime, List<TransactionModel>> transactionsByMonth = {};

    for (TransactionModel transaction in transactions) {
      DateTime? date = transaction.timestamp?.toDate();

      if (date != null) {
        DateTime monthKey = DateTime(date.year, date.month);
        if (!transactionsByMonth.containsKey(monthKey)) {
          transactionsByMonth[monthKey] = [];
        }
        transactionsByMonth[monthKey]!.add(transaction);
      }
    }

    return transactionsByMonth;
  }

  Map<DateTime, List<TransactionModel>> getTransactionsByDay(
      List<TransactionModel> transactions) {
    Map<DateTime, List<TransactionModel>> transactionsByDay = {};

    for (TransactionModel transaction in transactions) {
      DateTime? date = transaction.timestamp?.toDate();

      if (date != null) {
        DateTime dayKey = DateTime(date.year, date.month, date.day);
        if (!transactionsByDay.containsKey(dayKey)) {
          transactionsByDay[dayKey] = [];
        }
        transactionsByDay[dayKey]!.add(transaction);
      }
    }

    return transactionsByDay;
  }

  /// Разделяет на 2 map-а. Map [transactions] остается нетронутым
  void splitIntoIncomeMapAndExpenseMap(
      {required Map<DateTime, List<TransactionModel>> transactions,
      required Map<DateTime, List<TransactionModel>> mapIncome,
      required Map<DateTime, List<TransactionModel>> mapExpense}) {
    for (var transaction in transactions.entries) {
      if (!mapIncome.containsKey(transaction.key)) {
        mapIncome[transaction.key] = [];
      }
      if (!mapExpense.containsKey(transaction.key)) {
        mapExpense[transaction.key] = [];
      }
      for (TransactionModel transactionModel in transaction.value) {
        if (transactionModel.type == Globals.typeTransactionsIncome) {
          mapIncome[transaction.key]?.add(transactionModel);
        } else if (transactionModel.type == Globals.typeTransactionsExpense) {
          mapExpense[transaction.key]?.add(transactionModel);
        }
      }
    }
  }

  BarChartGroupData makeGroupData(
      {required int x,
      required double y1,
      required double y2,
      required Color colorLeft,
      required Color colorRight}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red,
        ),
      ],
    );
  }

  DateTime _addDuration(DateTime date, DateType dateType, int value) {
    switch (dateType) {
      case DateType.weekDay:
        return date.add(Duration(days: value));
      case DateType.month:
        return DateTime(date.year, date.month + value, date.day);
      case DateType.year:
        return DateTime(date.year + value, date.month, date.day);
    }
  }

  void addEmptyDateInMap({
    required Map<DateTime, List<TransactionModel>> transactionMap,
    required DateType dateType,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = _addDuration(date, dateType, 1)) {
      if (!transactionMap.containsKey(date)) {
        transactionMap[date] = [];
      }
    }
    getIt<Talker>().info(transactionMap);
  }

  /// Возвращает список [BarChartRodData],которые являются столбцами в диаграмме.
  /// Подразумевается,что ключи в [mapIncome] и [mapExpense] совпадают.
  /// [dateType] - Отвечает за период, который будет указываться для оси Ox,
  /// такие как День, неделя, месяц, год и тп.
  List<BarChartGroupData> getListGroupData({
    required Map<DateTime, List<TransactionModel>> mapIncome,
    required Map<DateTime, List<TransactionModel>> mapExpense,
    required DateType dateType,
  }) {
    List<BarChartGroupData> resultList = [];

    List<DateTime> sortedKeys = mapIncome.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    for (var date in sortedKeys) {
      List<TransactionModel>? transactionsIncome = mapIncome[date];
      List<TransactionModel>? transactionsExpense = mapExpense[date];

      int sumIncome = 0;
      if (transactionsIncome != null) {
        for (TransactionModel transactionModel in transactionsIncome) {
          sumIncome += transactionModel.amount;
        }
      }

      int sumExpense = 0;
      if (transactionsExpense != null) {
        for (TransactionModel transactionModel in transactionsExpense) {
          sumExpense += transactionModel.amount;
        }
      }

      int x;

      switch (dateType) {
        case DateType.weekDay:
          x = date.weekday;
          break;
        case DateType.month:
          x = date.month;
          break;
        case DateType.year:
          x = date.year;
          break;
      }

      resultList.add(makeGroupData(
          x: x,
          y1: sumIncome.toDouble(),
          y2: sumExpense.toDouble(),
          colorLeft: Colors.green,
          colorRight: Colors.red));
    }

    return resultList;
  }
}
