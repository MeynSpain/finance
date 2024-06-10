import 'package:finance/core/injection.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/features/categories/accounts/view/widgets/list_accounts_widget.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountsPage extends StatelessWidget {
  AccountsPage({super.key});

  final MoneyService moneyService = MoneyService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Счета'),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                      '${moneyService.convert(state.totalBalance, 100)} руб.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          /// Кнопки для истории и создания переводов по счетам
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      DateTime now = DateTime.now();
                      DateTime startDate = DateTime(now.year, now.month, 1);
                      getIt<TransfersBloc>().add(
                        TransfersGetAllTransfersByDateEvent(
                          userUid: FirebaseAuth.instance.currentUser!.uid,
                          startDate: startDate,
                          endDate: now,
                        ),
                      );
                      Navigator.of(context).pushNamed('/accounts/history');
                    },
                    icon: Image.asset('assets/icons/history.png'),
                  ),
                  Text('История переводов')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      getIt<TransfersBloc>()
                          .add(TransferGetAccountsFromStateEvent());
                      Navigator.of(context).pushNamed('/accounts/newTransfer');
                    },
                    icon: Image.asset('assets/icons/new_transfer.png'),
                  ),
                  Text('Создать перевод')
                ],
              ),
            ],
          ),

          SizedBox(
            height: 30,
          ),

          /// Список счетов
          Expanded(child: ListAccountsWidgets()),

          /// Кнопка добавления
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 1.7,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/accounts/newAccount');
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
