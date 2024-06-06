import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAccountDialog extends StatefulWidget {
  SelectAccountDialog({
    super.key,
    required this.accept,
    required this.accounts,
    this.selectedAccount,
  });

  final List<AccountModel> accounts;
  final AccountModel? selectedAccount;

  Function(AccountModel? account) accept;

  @override
  State<SelectAccountDialog> createState() => _SelectAccountDialogState();
}

class _SelectAccountDialogState extends State<SelectAccountDialog> {
  int _selectedIndex = 0;

  @override
  void initState() {
    if (widget.selectedAccount != null) {
      _selectedIndex = widget.accounts.indexOf(widget.selectedAccount!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        height: 500,
        // width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Выберите счет',
              style: theme.textTheme.bodyLarge,
            ),
            Container(
              height: 400,
              // width: 300,
              child: ListView.builder(
                  itemCount: widget.accounts.length,
                  itemBuilder: (context, index) {
                    AccountModel account = widget.accounts[index];
                    return CheckboxListTile(
                        title: Text(account.name),
                        subtitle: Text('${account.balance} руб.'),
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        value: _selectedIndex == index,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedIndex = index;
                            // _selectedAccount = account;
                          });
                        });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Отмена')),
                ElevatedButton(
                    onPressed: () {
                      widget.accept(widget.accounts[_selectedIndex]);
                      Navigator.of(context).pop();
                    },
                    child: Text('Выбрать')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
