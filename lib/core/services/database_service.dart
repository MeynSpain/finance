import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/template/templates.dart';
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

    /* Перенес сортировку в отдельный метод
    List<int> listChildrenIndexes = [];

    for (int i = 0; i < listCategories.length; i++) {
      // Смотрим наличие с полем parentCategoryUid
      if (listCategories[i].parentCategoryUid != null) {
        listChildrenIndexes.add(i);
        // Теперь ищем в списке родительскую категорию и добавляем ей в список
        // childrenCategory
        CategoryModel category = listCategories.firstWhere(
            (element) => element.uid == listCategories[i].parentCategoryUid);
        category.childrenCategory.add(listCategories[i]);
      }
    }

    // Теперь убрать лишние элементы из списка, т.к. они уже в дочерних категориях
    for (int index in listChildrenIndexes.reversed) {
      listCategories.removeAt(index);
    }

    // print(listCategories);
     */
    return listCategories;
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

    // final snapshot = await docRef
    //     .collection(Globals.categories)
    //     .where(FieldPath.documentId, isEqualTo: categoryId)
    //     .get();

    // print(category);

    return category;
  }

  /// Создает и добавляет в базу данных шаблон начальных категорий
  Future<CategoryModel> addStartCategoryTemplate(
      {required String userUid}) async {
    CategoryModel startTemplate = Templates.getStartCategoryTemplate(
        name: 'Личный баланс', userUid: userUid);

    DocumentReference docCategoryRef = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.categories)
        .doc();

    startTemplate.uid = docCategoryRef.id;

    await docCategoryRef.set(startTemplate.toMap());

    startTemplate.childrenCategory.forEach((childCategory) async {
      childCategory.parentCategoryUid = startTemplate.uid;
      DocumentReference docChildCategoryRef = db
          .collection(Globals.users)
          .doc(userUid)
          .collection(Globals.categories)
          .doc(startTemplate.uid)
          .collection(Globals.categories)
          .doc();

      childCategory.uid = docChildCategoryRef.id;

      await docChildCategoryRef.set(childCategory.toMap());
    });

    return startTemplate;
  }

  // Future<List<TagModel>> addTagsTemplate(String userUid) async {
  //   List<TagModel> listTags = Templates.getStartTagsTemplate();
  //
  //   CollectionReference tagsCollectionReference =
  //       db.collection(Globals.users).doc(userUid).collection(Globals.tags);
  //
  //   for (var tag in listTags) {
  //     DocumentReference tagReference = tagsCollectionReference.doc();
  //     tag.uid = tagReference.id;
  //     await tagReference.set(tag.toMap());
  //   }
  //   return listTags;
  // }

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
  Future<void> addTransaction({
    required TransactionModel transactionModel,
    required String rootCategoryUid,
    required String categoryUid,
    required List<CategoryModel> categories,
    required String userUid,
    bool isIncome = false,
  }) async {
    // parentCategory.transactions?.add(transactionModel);

    DocumentReference transactionReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.categories)
        .doc(rootCategoryUid)
        .collection(Globals.transactions)
        .doc();

    transactionModel.uid = transactionReference.id;

    transactionReference.set(transactionModel.toMap());

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

    /// Осталось обновить балансы
/*
    QuerySnapshot querySnapshot = await db
        .collectionGroup(Globals.categories)
        .where(Globals.uid, isEqualTo: parentCategory.uid)
        .where(Globals.userUid, isEqualTo: parentCategory.userUid)
        .get();

    for (var doc in querySnapshot.docs) {
      print('${doc.id} => ${doc.data()}');
    }

    QueryDocumentSnapshot doc = querySnapshot.docs.first;

    await doc.reference.update({
      Globals.balance: FieldValue.increment(transactionModel.amount),
      Globals.transactions: FieldValue.arrayUnion([transactionModel.toMap()])
    });

    CategoryModel currentCategory =
        CategoryModel.fromMap(doc.data() as Map<String, dynamic>);

    while (currentCategory.parentCategoryUid != null) {
      QuerySnapshot querySnapshot = await db
          .collectionGroup(Globals.categories)
          .where(Globals.uid, isEqualTo: currentCategory.parentCategoryUid)
          .where(Globals.userUid, isEqualTo: currentCategory.userUid)
          .get();

      await querySnapshot.docs.first.reference.update({
        Globals.balance: FieldValue.increment(transactionModel.amount),
      });

      currentCategory = CategoryModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }

    return currentCategory;

 */
  }

  Future<List<TransactionModel>> getTransactions(
      {required String userUid,
      required String rootCategoryUid,
      required DateTime startDate,
      required DateTime endDate}) async {
    List<TransactionModel> listTransactions = [];

    CollectionReference transactionCollectionReference = db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.categories)
        .doc(rootCategoryUid)
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
    print(listTransactions);

    return listTransactions;
  }
}
