import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransactionWidget extends StatefulWidget {
  AddTransactionWidget({super.key, required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  State<AddTransactionWidget> createState() => _AddTransactionWidgetState();
}

class _AddTransactionWidgetState extends State<AddTransactionWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text('Создать транзакцию'),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[-+.0-9]')),
                      // FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        String text = _textEditingController.text.trim();

                        if (text != '') {

                          TransactionModel transaction = TransactionModel(
                            amount: int.parse(text),
                            timestamp: Timestamp.now(),
                            categoryUid: widget.categoryModel.uid,
                            userUid: FirebaseAuth.instance.currentUser!.uid,
                            description: 'Test description'
                          );

                          Navigator.of(context).pop();
                          getIt<CategoriesBloc>().add(
                              CategoriesAddTransactionEvent(
                                  userUid:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  transactionModel: transaction,
                                  parentCategoryOfTransaction:
                                      widget.categoryModel));
                          // getIt<CategoriesBloc>().add(
                          //   CategoriesAddingCategoryEvent(
                          //     name: text,
                          //     userUid: FirebaseAuth.instance.currentUser!.uid,
                          //     parentCategory: widget.parentCategory,
                          //   ),
                          // );
                        }
                      },
                      icon: Icon(Icons.add))
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
