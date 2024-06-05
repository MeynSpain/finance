class Globals {
  Globals._();

  // Коллекции

  static const String users = 'users';
  static const String categories = 'categories';
  static const String accounts = 'accounts';
  static const String tags = 'tags';

  // static const String childrenCategories = 'childrenCategory';

  // названия полей в категориях

  static const String uid = 'uid';
  static const String userUid = 'userUid';
  static const String name = 'name';
  static const String balance = 'balance';
  static const String parentCategoryUid = 'parentCategoryUid';
  static const String transactions = 'transactions';

  // Название полей в транзакциях

  static const String amount = 'amount';
  static const String timestamp = 'timestamp';
  static const String categoryUid = 'categoryUid';
  static const String description = 'description';
  static const String accountUid = 'accountUid';


  // Название категорий

  static const String root = 'Личный баланс';
  static const String wages = 'Заработная плата';
  static const String rent = 'Аренда';
  static const String health = 'Здоровье';
  static const String utilities = 'Коммунальные услуги';
  static const String products = 'Продукты';
  static const String subscribes = 'Подписки';
  static const String leisure = 'Досуг';
  static const String transport = 'Транспорт';

  // Счета

  static const String mainAccount = 'Основной счет';

  // Переводы

  static const String transfers = 'transfers';
  static const String fromAccountUid = 'fromAccountUid';
  static const String toAccountUid = 'toAccountUid';
  static const String isAccountedInTotalBalance = 'isAccountedInTotalBalance';

  static const String typeStartBalance = 'startBalance';
  static const String typeTransferFromAccountToAccount = 'transferFromAccountToAccount';

  // Название полей в тегах

  static const String type = 'type';

  // Типы

  static const String typeCategory = 'category';
  static const String typeSimpleTag = 'simple tag';
  static const String typeTransactionsIncome = 'income';
  static const String typeTransactionsExpense = 'expense';

  // Типы счетов

  static const String typeAccountNonNullable = 'non nullable';
  static const String typeAccountNullable = 'nullable';


  // Типы категорий

  static const String typeCategoryNonDeleted = 'categoryNonDeleted';
  static const String typeCategoryTransfers = 'categoryTransfers';



  // Пути
  static const String chars_icon = 'assets/icons/charts_icon.svg';

  // Названия для кнопок

  static const String buttonDataDay = 'День';
  static const String buttonDataWeek = 'Неделя';
  static const String buttonDataMonth = 'Месяц';
  static const String buttonDataPeriod = 'Период';
}
