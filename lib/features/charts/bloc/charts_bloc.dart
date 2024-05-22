import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/core/injection.dart';
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
  }

  Future<void> _getLastMonthTransactions(
      ChartsGetLastMonthTransactionsEvent event,
      Emitter<ChartsState> emit) async {
    emit(state.copyWith(status: ChartsStatus.loading));

    try {
      DateTime endDateTime = DateTime.now();
      DateTime startDateTime = DateTime(endDateTime.year, endDateTime.month, 1);

      // print('Start date: ${startDateTime.toString()}\n End date: ${endDateTime.toString()}');

      List<TransactionModel> transactions = await databaseService.getTransactions(
          userUid: event.userUid,
          rootCategoryUid: event.rootCategoryUid,
          endDate: endDateTime,
          startDate: startDateTime);

      Map<String, double> dataMap = chartsService.transactionsToMap(transactions);


      emit(state.copyWith(
        status: ChartsStatus.success,
        errorMessage: '',
        listTransactions: transactions,
        dataMap: dataMap,
      ));


    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: ChartsStatus.error,
        errorMessage: 'Ошибка во время получения транзакций',
      ));
    }
  }
}
