import 'package:finance/features/categories/accounts/view/widgets/list_accounts_widget.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Счета'),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Итог
          Center(
            child: BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text('Общий баланс', style: theme.textTheme.bodyLarge,),
                    Text('${state.totalBalance} руб.', style: theme.textTheme.bodyLarge,),
                  ],
                );
              },
            ),
          ),

          /// Кнопки для истории и создания переводов по счетам
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: Text('История переводов')),
              ElevatedButton(onPressed: () {}, child: Text('Создать перевод')),
            ],
          ),

          /// Список счетов
          const Expanded(child: ListAccountsWidgets()),

          /// Кнопка добавления
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/accounts/newAccount');
                },
                child: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
