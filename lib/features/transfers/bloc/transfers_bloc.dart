import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/transfer_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/models/transfer_model.dart';
import 'package:finance/core/models/view/viewTransferModel.dart';
import 'package:finance/core/services/category_service.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/last_transactions/bloc/last_transactions_bloc.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'transfers_event.dart';

part 'transfers_state.dart';

class TransfersBloc extends Bloc<TransfersEvent, TransfersState> {
  final DatabaseService databaseService = DatabaseService();
  final CategoryService categoryService = CategoryService();

  TransfersBloc() : super(TransfersState.initial()) {
    on<TransferAddNewTransferEvent>(_addNewTransfer);
    on<TransfersGetAllTransfersByDateEvent>(_getAllTransfersByDate);
    on<TransfersSelectFromAccountEvent>(_selectFromAccount);
    on<TransfersSelectToAccountEvent>(_selectToAccount);
    on<TransferGetAccountsFromStateEvent>(_getAccountFromState);
  }

  Future<void> _addNewTransfer(
      TransferAddNewTransferEvent event, Emitter<TransfersState> emit) async {
    emit(state.copyWith(
      status: TransferStatus.loading,
    ));

    try {
      // Проверка на отрицательный баланс
      int balance = event.fromAccount.balance;
      if (event.fromAccount.type == Globals.typeAccountNonNullable &&
          (balance - event.amount) < 0) {
        emit(state.copyWith(
          status: TransferStatus.errorNegativeBalance,
        ));
        return;
      }

      TransferModel transferModel = TransferModel(
        type: Globals.typeTransferFromAccountToAccount,
        amount: event.amount,
        fromAccountUid: event.fromAccount.uid,
        toAccountUid: event.toAccount.uid,
        userUid: event.userUid,
        description: event.description,
        timestamp: Timestamp.fromDate(event.dateTime),
      );

      /* Не нужный функционал с добавлением транзакций при переводе

      CategoryModel? transferCategory = categoryService.getCategoryByType(
        Globals.typeCategoryTransfers,
        getIt<CategoriesBloc>().state.listCategories,
      );

      if (transferCategory != null) {
        TransactionModel transactionFromAccount = TransactionModel(
          amount: event.amount,
          type: Globals.typeTransactionsExpense,
          timestamp: transferModel.timestamp,
          description: transferModel.description,
          userUid: event.userUid,
          accountUid: transferModel.fromAccountUid,
          categoryUid: transferCategory.uid,
          tags: [],
        );

        TransactionModel transactionToAccount = TransactionModel(
          amount: event.amount,
          type: Globals.typeTransactionsIncome,
          timestamp: transferModel.timestamp,
          description: transferModel.description,
          userUid: event.userUid,
          accountUid: transferModel.toAccountUid,
          categoryUid: transferCategory.uid,
          tags: [],
        );

        Future<TransactionModel> transactionFrom =
            databaseService.addTransaction(
          transactionModel: transactionFromAccount,
          accountUid: transactionFromAccount.accountUid!,
          categoryUid: transferCategory.uid!,
          userUid: event.userUid,
        );

        Future<TransactionModel> transactionTo = databaseService.addTransaction(
          transactionModel: transactionToAccount,
          accountUid: transactionToAccount.accountUid!,
          categoryUid: transferCategory.uid!,
          userUid: event.userUid,
          isIncome: true,
        );

        AccountModel currentAccount =
            getIt<CategoriesBloc>().state.currentAccount!;

        List<TransactionModel> transactions =
            await Future.wait([transactionTo, transactionFrom]);

        int index = transactions.indexWhere(
            (transaction) => transaction.accountUid == currentAccount.uid);

        if (index != -1) {
          getIt<LastTransactionsBloc>().add(LastTransactionsAddTransactionEvent(
            transaction: transactions[index],
            categoryUid: transactions[index].categoryUid!,
          ));
        }
      }

       */

      TransferModel transfer = await databaseService.addNewTransfer(
        userUid: event.userUid,
        transferModel: transferModel,
      );

      event.fromAccount.balance -= event.amount;
      event.toAccount.balance += event.amount;

      emit(state.copyWith(
        status: TransferStatus.success,
        transfers: [...state.transfers, transfer],
      ));

      getIt<CategoriesBloc>().add(CategoriesUpdateAccountsEvent(
          accounts: [event.fromAccount, event.toAccount]));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage: 'Произошла ошибка во время перевода между счетами',
      ));
    }
  }

  Future<void> _getAllTransfersByDate(TransfersGetAllTransfersByDateEvent event,
      Emitter<TransfersState> emit) async {
    emit(state.copyWith(
      status: TransferStatus.loading,
    ));

    try {
      List<TransferModel> transfers =
          await databaseService.getAllTransfersByDate(
        userUid: event.userUid,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      List<ViewTransferModel> viewTransfers = [];

      for (var transfer in transfers) {
        viewTransfers.add(ViewTransferModel.fromTransfer(transfer));
      }

      emit(state.copyWith(
        status: TransferStatus.success,
        transfers: transfers,
        viewTransfers: viewTransfers,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage: 'Произошла ошибка во время получения переводов',
      ));
    }
  }

  FutureOr<void> _selectFromAccount(
      TransfersSelectFromAccountEvent event, Emitter<TransfersState> emit) {
    try {
      state.notSelectedAccounts.remove(event.fromAccount);

      emit(state.copyWith(
        fromAccount: event.fromAccount,
        notSelectedAccounts: state.notSelectedAccounts,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage:
            'Произошла ошибка во время выбора счета с которого происходит перевод',
      ));
    }
  }

  FutureOr<void> _selectToAccount(
      TransfersSelectToAccountEvent event, Emitter<TransfersState> emit) {
    try {
      state.notSelectedAccounts.remove(event.toAccount);

      emit(state.copyWith(
        toAccount: event.toAccount,
        notSelectedAccounts: state.notSelectedAccounts,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage:
            'Произошла ошибка во время выбора счета на который происходит перевод',
      ));
    }
  }

  FutureOr<void> _getAccountFromState(
      TransferGetAccountsFromStateEvent event, Emitter<TransfersState> emit) {
    emit(state.copyWith(
      status: TransferStatus.loading,
    ));

    try {
      List<AccountModel> accounts =
          List.from(getIt<CategoriesBloc>().state.listAccounts);

      List<AccountModel> notSelectedAccounts = List.from(accounts);

      emit(state.copyWith(
        status: TransferStatus.success,
        accounts: accounts,
        notSelectedAccounts: notSelectedAccounts,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TransferStatus.error,
        errorMessage: 'Произошла ошибка во время получения списка счетов',
      ));
    }
  }
}
