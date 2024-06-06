import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:finance/features/transfers/view/dialogs/select_account_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTransferPage extends StatefulWidget {
  const NewTransferPage({super.key});

  @override
  State<NewTransferPage> createState() => _NewTransferPageState();
}

class _NewTransferPageState extends State<NewTransferPage> {
  TextEditingController _amountTextController = TextEditingController();

  TextEditingController _descriptionTextController = TextEditingController();

  final GlobalKey _fromAccountDropdownKey = GlobalKey();
  final GlobalKey _toAccountDropdownKey = GlobalKey();

  List<String> list = ['1', '2'];
  String _sel = '1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание перевода'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Перевод со счета'),
            BlocBuilder<TransfersBloc, TransfersState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => SelectAccountDialog(
                              accounts: [
                                ...state.notSelectedAccounts,
                                if (state.fromAccount != null)
                                  state.fromAccount!,
                              ],
                              selectedAccount: state.fromAccount,
                              accept: (AccountModel? account) {
                                print(account);
                                if (account != null) {
                                  getIt<TransfersBloc>().add(
                                      TransfersSelectFromAccountEvent(
                                          fromAccount: account));
                                }
                              },
                            ));
                  },
                  child: RichText(
                    text: TextSpan(style: theme.textTheme.bodyLarge, children: [
                      TextSpan(
                        text: state.fromAccount?.name ?? 'Выберите счет',
                      ),
                      WidgetSpan(child: Icon(Icons.arrow_drop_down))
                    ]),
                  ),
                );
              },
            ),
            Text('Перевод на счет'),
            BlocBuilder<TransfersBloc, TransfersState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => SelectAccountDialog(
                              accounts: [
                                ...state.notSelectedAccounts,
                                if (state.toAccount != null) state.toAccount!
                              ],
                              selectedAccount: state.toAccount,
                              accept: (AccountModel? account) {
                                print(account);
                                if (account != null) {
                                  getIt<TransfersBloc>().add(
                                      TransfersSelectToAccountEvent(
                                          toAccount: account));
                                }
                              },
                            ));
                  },
                  child: RichText(
                    text: TextSpan(style: theme.textTheme.bodyLarge, children: [
                      TextSpan(
                        text: state.toAccount?.name ?? 'Выберите счет',
                      ),
                      WidgetSpan(child: Icon(Icons.arrow_drop_down))
                    ]),
                  ),
                );
              },
            ),
            Text('Сумма перевода'),
            TextField(
              controller: _amountTextController,
              // expands: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: 'Сумма',
              ),
            ),
            Text('Дата'),
            Text('Сегодня'),
            Text('Комментарий'),
            TextField(
              controller: _descriptionTextController,
              // expands: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: 'Описание',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  String amount = _amountTextController.text.trim();
                  String description = _descriptionTextController.text.trim();

                  AccountModel? fromAccount =
                      getIt<TransfersBloc>().state.fromAccount;
                  AccountModel? toAccount =
                      getIt<TransfersBloc>().state.toAccount;

                  if (fromAccount == null || toAccount == null) {
                    SnackBarService.showSnackBar(
                        context, 'Не выбран один из счетов', true);
                  } else if (fromAccount == toAccount) {
                    SnackBarService.showSnackBar(context,
                        'Не может быть выбран один и тот же счет', true);
                  } else {
                    if (amount != '') {
                      getIt<TransfersBloc>().add(
                        TransferAddNewTransferEvent(
                          userUid: FirebaseAuth.instance.currentUser!.uid,
                          fromAccount: fromAccount,
                          toAccount: toAccount,
                          amount: int.parse(amount),
                          description: description,
                          dateTime: DateTime.now(),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text('Добавить'))
          ],
        ),
      ),
    );
  }
}
