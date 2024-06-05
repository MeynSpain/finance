import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
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
  AccountModel _selectedFromAccount =
      getIt<CategoriesBloc>().state.listAccounts.first;

  AccountModel _selectedToAccount =
      getIt<CategoriesBloc>().state.listAccounts.first;

  TextEditingController _amountTextController = TextEditingController();

  TextEditingController _descriptionTextController = TextEditingController();

  final GlobalKey _fromAccountDropdownKey = GlobalKey();
  final GlobalKey _toAccountDropdownKey = GlobalKey();

  List<String> list = ['1', '2'];
  String _sel = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание перевода'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Перевод со счета'),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return DropdownButton<AccountModel>(
                    key: _fromAccountDropdownKey,
                    value: _selectedFromAccount,
                    items: state.listAccounts
                        .map((item) =>
                        DropdownMenuItem(
                          value: item,
                          child: Text('${item.name} ${item.balance}руб.'),
                        ))
                        .toList(),
                    onChanged: (account) {
                      setState(() {
                        _selectedFromAccount = account ?? _selectedFromAccount;
                      });
                    });
              },
            ),
            Text('Перевод на счет'),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return DropdownButton<AccountModel>(
                    key: _toAccountDropdownKey,
                    value: _selectedToAccount,
                    items:
                    state.listAccounts
                        .map((item) =>
                        DropdownMenuItem(
                            value: item, child: Text('${item.name} ${item.balance}руб.')))
                        .toList(),
                    onChanged: (account) {
                      setState(() {
                        _selectedToAccount = account ?? _selectedToAccount;
                        // _selectedToAccount = account ?? _selectedToAccount;
                      });
                    });
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

                  if (amount != '') {
                    getIt<TransfersBloc>().add(
                      TransferAddNewTransferEvent(
                        userUid: FirebaseAuth.instance.currentUser!.uid,
                        fromAccount: _selectedFromAccount,
                        toAccount: _selectedToAccount,
                        amount: int.parse(amount),
                        description: description,
                        dateTime: DateTime.now(),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Добавить'))
          ],
        ),
      ),
    );
  }
}
