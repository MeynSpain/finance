import 'package:finance/core/injection.dart';
import 'package:finance/core/models/account_model.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/view/widgets/data_widget.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:finance/features/transfers/view/dialogs/select_account_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewTransferPage extends StatefulWidget {
  const NewTransferPage({super.key});

  @override
  State<NewTransferPage> createState() => _NewTransferPageState();
}

class _NewTransferPageState extends State<NewTransferPage> {
  TextEditingController _amountTextController = TextEditingController();

  TextEditingController _descriptionTextController = TextEditingController();

  final MoneyService moneyService = MoneyService();

  final GlobalKey _fromAccountDropdownKey = GlobalKey();
  final GlobalKey _toAccountDropdownKey = GlobalKey();

  List<String> list = ['1', '2'];
  String _sel = '1';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _amountTextController.addListener(_formatSummaInput);
    super.initState();
  }

  @override
  void dispose() {
    _amountTextController.removeListener(_formatSummaInput);
    _amountTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  void _formatSummaInput() {
    String input = _amountTextController.text.replaceAll(' ', '');

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
    if (formattedInput != _amountTextController.text) {
      _amountTextController.value = _amountTextController.value.copyWith(
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
        title: Text('Создание перевода'),
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Перевод со счета',
              style: theme.textTheme.bodyLarge,
            ),
            BlocBuilder<TransfersBloc, TransfersState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
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
                        text: TextSpan(
                            style: theme.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text:
                                    state.fromAccount?.name ?? 'Выберите счет',
                              ),
                              WidgetSpan(child: Icon(Icons.arrow_drop_down))
                            ]),
                      ),
                    ),
                    state.fromAccount != null
                        ? Text(
                            '${moneyService.convert(state.fromAccount!.balance, 100)} руб.')
                        : SizedBox()
                  ],
                );
              },
            ),
            Divider(),
            Text(
              'Перевод на счет',
              style: theme.textTheme.bodyLarge,
            ),
            BlocBuilder<TransfersBloc, TransfersState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => SelectAccountDialog(
                                  accounts: [
                                    ...state.notSelectedAccounts,
                                    if (state.toAccount != null)
                                      state.toAccount!
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
                        text: TextSpan(
                            style: theme.textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: state.toAccount?.name ?? 'Выберите счет',
                              ),
                              WidgetSpan(child: Icon(Icons.arrow_drop_down))
                            ]),
                      ),
                    ),
                    state.toAccount != null
                        ? Text(
                            '${moneyService.convert(state.toAccount!.balance, 100)} руб.')
                        : SizedBox()
                  ],
                );
              },
            ),
            Divider(),
            Text(
              'Сумма перевода',
              style: theme.textTheme.bodyLarge,
            ),
            TextField(
              controller: _amountTextController,
              // expands: false,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                // FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: 'Сумма',
              ),
            ),
            Divider(),

            // Text('Сегодня'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Дата',
                  style: theme.textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                      initialDate: _selectedDate,
                    );

                    if (dateTime != null) {
                      setState(() {
                        _selectedDate = dateTime;
                      });
                    }
                  },
                  child: DataWidget(
                    isSelected: true,
                    date:
                        '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    dayName: 'Выбранная',
                    childrenWidgets: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.date_range_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Text(
              'Комментарий',
              style: theme.textTheme.bodyLarge,
            ),
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
            SizedBox(height: 20,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: theme.textTheme.bodyMedium,
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 100,
                  ),
                ),
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
                      int summa = moneyService.convertToKopecks(amount);
                      if (summa != 0) {
                        getIt<TransfersBloc>().add(
                          TransferAddNewTransferEvent(
                            userUid: FirebaseAuth.instance.currentUser!.uid,
                            fromAccount: fromAccount,
                            toAccount: toAccount,
                            amount: summa,
                            description: description,
                            dateTime: _selectedDate,
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        SnackBarService.showSnackBar(context,
                            'Сумма перевода не может быть равна 0', true);
                      }
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
