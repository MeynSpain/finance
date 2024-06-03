import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/template/templates.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/models/user_model.dart';

class DatabaseService {
  /// Экземпляр FirebaseFirestore
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Добавить пользователя в БД.
  Future<void> addUser(UserModel userModel) async {
    await db
        .collection(Globals.users)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  /// Добавление категории в БД.
  ///
  /// Если у [categoryModel] есть [categoryModel.parentUid], то
  /// у объекта с id = [parentUid] создается новая подколлекция в БД.
  ///
  /// Если же [categoryModel] [categoryModel.parentCategoryUid] = null, то
  /// создается отдельная коллекция привязанная только к пользователю
  ///
  /// Если возвращается [null], то произошла ошибка.
  Future<DocumentReference?> addCategory(
      {required CategoryModel categoryModel, required String userUid}) async {
    categoryModel.userUid = userUid;
    if (categoryModel.parentCategoryUid == null) {
      DocumentReference documentReference = db
          .collection(Globals.users)
          .doc(userUid)
          .collection(Globals.categories)
          .doc();

      categoryModel.uid = documentReference.id;
      await documentReference.set(categoryModel.toMap());

      // categoriesList.add(categoryModel);

      return documentReference;
    } else {
      // Ищется родитель категории, которая добавляется
      final query = await db
          .collectionGroup(Globals.categories)
          .where(Globals.userUid, isEqualTo: categoryModel.userUid)
          .where(Globals.uid, isEqualTo: categoryModel.parentCategoryUid)
          .get();

      if (query.docs.isNotEmpty) {
        // Берется эта родительская категория и в ней создается новая подколлекция "Категории"
        DocumentReference documentReference =
            query.docs.first.reference.collection(Globals.categories).doc();

        categoryModel.uid = documentReference.id;

        // Добавляется уже нужная категория в бд
        await documentReference.set(categoryModel.toMap());
        return documentReference;
      } else {
        print('Не смог найти вышестоящую категорию');
      }

      return null;
    }
  }

  List<CategoryModel> sortCategoriesInTree(List<CategoryModel> listCategories) {
    List<CategoryModel> sortedListCategories = [];

    for (CategoryModel categoryModel in listCategories) {
      sortedListCategories.add(categoryModel);
    }

    List<int> listChildrenIndexes = [];

    for (int i = 0; i < sortedListCategories.length; i++) {
      // Смотрим наличие с полем parentCategoryUid
      if (sortedListCategories[i].parentCategoryUid != null) {
        listChildrenIndexes.add(i);
        // Теперь ищем в списке родительскую категорию и добавляем ей в список
        // childrenCategory
        CategoryModel category = sortedListCategories.firstWhere((element) =>
            element.uid == sortedListCategories[i].parentCategoryUid);
        category.childrenCategory.add(sortedListCategories[i]);
      }
    }

    // Теперь убрать лишние элементы из списка, т.к. они уже в дочерних категориях
    for (int index in listChildrenIndexes.reversed) {
      sortedListCategories.removeAt(index);
    }

    return sortedListCategories;
  }

  /// Получает все категории пользователя без преобразования в дерево.
  /// У каждой категории [childrenCategory] пустое.
  Future<List<CategoryModel>> getAllCategories(String userUid) async {
    List<CategoryModel> listCategories = [];

    await db
        .collectionGroup(Globals.categories)
        .where(Globals.userUid, isEqualTo: userUid)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        listCategories.add(CategoryModel.fromMap(docSnapshot.data()));
      }
    });

    return listCategories;
  }

  /// Получение всех счетов из бд
  Future<List<AccountModel>> getAllAccounts({required String userUid}) async {
    List<AccountModel> listAccounts = [];

    await db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        listAccounts.add(AccountModel.fromMap(doc.data()));
      }
    });

    return listAccounts;
  }

  Future<CategoryModel?> getCategory(
      {required String categoryUid, required String userUid}) async {
    final querySnapshot = await db
        .collectionGroup(Globals.categories)
        .where(Globals.uid, isEqualTo: categoryUid)
        .where(Globals.userUid, isEqualTo: userUid)
        .get();

    CategoryModel? category;
    for (var doc in querySnapshot.docs) {
      category = CategoryModel.fromMap(doc.data());
    }

    return category;
  }

  Future<AccountModel> addStartAccountTemplate(
      {required String userUid}) async {
    AccountModel startTemplate =
        Templates.getStartAccountTemplate(userUid: userUid);

    DocumentReference docRef = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .doc();

    startTemplate.uid = docRef.id;

    await docRef.set(startTemplate.toMap());

    return startTemplate;
  }

  /// Создает и добавляет в базу данных шаблон начальных категорий
  Future<List<CategoryModel>> addStartCategoryTemplate(
      {required String userUid}) async {
    List<CategoryModel> startTemplate =
        Templates.getStartCategoryTemplate(userUid: userUid);

    CollectionReference collectionCategoryRef = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.categories);

    for (var category in startTemplate) {
      DocumentReference docRef = collectionCategoryRef.doc();
      category.uid = docRef.id;
      await docRef.set(category.toMap());
    }

    return startTemplate;
  }

  Future<void> updateBalance(
      CategoryModel categoryModel, int newBalance) async {
    QuerySnapshot querySnapshot = await db
        .collectionGroup(Globals.categories)
        .where(Globals.uid, isEqualTo: categoryModel.uid)
        .where(Globals.userUid, isEqualTo: categoryModel.userUid)
        .get();

    // categoryModel.balance += newBalance;

    await querySnapshot.docs.first.reference.update({
      Globals.balance: newBalance,
    });
  }

  /// Добавление тега в БД
  Future<void> addTag(TagModel tagModel, String userUid) async {
    DocumentReference tagReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.tags)
        .doc();

    tagModel.uid = tagReference.id;

    await tagReference.set(tagModel.toMap());
  }

  Future<List<TagModel>> getTags(String userUid) async {
    List<TagModel> listTags = [];
    QuerySnapshot querySnapshot = await db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.tags)
        .get();

    for (var doc in querySnapshot.docs) {
      print(doc.data());
      listTags.add(TagModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    querySnapshot.docs.map((tagDocumentSnapshot) {
      print(tagDocumentSnapshot.data());
      listTags.add(
          TagModel.fromMap(tagDocumentSnapshot.data() as Map<String, dynamic>));
    });
    return listTags;
  }

  /// Добавляет транзакцию в бд
  Future<TransactionModel> addTransaction({
    required TransactionModel transactionModel,
    required String accountUid,
    required String categoryUid,
    required String userUid,
    bool isIncome = false,
  }) async {
    // parentCategory.transactions?.add(transactionModel);

    DocumentReference transactionReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .doc(accountUid)
        .collection(Globals.transactions)
        .doc();

    transactionModel.uid = transactionReference.id;

    await transactionReference.set(transactionModel.toMap());

    int amount = transactionModel.amount;

    if (!isIncome) {
      amount = amount * (-1);
    }

    await db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .doc(accountUid)
        .update({
      Globals.balance: FieldValue.increment(amount),
    });

    /*
    int index =
        categories.indexWhere((category) => category.uid == categoryUid);

    int amount = transactionModel.amount;

    if (!isIncome) {
      amount = amount * (-1);
    }

    bool isDone = false;
    while (!isDone) {
      QuerySnapshot querySnapshot = await db
          .collectionGroup(Globals.categories)
          .where(Globals.uid, isEqualTo: categories[index].uid)
          .where(Globals.userUid, isEqualTo: categories[index].userUid)
          .get();

      await querySnapshot.docs.first.reference.update({
        Globals.balance: FieldValue.increment(amount),
      });

      if (categories[index].parentCategoryUid != null) {
        index = categories.indexWhere(
            (category) => category.uid == categories[index].parentCategoryUid);
      } else {
        isDone = true;
      }
    }

     */

    return transactionModel;
  }

  Future<List<TransactionModel>> getTransactions(
      {required String userUid,
      required String accountUid,
      required DateTime startDate,
      required DateTime endDate}) async {
    List<TransactionModel> listTransactions = [];

    CollectionReference transactionCollectionReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .doc(accountUid)
        .collection(Globals.transactions);

    QuerySnapshot querySnapshot = await transactionCollectionReference
        .where(Globals.timestamp,
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where(Globals.timestamp,
            isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();
    // QuerySnapshot querySnapshot = await transactionCollectionReference.get();

    for (var doc in querySnapshot.docs) {
      listTransactions
          .add(TransactionModel.fromMap(doc.data() as Map<String, dynamic>));
    }
    // print(listTransactions);

    return listTransactions;
  }

  Future<List<TransactionModel>> getLastTransactions({
    required String userUid,
    required String accountUid,
    required int count,
  }) async {
    List<TransactionModel> transactions = [];

    CollectionReference transactionCollectionReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.accounts)
        .doc(accountUid)
        .collection(Globals.transactions);

    QuerySnapshot querySnapshot = await transactionCollectionReference
        .orderBy(Globals.timestamp)
        .limit(count)
        .get();

    for (var doc in querySnapshot.docs) {
      transactions
          .add(TransactionModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return transactions;
  }
}
