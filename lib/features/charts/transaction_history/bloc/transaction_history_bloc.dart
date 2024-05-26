import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/transaction_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/transaction_service.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'transaction_history_event.dart';

part 'transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final TransactionService transactionService = TransactionService();

  TransactionHistoryBloc() : super(TransactionHistoryState.initial()) {
    on<TransactionHistoryLoadTransactionsEvent>(_loadTransactions);
  }

  FutureOr<void> _loadTransactions(
      TransactionHistoryLoadTransactionsEvent event,
      Emitter<TransactionHistoryState> emit) {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      List<TransactionModel> transactions =
          transactionService.getTransactionsByCategoryName(
        categoryName: event.categoryName,
        transactions: event.transactions,
        categories: event.categories,
      );

      emit(state.copyWith(
        status: TransactionStatus.success,
        categoryName: event.categoryName,
        transactions: transactions,
      ));

    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage:
            'Ошибка во время получения транзакций категории: ${event.categoryName}',
      ));
    }
  }
}
