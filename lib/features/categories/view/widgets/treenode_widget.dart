import 'package:finance/core/models/category_model.dart';
import 'package:flutter/material.dart';

class TreeNodeWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  final Function(CategoryModel) onPressedCallback;

  const TreeNodeWidget(
      {super.key,
      required this.categoryModel,
      required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    if (categoryModel.childrenCategory.isNotEmpty) {
      return ExpansionTile(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onPressedCallback(categoryModel),
        ),
        title: Text('${categoryModel.name}'),
        subtitle: Text(
            'balance: ${categoryModel.balance}   uid: ${categoryModel.uid}'),
        children: [
          for (var category in categoryModel.childrenCategory)
            TreeNodeWidget(
              onPressedCallback: onPressedCallback,
              categoryModel: category,
            ),
        ],
      );
    } else {
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed:() => onPressedCallback(categoryModel),
        ),
        title: Text('${categoryModel.name}'),
        subtitle: Text(
            'balance: ${categoryModel.balance}   uid: ${categoryModel.uid}'),
      );
    }
  }
}
