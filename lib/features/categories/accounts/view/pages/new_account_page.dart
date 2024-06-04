import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  bool _isNullable = false;
  bool _isAccountedInTotalBalance = true;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый счет'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(child: SizedBox(height: ,))
            // Flexible(child: SizedBox(), fit: FlexFit.loose,flex: 1,),
            Text(
              'Название',
              style: theme.textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Text(
              'Баланс',
              style: theme.textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: TextField(
                controller: _balanceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 10,
                    child: Text(
                      'Счет может быть отрицательным',
                      style: theme.textTheme.bodyMedium,
                    )),
                Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  value: _isNullable,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isNullable = newValue ?? _isNullable;
                    });
                  },
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 10,
                    child: Text(
                      'Учитывать в общем балансе',
                      style: theme.textTheme.bodyMedium,
                    )),
                Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  value: _isAccountedInTotalBalance,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isAccountedInTotalBalance = newValue ?? _isAccountedInTotalBalance;
                    });
                  },
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
            // Flexible(child: SizedBox(), fit: FlexFit.loose,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _addNewAccount();
                        Navigator.of(context).pop();
                      },
                      child: Text('Создать',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewAccount() {
    String name = _nameController.text.trim();
    String balance = _balanceController.text.trim();

    if (name != '' && balance != '') {
      getIt<CategoriesBloc>().add(CategoriesAddNewAccountEvent(
        userUid: FirebaseAuth.instance.currentUser!.uid!,
        name: name,
        balance: int.parse(balance),
        isAccountedInTotalBalance: _isAccountedInTotalBalance,
        type: _isNullable
            ? Globals.typeAccountNullable
            : Globals.typeAccountNonNullable,
      ));
    }
  }
}
