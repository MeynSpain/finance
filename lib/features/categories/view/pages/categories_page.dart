import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/view/widgets/create_new_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return BlocBuilder<CategoriesBloc, CategoriesState>(
                            builder: (context, state) {
                          return CreateNewCategoryWidget();
                        });
                      });
                },
                child: Text('Create category'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
