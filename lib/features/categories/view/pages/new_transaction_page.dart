import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/categories/tags/view/widgets/tags_widget.dart';
import 'package:finance/features/categories/tags/view/widgets/new_tag_widget.dart';
import 'package:finance/features/categories/view/widgets/create_new_category_widget.dart';
import 'package:finance/features/categories/view/widgets/row_data_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:talker_flutter/talker_flutter.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({super.key});

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  final TextEditingController _summaTextInputController =
      TextEditingController();

  final TextEditingController _descriptionTextInputController =
      TextEditingController();

  final MoneyService moneyService = MoneyService();

  // List<TagModel> selectedTags = [];
  // List<TagModel> tags = [];
  // TagModel? selectedTag;
  // TagModel? lastTag;
  // bool isAdded = false;
  int _selectedIndex = 0;
  int _selectedAccountIndex = 0;

  bool isIncome = false;

  @override
  void initState() {
    _summaTextInputController.addListener(_formatSummaInput);
    super.initState();
  }

  @override
  void dispose() {
    _summaTextInputController.removeListener(_formatSummaInput);
    _summaTextInputController.dispose();
    _descriptionTextInputController.dispose();
    super.dispose();
  }

  void _formatSummaInput() {
    String input = _summaTextInputController.text.replaceAll(' ', '');

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
    if (formattedInput != _summaTextInputController.text) {
      _summaTextInputController.value =
          _summaTextInputController.value.copyWith(
        text: formattedInput,
        selection: TextSelection.collapsed(offset: formattedInput.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // _selectedTags = List<bool>.filled(state.listTags!.length, false);
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Добавление транзакции',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        // leadingWidth: 120,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isIncome = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        backgroundColor:
                            !isIncome ? Colors.black : Colors.white),
                    child: Column(
                      children: [
                        Text(
                          'Расходы',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: !isIncome ? Colors.white : Colors.black,
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: 2,
                          width: !isIncome ? 70 : 0,
                          // Adjust the width as needed
                          color: !isIncome ? Colors.white : Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isIncome = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        backgroundColor:
                            isIncome ? Colors.black : Colors.white),
                    child: Column(
                      children: [
                        Text(
                          'Доходы',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isIncome ? Colors.white : Colors.black,
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          height: 2,
                          width: isIncome ? 70 : 0,
                          // Adjust the width as needed
                          color: isIncome ? Colors.white : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Счет',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              BlocConsumer<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  return state.status == CategoriesStatus.gettingAllCategories
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: List.generate(
                              state.listAccounts.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAccountIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2,
                                          color: _selectedAccountIndex == index
                                              ? Colors.black
                                              : Colors.grey),
                                    ),
                                    child: Text(
                                      state.listAccounts[index].name,
                                      style: TextStyle(
                                        color: _selectedAccountIndex == index
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                },
                listener: (BuildContext context, CategoriesState state) {
                  if (state.status == CategoriesStatus.errorNegativeBalance) {
                    SnackBarService.showSnackBar(
                        context,
                        'Баланс выбранного счета не может быть отрицательным',
                        true);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Категории',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<CategoriesBloc, CategoriesState>(
                builder: (context, state) {
                  return state.status == CategoriesStatus.gettingAllCategories
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: [
                              ...List.generate(
                                state.listUnsortedCategories.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 2,
                                            color: _selectedIndex == index
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      child: Text(
                                        '${state.listUnsortedCategories[index].name}',
                                        style: TextStyle(
                                          color: _selectedIndex == index
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  _addCategory(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Text('Добавить категорию +'),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Теги',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              TagsWidget(),
              RowDataWidgets(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  controller: _summaTextInputController,
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  controller: _descriptionTextInputController,
                  // expands: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'Описание',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30, top: 30),
                child: ElevatedButton(
                  onPressed: () {
                    addTransaction();
                    Navigator.pop(context);
                  },
                  child: Text('Добавить транзакцию'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: theme.textTheme.bodyMedium,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTransaction() {
    String summa = _summaTextInputController.text.trim();
    String description = _descriptionTextInputController.text.trim();

    List<bool> selectedTags = getIt<TagsBloc>().state.listSelectedTags;
    List<TagModel> allTags = getIt<TagsBloc>().state.listTags;
    List<TagModel> tags = [];
    for (int index = 0; index < selectedTags.length; index++) {
      if (selectedTags[index]) {
        tags.add(allTags[index]);
      }
    }

    Timestamp date =
        Timestamp.fromDate(getIt<CategoriesBloc>().state.selectedDate);

    if (summa != '') {
      int sum = moneyService.convertToKopecks(summa);
      if (sum != 0) {
        TransactionModel transactionModel = TransactionModel(
          amount: sum,
          description: description,
          tags: tags,
          timestamp: date,
          userUid: FirebaseAuth.instance.currentUser!.uid,
          type: !isIncome
              ? Globals.typeTransactionsExpense
              : Globals.typeTransactionsIncome,
          categoryUid: getIt<CategoriesBloc>()
              .state
              .listUnsortedCategories[_selectedIndex]
              .uid,
          accountUid: getIt<CategoriesBloc>()
              .state
              .listAccounts[_selectedAccountIndex]
              .uid,
        );

        getIt<CategoriesBloc>().add(CategoriesAddTransactionEvent(
          userUid: FirebaseAuth.instance.currentUser!.uid,
          transactionModel: transactionModel,
          isIncome: isIncome,
        ));
      } else {
        SnackBarService.showSnackBar(context, 'Сумма транзакции не может быть равно 0', true);
      }
    }
  }

  void _addCategory(BuildContext context) {
    showDialog(
        context: context, builder: (context) => CreateNewCategoryWidget());
  }

// String selectedTag = 'one';

// void _showDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Выбрать тег'),
//           content: DropdownButton<String>(
//             hint: Text('Выберите тег'),
//             value: selectedTag,
//             onChanged: (String? value) {
//               setState(() {
//                 selectedTag = value!;
//                 print(selectedTag);
//               });
//             },
//             items: [
//               DropdownMenuItem(
//                 child: Text('one1'),
//                 value: 'one',
//               ),
//               DropdownMenuItem(
//                 child: Text('two2'),
//                 value: 'two',
//               )
//             ],
//           ),
//         );
//       });
// }
}
