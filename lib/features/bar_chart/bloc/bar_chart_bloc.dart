import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/date_type.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/bar_chart_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/bar_chart_service.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:finance/features/bar_chart/legend/bloc/bar_legend_bloc.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

part 'bar_chart_event.dart';

part 'bar_chart_state.dart';

class BarChartBloc extends Bloc<BarChartEvent, BarChartState> {
  final DatabaseService dataBaseService = DatabaseService();
  final BarChartService barChartService = BarChartService();

  BarChartBloc() : super(BarChartState.initial()) {
    on<BarChartInitialEvent>(_initial);
    on<BarChartGetTransactionsByDateEvent>(_getTransactionsByDate);
    on<BarChartShowLegendEvent>(_showLegend);
  }

  Future<void> _initial(
      BarChartInitialEvent event, Emitter<BarChartState> emit) async {
    emit(state.copyWith(
      status: BarChartStatus.loading,
    ));

    try {
      DateTime now = DateTime.now();
      DateTime start = DateTime(now.year, now.month, now.day - 4);

      // getIt<Talker>().info('Start: $start\nEnd: $now');

      List<TransactionModel> transactions =
          await dataBaseService.getTransactions(
        userUid: event.userUid,
        accountUid: event.accountUid,
        startDate: start,
        endDate: now,
      );

      Map<DateTime, List<TransactionModel>> transactionsMap =
          barChartService.getTransactionsByDay(transactions);

      Map<DateTime, List<TransactionModel>> mapIncome = {};
      Map<DateTime, List<TransactionModel>> mapExpense = {};

      barChartService.splitIntoIncomeMapAndExpenseMap(
          transactions: transactionsMap,
          mapIncome: mapIncome,
          mapExpense: mapExpense);

      barChartService.addEmptyDateInMap(
          transactionMap: mapExpense,
          dateType: DateType.weekDay,
          startDate: start,
          endDate: now);

      barChartService.addEmptyDateInMap(
          transactionMap: mapIncome,
          dateType: DateType.weekDay,
          startDate: start,
          endDate: now);

      List<BarChartGroupData> showingBarGroups =
          barChartService.getListGroupData(
              mapIncome: mapIncome,
              mapExpense: mapExpense,
              dateType: DateType.weekDay);

      emit(state.copyWith(
        status: BarChartStatus.success,
        transactions: transactions,
        transactionsMap: transactionsMap,
        mapExpense: mapExpense,
        mapIncome: mapIncome,
        showingBarGroups: showingBarGroups,
        dateType: DateType.weekDay,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: BarChartStatus.error,
        errorMessage: 'Произошла ошибка во время инициализации BarChartBloc',
      ));
    }
  }

  Future<void> _getTransactionsByDate(BarChartGetTransactionsByDateEvent event,
      Emitter<BarChartState> emit) async {
    emit(state.copyWith(
      status: BarChartStatus.loading,
    ));

    try {
      List<TransactionModel> transactions =
          await dataBaseService.getTransactions(
        userUid: event.userUid,
        accountUid: event.accountUid,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      Map<DateTime, List<TransactionModel>> transactionsMap = {};

      switch (event.dateType) {
        case DateType.weekDay:
          transactionsMap = barChartService.getTransactionsByDay(transactions);
        case DateType.month:
          transactionsMap =
              barChartService.getTransactionsByMonth(transactions);
        case DateType.year:
          transactionsMap = barChartService.getTransactionsByYear(transactions);
      }

      Map<DateTime, List<TransactionModel>> mapIncome = {};
      Map<DateTime, List<TransactionModel>> mapExpense = {};

      barChartService.splitIntoIncomeMapAndExpenseMap(
          transactions: transactionsMap,
          mapIncome: mapIncome,
          mapExpense: mapExpense);

      barChartService.addEmptyDateInMap(
          transactionMap: mapExpense,
          dateType: event.dateType,
          startDate: event.startDate,
          endDate: event.endDate);

      barChartService.addEmptyDateInMap(
          transactionMap: mapIncome,
          dateType: event.dateType,
          startDate: event.startDate,
          endDate: event.endDate);

      List<BarChartGroupData> showingBarGroups =
          barChartService.getListGroupData(
              mapIncome: mapIncome,
              mapExpense: mapExpense,
              dateType: event.dateType);

      emit(state.copyWith(
        status: BarChartStatus.success,
        transactions: transactions,
        transactionsMap: transactionsMap,
        mapExpense: mapExpense,
        mapIncome: mapIncome,
        showingBarGroups: showingBarGroups,
        dateType: event.dateType,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: BarChartStatus.error,
        errorMessage: 'Произошла ошибка во время получения транзакций',
      ));
    }
  }

  FutureOr<void> _showLegend(
      BarChartShowLegendEvent event, Emitter<BarChartState> emit) {
    event.groupIndex;
    event.rodIndex;

    List<TransactionModel>? transactions = [];

    DateTime dateKey;

    switch (state.dateType) {
      case DateType.weekDay:
        if (event.rodIndex == 0) {
          dateKey = state.mapIncome.keys
              .firstWhere((element) => element.weekday == event.groupIndex);
        } else {
          dateKey = state.mapExpense.keys
              .firstWhere((element) => element.weekday == event.groupIndex);
        }
        break;
      case DateType.month:
        if (event.rodIndex == 0) {
          dateKey = state.mapIncome.keys
              .firstWhere((element) => element.month == event.groupIndex);
        } else {
          dateKey = state.mapExpense.keys
              .firstWhere((element) => element.month == event.groupIndex);
        }
        break;
      case DateType.year:
        if (event.rodIndex == 0) {
          dateKey = state.mapIncome.keys
              .firstWhere((element) => element.year == event.groupIndex);
        } else {
          dateKey = state.mapExpense.keys
              .firstWhere((element) => element.year == event.groupIndex);
        }
        break;
    }

    String typeTransaction;

    if (event.rodIndex == 0) {
      transactions = state.mapIncome[dateKey];
      typeTransaction = Globals.typeTransactionsIncome;
    } else {
      transactions = state.mapExpense[dateKey];
      typeTransaction = Globals.typeTransactionsExpense;
    }

    getIt<BarLegendBloc>().add(BarLegendShowNewLegendEvent(
      transactions: transactions ?? [],
      typeTransaction: typeTransaction,
    ));
  }
}
