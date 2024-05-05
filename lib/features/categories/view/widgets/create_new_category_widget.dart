import 'package:finance/core/injection.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateNewCategoryWidget extends StatefulWidget {
  const CreateNewCategoryWidget({super.key});

  @override
  State<CreateNewCategoryWidget> createState() =>
      _CreateNewCategoryWidgetState();
}

class _CreateNewCategoryWidgetState extends State<CreateNewCategoryWidget> {
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
            const Text('Создать новую категорию'),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        String text = _textEditingController.text.trim();

                        if (text != '') {
                          Navigator.of(context).pop();
                          getIt<CategoriesBloc>().add(
                            CategoriesAddingCategoryEvent(
                              name: text,
                              userUid: FirebaseAuth.instance.currentUser!.uid,
                            ),
                          );
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
  }
}
