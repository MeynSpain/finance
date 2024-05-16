import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateBalanceWidget extends StatefulWidget {
  final CategoryModel categoryModel;

  UpdateBalanceWidget({super.key, required this.categoryModel});

  @override
  State<UpdateBalanceWidget> createState() => _UpdateBalanceWidgetState();
}

class _UpdateBalanceWidgetState extends State<UpdateBalanceWidget> {
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
            const Text('Обновить баланс'),
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
                        String newBalance = _textEditingController.text.trim();

                        if (newBalance != '') {
                          Navigator.of(context).pop();
                          getIt<CategoriesBloc>().add(
                              CategoriesUpdateBalanceEvent(
                                  categoryModel: widget.categoryModel,
                                  newBalance: int.parse(newBalance)));
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
