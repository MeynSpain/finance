import 'package:finance/features/categories/accounts/view/widgets/list_accounts_widget.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    Text(
                      'Общий баланс',
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      '${state.totalBalance} руб.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                );
              },
            ),
          ),

          /// Кнопки для истории и создания переводов по счетам
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {}, icon: Image.asset('assets/icons/history.png'),),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/transfers/newTransfer');
                },
                icon: Image.asset('assets/icons/new_transfer.png'),
              ),
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
