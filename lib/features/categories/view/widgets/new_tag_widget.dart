import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewTagWidget extends StatefulWidget {
  const NewTagWidget({super.key});

  @override
  State<NewTagWidget> createState() => _NewTagWidgetState();
}

class _NewTagWidgetState extends State<NewTagWidget> {
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
            const Text('Добавить тег'),
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
                          TagModel tag = TagModel(
                            name: text,
                            type: Globals.typeSimpleTag,
                          );

                          getIt<CategoriesBloc>().add(CategoriesAddTagEvent(
                              tagModel: tag,
                              userUid: FirebaseAuth.instance.currentUser!.uid));

                          Navigator.of(context).pop();
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
