import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/charts_service.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'charts_event.dart';

part 'charts_state.dart';

class ChartsBloc extends Bloc<ChartsEvent, ChartsState> {
  final DatabaseService databaseService = DatabaseService();
  final ChartsService chartsService = ChartsService();

  ChartsBloc() : super(ChartsState.initial()) {
    on<ChartsGetLastMonthTransactionsEvent>(_getLastMonthTransactions);
    on<ChartsDeleteDataFromDataMapEvent>(_deleteDataFromDataMap);
    on<ChartsToggleElementEvent>(_toggleElement);
    on<ChartsChangeTypeEvent>(_changeType);
    on<ChartsGetTransactionByDateEvent>(_getTransactionsByDate);
  }

  Future<void> _getLastMonthTransactions(
      ChartsGetLastMonthTransactionsEvent event,
      Emitter<ChartsState> emit) async {
    emit(state.copyWith(status: ChartsStatus.loading));

    try {
      DateTime endDateTime = DateTime.now();
      DateTime startDateTime = DateTime(endDateTime.year, endDateTime.month, 1);

      // print('Start date: ${startDateTime.toString()}\n End date: ${endDateTime.toString()}');

      List<TransactionModel> transactions =
          await databaseService.getTransactions(
              userUid: event.userUid,
              rootCategoryUid: event.rootCategoryUid,
              endDate: endDateTime,
              startDate: startDateTime);

      List<TransactionModel> listIncome = [];
      List<TransactionModel> listExpense = [];

      chartsService.divideTransactionsIntoIncomeAndExpense(
          transactions: transactions,
          listIncome: listIncome,
          listExpense: listExpense);

      // Доходы
      Map<String, double> dataMapIncome =
          chartsService.transactionsToMap(listIncome);

      Map<String, double> constDataMapIncome =
          Map<String, double>.from(dataMapIncome);

      // Map<String, bool> selectedIncome =
      //     constDataMapIncome.map((key, value) => MapEntry(key, false));
      //
      // int totalValueIncome =
      //     chartsService.getTotalValueFromDataMap(dataMapIncome);

      // Расходы
      Map<String, double> dataMapExpense =
          chartsService.transactionsToMap(listExpense);

      Map<String, double> constDataMapExpense =
          Map<String, double>.from(dataMapExpense);

      Map<String, bool> selectedExpense =
          constDataMapExpense.map((key, value) => MapEntry(key, false));

      int totalValueExpense =
          chartsService.getTotalValueFromDataMap(dataMapExpense);

      List<Color> colors =
          chartsService.generateUniqueColors(dataMapExpense.length);

      // print(object)

      Map<String, Color> constColorsMap =
          chartsService.getMapColor(constDataMapExpense, colors);

      Map<String, Color> colorMap = Map<String, Color>.from(constColorsMap);

      emit(state.copyWith(
        status: ChartsStatus.success,
        errorMessage: '',
        listTransactions: transactions,

        dataMapExpense: dataMapExpense,
        constDataMapExpense: constDataMapExpense,
        // selectedMapExpense: selectedExpense,
        // totalValueExpense: totalValueExpense,

        // totalValueIncome: totalValueIncome,
        // selectedMapIncome: selectedIncome,
        constDataMapIncome: constDataMapIncome,
        dataMapIncome: dataMapIncome,

        dataMap: dataMapExpense,
        constDataMap: constDataMapExpense,
        totalValue: totalValueExpense,
        selectedDataMap: selectedExpense,
        constColorMap: constColorsMap,
        colorMap: colorMap,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время получения транзакций',
      ));
    }
  }

  Future<void> _deleteDataFromDataMap(
      ChartsDeleteDataFromDataMapEvent event, Emitter<ChartsState> emit) async {
    emit(state.copyWith(status: ChartsStatus.removingData));

    try {
      Map<String, double> mapData = state.dataMapExpense;
      mapData.remove(event.key);

      int totalValue = chartsService.getTotalValueFromDataMap(mapData);

      emit(state.copyWith(
        status: ChartsStatus.dataRemoved,
        totalValue: totalValue,
        dataMapExpense: mapData,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время удаления данных из dataMap',
      ));
    }
  }

  Future<void> _toggleElement(
      ChartsToggleElementEvent event, Emitter<ChartsState> emit) async {
    emit(state.copyWith(
      status: ChartsStatus.togglingElement,
    ));

    try {
      // Если было включено
      if (!state.selectedDataMap[event.key]!) {
        Map<String, double> mapData = state.dataMap;
        mapData.remove(event.key);

        Map<String, Color> colorMap = state.colorMap;

        colorMap.remove(event.key);

        int totalValue = chartsService.getTotalValueFromDataMap(mapData);

        Map<String, bool> selected = state.selectedDataMap;

        selected[event.key] = !selected[event.key]!;

        if (mapData.isEmpty) {
          emit(state.copyWith(
            status: ChartsStatus.dataMapEmpty,
            totalValue: totalValue,
            dataMap: mapData,
            colorMap: colorMap,
          ));
        } else {
          emit(state.copyWith(
            status: ChartsStatus.elementToggled,
            totalValue: totalValue,
            dataMap: mapData,
            colorMap: colorMap,
          ));
        }
      } else
      // Если было выключено
      {
        Map<String, double> mapData = state.dataMap;

        mapData[event.key] = state.constDataMap[event.key]!;

        Map<String, Color> colorMap = state.colorMap;

        colorMap[event.key] = state.constColorMap[event.key]!;

        int totalValue = chartsService.getTotalValueFromDataMap(mapData);

        Map<String, bool> selected = state.selectedDataMap;

        selected[event.key] = !selected[event.key]!;

        emit(state.copyWith(
          status: ChartsStatus.elementToggled,
          totalValue: totalValue,
          dataMap: mapData,
          colorMap: colorMap,
        ));
      }
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время переключения видимости категории',
      ));
    }
  }

  Future<void> _changeType(
      ChartsChangeTypeEvent event, Emitter<ChartsState> emit) async {
    emit(state.copyWith(
      status: ChartsStatus.changingType,
    ));

    try {
      if (event.type == Globals.typeTransactionsIncome) {
        int totalValue =
            chartsService.getTotalValueFromDataMap(state.constDataMapIncome);
        Map<String, bool> selected =
            state.constDataMapIncome.map((key, value) => MapEntry(key, false));

        List<Color> colors =
            chartsService.generateUniqueColors(state.constDataMapIncome.length);

        Map<String, Color> constColorMap =
            chartsService.getMapColor(state.constDataMapIncome, colors);

        Map<String, Color> colorMap = Map<String, Color>.from(constColorMap);

        Map<String, double> dataMap = Map<String, double>.from(state.constDataMapIncome);

        emit(state.copyWith(
          status: state.dataMapIncome.isEmpty
              ? ChartsStatus.dataMapEmpty
              : ChartsStatus.typeIncome,
          dataMap: dataMap,
          constDataMap: state.constDataMapIncome,
          selectedDataMap: selected,
          totalValue: totalValue,
          colorMap: colorMap,
          constColorMap: constColorMap,
        ));
      } else if (event.type == Globals.typeTransactionsExpense) {
        int totalValue =
            chartsService.getTotalValueFromDataMap(state.constDataMapExpense);
        Map<String, bool> selected =
            state.constDataMapExpense.map((key, value) => MapEntry(key, false));

        List<Color> colors = chartsService
            .generateUniqueColors(state.constDataMapExpense.length);

        Map<String, Color> constColorMap =
            chartsService.getMapColor(state.constDataMapExpense, colors);

        Map<String, Color> colorMap = Map<String, Color>.from(constColorMap);


        Map<String, double> dataMap = Map<String, double>.from(state.constDataMapExpense);

        emit(state.copyWith(
          status: state.dataMapExpense.isEmpty
              ? ChartsStatus.dataMapEmpty
              : ChartsStatus.typeExpense,
          dataMap: dataMap,
          constDataMap: state.constDataMapExpense,
          selectedDataMap: selected,
          totalValue: totalValue,
          constColorMap: constColorMap,
          colorMap: colorMap,
        ));
      }
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во переключения между типами РАСХОДЫ и ДОХОДЫ',
      ));
    }
  }

  Future<void> _getTransactionsByDate(
      ChartsGetTransactionByDateEvent event, Emitter<ChartsState> emit) async {
    emit(state.copyWith(
      status: ChartsStatus.loading,
    ));

    try {
      List<TransactionModel> transactions =
          await databaseService.getTransactions(
              userUid: event.userUid,
              rootCategoryUid: event.rootCategoryUid,
              startDate: event.startDate,
              endDate: event.endDate);

      List<TransactionModel> listIncome = [];
      List<TransactionModel> listExpense = [];

      chartsService.divideTransactionsIntoIncomeAndExpense(
          transactions: transactions,
          listIncome: listIncome,
          listExpense: listExpense);

      // Доходы
      Map<String, double> dataMapIncome =
          chartsService.transactionsToMap(listIncome);

      Map<String, double> constDataMapIncome =
          Map<String, double>.from(dataMapIncome);

      Map<String, bool> selectedIncome =
          constDataMapIncome.map((key, value) => MapEntry(key, false));

      int totalValueIncome =
          chartsService.getTotalValueFromDataMap(dataMapIncome);

      // Расходы
      Map<String, double> dataMapExpense =
          chartsService.transactionsToMap(listExpense);

      Map<String, double> constDataMapExpense =
          Map<String, double>.from(dataMapExpense);

      Map<String, bool> selectedExpense =
          constDataMapExpense.map((key, value) => MapEntry(key, false));

      int totalValueExpense =
          chartsService.getTotalValueFromDataMap(dataMapExpense);

      // Цвета

      List<Color> colors = [];
      Map<String, Color> constColorsMap = {};
      Map<String, Color> colorMap = {};

      Map<String, double> dataMap = {};
      Map<String, double> constDataMap = {};
      Map<String, bool> selected = {};
      int totalValue = 0;

      // Смотрим какой тип графика изначально проссматривается ДОХОД ил РАСХОД
      if (event.type == Globals.typeTransactionsExpense) {
        dataMap = dataMapExpense;
        constDataMap = constDataMapExpense;
        totalValue = totalValueExpense;
        selected = selectedExpense;
      } else if (event.type == Globals.typeTransactionsIncome) {
        dataMap = dataMapIncome;
        constDataMap = constDataMapIncome;
        totalValue = totalValueIncome;
        selected = selectedIncome;
      }

      colors = chartsService.generateUniqueColors(dataMap.length);

      constColorsMap = chartsService.getMapColor(constDataMap, colors);

      colorMap = Map<String, Color>.from(constColorsMap);

      emit(state.copyWith(
        status:
            dataMap.isEmpty ? ChartsStatus.dataMapEmpty : ChartsStatus.success,
        errorMessage: '',
        listTransactions: transactions,
        dataMapExpense: dataMapExpense,
        constDataMapExpense: constDataMapExpense,
        constDataMapIncome: constDataMapIncome,
        dataMapIncome: dataMapIncome,
        dataMap: dataMap,
        constDataMap: constDataMap,
        totalValue: totalValue,
        selectedDataMap: selected,
        constColorMap: constColorsMap,
        colorMap: colorMap,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время получения данных по дате',
      ));
    }
  }
}
