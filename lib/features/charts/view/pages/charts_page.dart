import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/charts/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:finance/features/charts/view/widgets/raw_buttons_date.dart';
import 'package:finance/features/charts/view/widgets/text_date_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List<Color> colorList = [];
  List<Color> constColorList = [];

  bool isIncome = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
        actions: [
          BlocBuilder<ChartsBloc, ChartsState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  if (state.isByTags) {
                    getIt<ChartsBloc>().add(ChartsChangeOnCategoriesEvent(
                        type: isIncome
                            ? Globals.typeTransactionsIncome
                            : Globals.typeTransactionsExpense));
                  } else {
                    getIt<ChartsBloc>().add(ChartsChangeOnTagsEvent(
                        type: isIncome
                            ? Globals.typeTransactionsIncome
                            : Globals.typeTransactionsExpense));
                  }
                },
                child: Text(
                  state.isByTags ? 'По категориями' : 'По тегам',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isIncome = false;
                      });
                      getIt<ChartsBloc>().add(ChartsChangeTypeEvent(
                          type: Globals.typeTransactionsExpense));
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
                      getIt<ChartsBloc>().add(ChartsChangeTypeEvent(
                          type: Globals.typeTransactionsIncome));
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
            ),
            Container(
              height: 300,
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  RawButtonsDate(
                    startIndex: 2,
                    userUid: FirebaseAuth.instance.currentUser!.uid,
                    rootCategoryUid:
                        getIt<CategoriesBloc>().state.currentCategory!.uid!,
                    type: isIncome
                        ? Globals.typeTransactionsIncome
                        : Globals.typeTransactionsExpense,
                  ),
                  TextDateWidget(),
                  const Expanded(child: SizedBox()),
                  BlocBuilder<ChartsBloc, ChartsState>(
                    builder: (context, state) {
                      if (state.status == ChartsStatus.loading) {
                        return const Center(
                            child: SizedBox(
                                height: 180,
                                width: 180,
                                child: CircularProgressIndicator()));
                      } else if (state.listTransactions.isEmpty) {
                        return const SizedBox(
                          height: 200,
                          child: PieChart(
                            // colorList: colorList,
                            // totalValue: 1,
                            dataMap: {
                              '': 0,
                            },
                            legendOptions: LegendOptions(showLegends: false),
                            chartType: ChartType.ring,
                            centerText: 'Транзакции не найдены',
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 200,
                          child: PieChart(
                            centerWidget: Text('${state.totalValue}'),
                            dataMap: state.status != ChartsStatus.dataMapEmpty
                                ? state.dataMap
                                : {'': 0},
                            chartType: ChartType.ring,
                            chartValuesOptions:
                                ChartValuesOptions(showChartValues: false),
                            legendOptions: LegendOptions(
                              showLegends: false,
                              legendPosition: LegendPosition.bottom,
                              legendTextStyle: theme.textTheme.bodyMedium!,
                            ),
                            // colorList: generateUniqueColors(state.dataMap.length),
                            // colorList: constColorList,
                            colorList: state.status != ChartsStatus.dataMapEmpty
                                ? state.colorMap.values.toList()
                                : [Colors.grey],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ChartsBloc, ChartsState>(
              builder: (context, state) {
                if (state.status == ChartsStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                        itemCount: state.constDataMap.length,
                        itemBuilder: (context, index) {
                          String key = state.constDataMap.keys.elementAt(index);
                          getIt<Talker>().info('KEY: $key');
                          return state.selectedDataMap[key] == null
                              ? CircularProgressIndicator()
                              : Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: !state.selectedDataMap[key]!
                                          ? state.constColorMap[key]
                                          : state.constColorMap[key]
                                              ?.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // IconButton(onPressed: (){},icon: Icon(Icons.visibility),),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            getIt<ChartsBloc>().add(
                                                ChartsToggleElementEvent(
                                                    key: key));
                                          },
                                          child: !state.selectedDataMap[key]!
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off),
                                        ),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            getIt<TransactionHistoryBloc>().add(
                                                TransactionHistoryLoadTransactionsEvent(
                                                    transactions:
                                                        state.listTransactions,
                                                    categoryName: key,
                                                    categories: getIt<
                                                            CategoriesBloc>()
                                                        .state
                                                        .listUnsortedCategories));
                                            Navigator.of(context).pushNamed(
                                                '/charts/transactions');
                                          },
                                          child: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 4,
                                                // fit: FlexFit.tight,
                                                child: Container(
                                                    child: Text(
                                                  '$key',
                                                  style: theme
                                                      .textTheme.bodyMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                              ),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                flex: 2,
                                                // fit: FlexFit.loose,
                                                child: Container(
                                                  child: Text(
                                                    '${state.constDataMap[key]} руб.',
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      // }
      // },
      // ),
    );
  }
}
