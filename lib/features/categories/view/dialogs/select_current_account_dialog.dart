import 'package:finance/core/constants/widgets/list_item_container.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCurrentAccountDialog extends StatefulWidget {
  const SelectCurrentAccountDialog({super.key});

  @override
  State<SelectCurrentAccountDialog> createState() =>
      _SelectCurrentAccountDialogState();
}

class _SelectCurrentAccountDialogState
    extends State<SelectCurrentAccountDialog> {
  // bool _isChecked = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        height: 500,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Выберите счет',
              style: theme.textTheme.bodyLarge,
            ),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                return Container(
                  height: 400,
                  // width: 300,
                  child: ListView.builder(
                      itemCount: state.listAccounts.length,
                      itemBuilder: (context, index) {
                        AccountModel account = state.listAccounts[index];
                        return CheckboxListTile(
                            title: Text(account.name),
                            subtitle: Text('${account.balance} руб.'),
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            value: _selectedIndex == index,
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            });
                      }),
                );
              },
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
                      getIt<CategoriesBloc>().add(
                          CategoriesSelectNewAccountEvent(
                              userUid: FirebaseAuth.instance.currentUser!.uid,
                              accountModel: getIt<CategoriesBloc>()
                                  .state
                                  .listAccounts[_selectedIndex]));
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
