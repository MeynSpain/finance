import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/view/widgets/add_transaction_widget.dart';
import 'package:finance/features/categories/view/widgets/create_new_category_widget.dart';
import 'package:finance/features/categories/view/widgets/treenode_widget.dart';
import 'package:finance/features/categories/view/widgets/update_balance_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_flutter/tree_view_flutter.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    getIt<CategoriesBloc>().add(CategoriesGetAllCategoriesEvent(
        userUid: FirebaseAuth.instance.currentUser!.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return state.status == CategoriesStatus.gettingAllCategories
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  title: Text('Categories'),
                ),
                body: ListView.builder(
                    itemCount: state.listCategories.length,
                    itemBuilder: (context, index) {
                      return TreeNodeWidget(
                          onAddSubCategoryPressedCallback: (category) {
                            _showDialog(
                                context: context, parentCategory: category);
                          },
                          onAddTransactionPressedCallback: (category) {
                            _showAddTransactionDialog(
                                context: context, currentCategory: category);
                          },
                          onUpdateBalancePressedCallback: (category) {
                            _showUpdateBalanceDialog(
                                context: context, categoryModel: category);
                          },
                          categoryModel: state.listCategories[index]);
                    }),
              );
      },
    );
  }

  void _showDialog(
      {required BuildContext context, CategoryModel? parentCategory}) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
            return CreateNewCategoryWidget(
              parentCategory: parentCategory,
            );
          });
        });
  }

  void _showAddTransactionDialog(
      {required BuildContext context, required CategoryModel currentCategory}) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
            return AddTransactionWidget(
              // categoryModel: currentCategory,
            );
          });
        });
  }

  void _showUpdateBalanceDialog(
      {required BuildContext context, required CategoryModel categoryModel}) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
            return UpdateBalanceWidget(
              categoryModel: categoryModel,
            );
          });
        });
  }
}
