import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/models/categoty_model.dart';
import 'package:finance/core/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final List<CategoryModel> categoriesList = [];

  Future<void> addUser(UserModel userModel) async {
    await db
        .collection(Globals.users)
        .doc(userModel.uid)
        .set(userModel.toMap());
    // return documentReference;
  }

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
      final query = await db
          .collectionGroup(Globals.categories)
          .where(Globals.userUid, isEqualTo: categoryModel.userUid)
          .where(Globals.uid, isEqualTo: categoryModel.parentCategoryUid)
          .get();

      // final query = await db.collectionGroup(Globals.categories).where(
      //     Globals.uid, isEqualTo: categoryModel.parentCategoryUid).get();

      if (query.docs.isNotEmpty) {
        DocumentReference documentReference =
            query.docs.first.reference.collection(Globals.categories).doc();
        categoryModel.uid = documentReference.id;
        await documentReference.set(categoryModel.toMap());
        return documentReference;
      } else {
        print('Не смог найти вышестоящую категорию');
      }

      return null;
    }
  }

  Future<void> addSubCategory(
      {required CategoryModel subCategory,
      required CategoryModel parentCategory,
      required String userUid}) async {}

  Future<void> getAllCategories(String userUid) async {
    await db
        .collection(Globals.users)
        .doc(userUid)
        .collection(Globals.categories)
        .get()
        .then((querySnapshot) {
      print('Видимо что то нашел');
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    });

    await db
        .collectionGroup(Globals.categories)
        .where(Globals.userUid, isEqualTo: userUid)
        .get()
        .then((querySnapshot) {
      print('Видимо что то нашел в подколлекциях');
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    });

    // await db
    //     .collectionGroup('${Globals.users}/${Globals.categories}')
    //     .where('users', isEqualTo: userUid)
    //     .get()
    //     .then((querySnapshot) {
    //   print('Видимо что то нашел в по особому пути');
    //   for (var docSnapshot in querySnapshot.docs) {
    //     print('${docSnapshot.id} => ${docSnapshot.data()}');
    //   }
    // });
  }

  Future<void> getCategory(
      {required String categoryId, required String userUid}) async {
    final docRef = await db.collection(Globals.users).doc(userUid);
    final snapshot = await docRef
        .collection(Globals.categories)
        .where(FieldPath.documentId, isEqualTo: categoryId)
        .get();

    print(snapshot);
  }
}
