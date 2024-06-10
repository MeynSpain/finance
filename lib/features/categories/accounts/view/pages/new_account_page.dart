import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({super.key});

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  final MoneyService moneyService = MoneyService();

  bool _isNullable = false;
  bool _isAccountedInTotalBalance = true;

  @override
  void initState() {
    _balanceController.addListener(_formatSummaInput);
    super.initState();
  }

  @override
  void dispose() {
    _balanceController.removeListener(_formatSummaInput);
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _formatSummaInput() {
    String input = _balanceController.text.replaceAll(' ', '');

    // Check if there is more than one comma and truncate if necessary
    if (input.split(',').length > 2) {
      input = input.replaceFirst(RegExp(r',(?=.*,)'), '');
    }

    int decimalIndex = input.indexOf(',');
    final String intPart =
        decimalIndex == -1 ? input : input.substring(0, decimalIndex);
    final String decimalPart =
        decimalIndex == -1 ? '' : input.substring(decimalIndex + 1);

    final intPartWithoutLeadingZeros =
        intPart.replaceFirst(RegExp(r'^0+(?!$)'), '');

    // Limit the decimal part to two digits
    final String limitedDecimalPart =
        decimalPart.length > 2 ? decimalPart.substring(0, 2) : decimalPart;

    final String formattedIntPart = NumberFormat('#,###', 'en_US')
        .format(int.tryParse(intPartWithoutLeadingZeros) ?? 0)
        .replaceAll(',', ' ');

    // Combine the formatted integer part with the limited decimal part
    final String formattedInput = decimalIndex == -1
        ? formattedIntPart
        : '$formattedIntPart,$limitedDecimalPart';

    // Update the controller's text if the formatted input is different from the original input
    if (formattedInput != _balanceController.text) {
      _balanceController.value = _balanceController.value.copyWith(
        text: formattedInput,
        selection: TextSelection.collapsed(offset: formattedInput.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый счет'),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                  // FilteringTextInputFormatter.digitsOnly,
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
                      _isAccountedInTotalBalance =
                          newValue ?? _isAccountedInTotalBalance;
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
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
      int summa = moneyService.convertToKopecks(balance);
      getIt<CategoriesBloc>().add(CategoriesAddNewAccountEvent(
        userUid: FirebaseAuth.instance.currentUser!.uid!,
        name: name,
        balance: summa,
        isAccountedInTotalBalance: _isAccountedInTotalBalance,
        type: _isNullable
            ? Globals.typeAccountNullable
            : Globals.typeAccountNonNullable,
      ));
    }
  }
}
