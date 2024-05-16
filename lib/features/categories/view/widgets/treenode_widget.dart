import 'package:finance/core/models/category_model.dart';
import 'package:flutter/material.dart';

class TreeNodeWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  final Function(CategoryModel) onAddSubCategoryPressedCallback;
  final Function(CategoryModel) onAddTransactionPressedCallback;
  final Function(CategoryModel) onUpdateBalancePressedCallback;

  TreeNodeWidget({
    super.key,
    required this.categoryModel,
    required this.onAddSubCategoryPressedCallback,
    required this.onAddTransactionPressedCallback,
    required this.onUpdateBalancePressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (categoryModel.childrenCategory.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ExpansionTile(
            leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onAddSubCategoryPressedCallback(categoryModel),
            ),
            trailing: IconButton(
              icon: Icon(Icons.design_services),
              onPressed: () => onAddTransactionPressedCallback(categoryModel),
            ),
            title: Text(
              '${categoryModel.name}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'balance: ${categoryModel.balance}   uid: ${categoryModel.uid}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            children: [
              for (var category in categoryModel.childrenCategory)
                TreeNodeWidget(
                  onAddSubCategoryPressedCallback:
                      onAddSubCategoryPressedCallback,
                  categoryModel: category,
                  onAddTransactionPressedCallback:
                      onAddTransactionPressedCallback,
                  onUpdateBalancePressedCallback: onUpdateBalancePressedCallback,
                ),
            ],
          ),
        ),
      );
    } else {
      return ListTile(
        onTap: () => onUpdateBalancePressedCallback(categoryModel),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onAddSubCategoryPressedCallback(categoryModel),
        ),
        trailing: IconButton(
          icon: Icon(Icons.design_services),
          onPressed: () => onAddTransactionPressedCallback(categoryModel),
        ),
        title: Text(
          '${categoryModel.name}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'balance: ${categoryModel.balance}   uid: ${categoryModel.uid}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
