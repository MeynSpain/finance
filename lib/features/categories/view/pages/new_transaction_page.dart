import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/view/widgets/new_tag_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  List<TagModel> selectedTags = [];
  List<TagModel> tags = [];
  TagModel? selectedTag;
  TagModel? lastTag;
  bool isAdded = false;

  @override
  void initState() {
    List<TagModel>? tagsFromState = getIt<CategoriesBloc>().state.listTags;

    if (tagsFromState != null && tagsFromState.isNotEmpty) {
      for (TagModel tag in tagsFromState) {
        tags.add(tag);
      }
      selectedTag = tags.first;
    }

    super.initState();
  }

  @override
  void dispose() {
    _summaTextInputController.dispose();
    _descriptionTextInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // leadingWidth: 120,
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/back_arrow.svg'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: state.status == CategoriesStatus.gettingTags
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<TagModel>(
                      value: selectedTag,
                      // onTap: () {
                      //   if (lastTag != null && isAdded) {
                      //     // setState(() {
                      //     tags.remove(lastTag);
                      //     isAdded = false;
                      //     // getIt<Talker>().info('Теги в стейт: ${getIt<CategoriesBloc>().state.listTags}');
                      //     // });
                      //   }
                      // },
                      items: state.listTags!
                          .map(
                            (tag) => DropdownMenuItem<TagModel>(
                              value: tag,
                              child: Text(tag.name),
                            ),
                          )
                          .toList(),
                      onChanged: (TagModel? value) {
                        setState(() {
                          selectedTag = value!;
                          selectedTags.add(selectedTag!);
                          isAdded = true;
                        });
                        lastTag = selectedTag;
                      },
                    ),
                    SizedBox(
                      height: 55,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedTags.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(selectedTags[index].name),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _addTag(context);
                      },
                      icon: Icon(Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: TextField(
                        controller: _summaTextInputController,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
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
        );
      },
    );
  }

  void addTransaction() {
    String summa = _summaTextInputController.text.trim();
    String description = _descriptionTextInputController.text.trim();
    if (summa != '') {
      TransactionModel transactionModel = TransactionModel(
        amount: int.parse(summa),
        description: description,
        tags: selectedTags,
        timestamp: Timestamp.now(),
        // categoryUid: getIt<CategoriesBloc>().state.currentCategory
      );

      getIt<CategoriesBloc>().add(CategoriesAddTransactionEvent(
          userUid: FirebaseAuth.instance.currentUser!.uid,
          transactionModel: transactionModel,
          rootCategoryUid:
              getIt<CategoriesBloc>().state.currentCategory!.uid!));
    }
  }

  void _addTag(BuildContext context) {
    showDialog(context: context, builder: (context) => NewTagWidget());
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
