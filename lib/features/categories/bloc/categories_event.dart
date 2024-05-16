part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {}

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
  final CategoryModel parentCategoryOfTransaction;

  CategoriesAddTransactionEvent({
    required this.userUid,
    required this.transactionModel,
    required this.parentCategoryOfTransaction,
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
