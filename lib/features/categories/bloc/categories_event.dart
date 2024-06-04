part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {}

class CategoriesInitialEvent extends CategoriesEvent {
  final String userUid;

  CategoriesInitialEvent({required this.userUid});
}

/// Переход к созданию категории
/// Должно просто вызваться окно для создания категории
class CategoriesCreateCategoryEvent extends CategoriesEvent {}

/// Добавление категории в базу данных
class CategoriesAddingCategoryEvent extends CategoriesEvent {
  final String name;
  final String userUid;
  final CategoryModel? parentCategory;

  CategoriesAddingCategoryEvent({
    required this.name,
    required this.userUid,
    this.parentCategory,
  });
}

class CategoriesAddNewAccountEvent extends CategoriesEvent {
  final String userUid;
  final String name;
  final int balance;
  final String type;
  final bool isAccountedInTotalBalance;

  CategoriesAddNewAccountEvent({
    required this.userUid,
    required this.name,
    required this.balance,
    required this.type,
    required this.isAccountedInTotalBalance,
  });
}

class CategoriesSelectNewAccountEvent extends CategoriesEvent {
  final String userUid;
  final AccountModel accountModel;

  CategoriesSelectNewAccountEvent(
      {required this.userUid, required this.accountModel});
}

/// Считывание всех категорий из бд
class CategoriesGetAllCategoriesEvent extends CategoriesEvent {
  final String userUid;

  CategoriesGetAllCategoriesEvent({required this.userUid});
}

/// Создает шаблон начальных категорий
class CategoriesAddStartTemplateEvent extends CategoriesEvent {
  final String userUid;

  CategoriesAddStartTemplateEvent({required this.userUid});
}

/// Добавляет новую транзакцию
class CategoriesAddTransactionEvent extends CategoriesEvent {
  final String userUid;
  final TransactionModel transactionModel;
  final bool isIncome;

  CategoriesAddTransactionEvent({
    required this.userUid,
    required this.transactionModel,
    required this.isIncome,
  });
}

/// Задает новый баланс в определенной категории
class CategoriesUpdateBalanceEvent extends CategoriesEvent {
  // final String userUid;
  final CategoryModel categoryModel;
  final int newBalance;

  CategoriesUpdateBalanceEvent(
      {
      // required this.userUid,
      required this.categoryModel,
      required this.newBalance});
}

class CategoriesAddTagEvent extends CategoriesEvent {
  final TagModel tagModel;
  final String userUid;

  CategoriesAddTagEvent({
    required this.tagModel,
    required this.userUid,
  });
}

class CategoriesGetTagsEvent extends CategoriesEvent {
  final String useUid;

  CategoriesGetTagsEvent({required this.useUid});
}

class CategoriesSelectNewDateEvent extends CategoriesEvent {
  final DateTime newDate;

  CategoriesSelectNewDateEvent({required this.newDate});
}
