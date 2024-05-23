import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/charts_service.dart';
import 'package:finance/core/services/database_service.dart';
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

      Map<String, double> dataMap =
          chartsService.transactionsToMap(transactions);

      Map<String, double> constDataMap = Map<String, double>.from(dataMap);

      Map<String, bool> selected =
          constDataMap.map((key, value) => MapEntry(key, false));

      // List<PairModel<String, double>> dataList =
      //     chartsService.mapToList(dataMap);

      int totalValue = chartsService.getTotalValue(transactions);

      emit(state.copyWith(
        status: ChartsStatus.success,
        errorMessage: '',
        listTransactions: transactions,
        dataMap: dataMap,
        constDataMap: constDataMap,
        selectedMap: selected,
        totalValue: totalValue,
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
      Map<String, double> mapData = state.dataMap;
      mapData.remove(event.key);

      int totalValue = chartsService.getTotalValueFromDataMap(mapData);

      emit(state.copyWith(
        status: ChartsStatus.dataRemoved,
        totalValue: totalValue,
        dataMap: mapData,
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
      if (!state.selectedMap[event.key]!) {
        Map<String, double> mapData = state.dataMap;
        mapData.remove(event.key);

        int totalValue = chartsService.getTotalValueFromDataMap(mapData);

        Map<String, bool> selected = state.selectedMap;

        selected[event.key] = !selected[event.key]!;

        emit(state.copyWith(
          status: ChartsStatus.elementToggled,
          totalValue: totalValue,
          dataMap: mapData,
        ));
      } else
      // Если было выключено
      {
        Map<String, double> mapData = state.dataMap;

        mapData[event.key] = state.constDataMap[event.key]!;

        int totalValue = chartsService.getTotalValueFromDataMap(mapData);

        Map<String, bool> selected = state.selectedMap;

        selected[event.key] = !selected[event.key]!;

        emit(state.copyWith(
          status: ChartsStatus.elementToggled,
          totalValue: totalValue,
          dataMap: mapData,
        ));

      }
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время удаления данных из dataMap',
      ));
    }
  }
}
