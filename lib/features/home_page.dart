import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/categoty_model.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DatabaseService databaseService = DatabaseService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<DocumentReference> listCategories = [];

  final List<DocumentReference> listSubCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${FirebaseAuth.instance.currentUser?.email}'),
        leading: IconButton(
          icon: Icon(Icons.category),
          onPressed: () {
            Navigator.of(context).pushNamed('/categories');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hi'),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    CategoryModel model = CategoryModel(
                      name: 'First category',
                      balance: 1,
                    );

                    DocumentReference? doc = await databaseService.addCategory(
                      categoryModel: model,
                      userUid: auth.currentUser!.uid,
                    );

                    listCategories.add(doc!);
                  },
                  child: Text('Create Category')),
              ElevatedButton(
                  onPressed: () async {
                    CategoryModel subCategory = CategoryModel(
                      name: 'sub category',
                      balance: 11,
                      parentCategoryUid: listSubCategories.isNotEmpty
                          ? listSubCategories.last.id
                          : listCategories.last.id,
                    );

                    DocumentReference? doc = await databaseService.addCategory(
                        categoryModel: subCategory,
                        userUid: auth.currentUser!.uid);

                    if (doc != null) {
                      listSubCategories.add(doc);
                    }
                  },
                  child: Text('Создать подкатегорию')),
              ElevatedButton(
                  onPressed: () {
                    databaseService.getAllCategories(auth.currentUser!.uid);
                    // databaseService.getCategory(categoryId: '98txiPgOG62XPxvbmDpK', userUid: auth.currentUser!.uid);
                  },
                  child: Text('Получить категорию')),
            ],
          ),
        ],
      ),
    );
  }
}
