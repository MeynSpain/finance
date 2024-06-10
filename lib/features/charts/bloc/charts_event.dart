part of 'charts_bloc.dart';

@immutable
abstract class ChartsEvent {}

class ChartsGetLastMonthTransactionsEvent extends ChartsEvent {
  final String userUid;
  final String accountUid;
  final List<AccountModel> accounts;
  final AccountModel currentAccount;

  ChartsGetLastMonthTransactionsEvent({
    required this.userUid,
    required this.accountUid,
    required this.accounts,
    required this.currentAccount,
  });
}

class ChartsDeleteDataFromDataMapEvent extends ChartsEvent {
  final String key;

  ChartsDeleteDataFromDataMapEvent({required this.key});
}

class ChartsToggleElementEvent extends ChartsEvent {
  final String key;

  ChartsToggleElementEvent({required this.key});
}

class ChartsChangeTypeEvent extends ChartsEvent {
  final String type;

  ChartsChangeTypeEvent({required this.type});
}

class ChartsGetTransactionByDateEvent extends ChartsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String userUid;
  final String accountUid;
  final String type;

  ChartsGetTransactionByDateEvent({
    required this.startDate,
    required this.endDate,
    required this.userUid,
    required this.accountUid,
    required this.type,
  });
}

class ChartsChangeOnTagsEvent extends ChartsEvent {
  final String type;

  ChartsChangeOnTagsEvent({required this.type});
}

class ChartsChangeOnCategoriesEvent extends ChartsEvent {
  final String type;

  ChartsChangeOnCategoriesEvent({required this.type});
}

class ChartsChangeAccountEvent extends ChartsEvent {
  final AccountModel account;
  final String type;

  ChartsChangeAccountEvent({
    required this.account,
    required this.type,
  });
}
