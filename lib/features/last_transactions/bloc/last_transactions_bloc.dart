import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/last_transactions_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:finance/core/services/transaction_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'last_transactions_event.dart';

part 'last_transactions_state.dart';

class LastTransactionsBloc
    extends Bloc<LastTransactionsEvent, LastTransactionsState> {
  DatabaseService databaseService = DatabaseService();
  TransactionService transactionService = TransactionService();

  LastTransactionsBloc() : super(LastTransactionsState.initial()) {
    on<LastTransactionsInitialEvent>(_initialEvent);
    on<LastTransactionsAddTransactionEvent>(_addTransaction);
  }

  Future<void> _initialEvent(LastTransactionsInitialEvent event,
      Emitter<LastTransactionsState> emit) async {
    emit(state.copyWith(
      status: LastTransactionsStatus.loading,
    ));

    try {
      List<TransactionModel> transactions =
          await databaseService.getLastTransactions(
              userUid: event.userUid,
              rootCategoryUid: event.rootCategoryUid,
              count: 5);

      List<PairModel<CategoryModel, TransactionModel>> pairs =
          transactionService.getTransactionsByCategories(
              categories: getIt<CategoriesBloc>().state.listUnsortedCategories,
              transactions: transactions);

      var reverse = pairs.reversed;
      pairs = reverse.toList();

      emit(state.copyWith(
        status: LastTransactionsStatus.success,
        transactions: pairs,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(state.copyWith(
        status: LastTransactionsStatus.error,
        errorMessage:
            'Произошла ошибка во время получения последних транзакций',
      ));
    }
  }

  FutureOr<void> _addTransaction(LastTransactionsAddTransactionEvent event,
      Emitter<LastTransactionsState> emit) {
    emit(state.copyWith(status: LastTransactionsStatus.loading));

    try {
      int indexCategory = getIt<CategoriesBloc>()
          .state
          .listUnsortedCategories
          .indexWhere((element) => element.uid == event.categoryUid);

      CategoryModel categoryModel =
          getIt<CategoriesBloc>().state.listUnsortedCategories[indexCategory];

      PairModel<CategoryModel, TransactionModel> pairModel =
          PairModel(categoryModel, event.transaction);

      emit(state.copyWith(
        status: LastTransactionsStatus.success,
        transactions: [pairModel, ...state.transactions],
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(state.copyWith(
        status: LastTransactionsStatus.error,
        errorMessage: 'Произошла ошибка во время добавления транзакции',
      ));
    }
  }
}
