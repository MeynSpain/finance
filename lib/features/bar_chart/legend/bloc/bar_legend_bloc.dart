import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/bar_chart_status.dart';
import 'package:finance/core/constants/status/bar_legend_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/transaction_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'bar_legend_event.dart';

part 'bar_legend_state.dart';

class BarLegendBloc extends Bloc<BarLegendEvent, BarLegendState> {
  TransactionService transactionService = TransactionService();

  BarLegendBloc() : super(BarLegendState.initial()) {
    on<BarLegendShowNewLegendEvent>(_showNewLegend);
  }

  FutureOr<void> _showNewLegend(
      BarLegendShowNewLegendEvent event, Emitter<BarLegendState> emit) {
    emit(state.copyWith(
      status: BarLegendStatus.loading,
    ));

    try {
      List<CategoryModel> categories =
          getIt<CategoriesBloc>().state.listUnsortedCategories;

      List<PairModel<CategoryModel, TransactionModel>> pairs =
          transactionService.getTransactionsByCategories(
              categories: categories, transactions: event.transactions);


      Map<CategoryModel, double> showingMap = transactionService.getTotalValueByCategory(pairs: pairs);

      emit(state.copyWith(
        status: BarLegendStatus.success,
        transactions: event.transactions,
        showingMap: showingMap,
        typeTransaction: event.typeTransaction,
      ));

    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: BarLegendStatus.error,
        errorMessage: 'Не получилось загрузить легенду',
      ));
    }
  }
}
