import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/charts/view/widgets/raw_buttons_date.dart';
import 'package:finance/features/charts/view/widgets/text_date_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

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
    // colorList = generateUniqueColors(dataMap.length);
    // print(colorList);
    super.initState();
  }

  // Color hslToColor(double h, double s, double l) {
  //   double chroma = (1.0 - (2.0 * l - 1.0).abs()) * s;
  //   double x = chroma * (1.0 - ((h / 60.0) % 2 - 1.0).abs());
  //   double m = l - chroma / 2.0;
  //   double r = 0, g = 0, b = 0;
  //
  //   if (0 <= h && h < 60) {
  //     r = chroma;
  //     g = x;
  //     b = 0;
  //   } else if (60 <= h && h < 120) {
  //     r = x;
  //     g = chroma;
  //     b = 0;
  //   } else if (120 <= h && h < 180) {
  //     r = 0;
  //     g = chroma;
  //     b = x;
  //   } else if (180 <= h && h < 240) {
  //     r = 0;
  //     g = x;
  //     b = chroma;
  //   } else if (240 <= h && h < 300) {
  //     r = x;
  //     g = 0;
  //     b = chroma;
  //   } else if (300 <= h && h < 360) {
  //     r = chroma;
  //     g = 0;
  //     b = x;
  //   }
  //
  //   r = ((r + m) * 255).round().toDouble();
  //   g = ((g + m) * 255).round().toDouble();
  //   b = ((b + m) * 255).round().toDouble();
  //
  //   return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1.0);
  // }
  //
  // // Функция для генерации списка уникальных цветов
  // List<Color> generateUniqueColors(int numberOfColors) {
  //   double saturation = 1.0;
  //   double lightness = 0.5;
  //
  //   List<Color> colors = [];
  //   for (int i = 0; i < numberOfColors; i++) {
  //     double hue = (i * 360 / numberOfColors) % 360;
  //     colors.add(hslToColor(hue, saturation, lightness));
  //     saturation = 0.7 + (i % 2) * 0.3;
  //     lightness = 0.4 + ((i % 2) * 0.3);
  //   }
  //   return colors;
  // }

  // List<Color> generateColors(int count) {
  //   List<Color> colors = [];
  //   for (int i = 0; i < count; i++) {
  //     double t = i / (count - 1);
  //     // colors.add(Color.lerp(Colors.blue, Colors.red, t)!);
  //     colors.add(Color.lerp(Color.fromRGBO(0, 0, 0, 1), Color.fromRGBO(255, 255, 255, 1), t)!);
  //   }
  //   return colors;
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body:
      // BlocBuilder<ChartsBloc, ChartsState>(
      //   builder: (context, state) {
      //     if (state.status == ChartsStatus.loading) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (state.listTransactions.isEmpty) {
      //       return const PieChart(
      //         colorList: colorList,
      //         totalValue: 1,
              // dataMap: {
              //   '': 0,
              // },
              // legendOptions: LegendOptions(showLegends: false),
              // chartType: ChartType.ring,
              // centerText: 'Транзакции не найдены',
            // );
          // } else {
            Padding(
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
                                  color:
                                      !isIncome ? Colors.white : Colors.black,
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 2,
                                width: !isIncome ? 70 : 0,
                                // Adjust the width as needed
                                color: !isIncome
                                    ? Colors.white
                                    : Colors.transparent,
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
                                color: isIncome
                                    ? Colors.white
                                    : Colors.transparent,
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
                          rootCategoryUid: getIt<CategoriesBloc>()
                              .state
                              .currentCategory!
                              .uid!,
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
                                      child: CircularProgressIndicator(
                                      )));
                            } else if (state.listTransactions.isEmpty) {
                              return const PieChart(
                                // colorList: colorList,
                                // totalValue: 1,
                                dataMap: {
                                  '': 0,
                                },
                                legendOptions:
                                    LegendOptions(showLegends: false),
                                chartType: ChartType.ring,
                                centerText: 'Транзакции не найдены',
                              );
                            } else {
                              return SizedBox(
                                height: 200,
                                child: PieChart(
                                  centerWidget: Text('${state.totalValue}'),
                                  dataMap:
                                      state.status != ChartsStatus.dataMapEmpty
                                          ? state.dataMap
                                          : {'': 0},
                                  chartType: ChartType.ring,
                                  chartValuesOptions: ChartValuesOptions(
                                      showChartValues: false),
                                  legendOptions: LegendOptions(
                                    showLegends: false,
                                    legendPosition: LegendPosition.bottom,
                                    legendTextStyle:
                                        theme.textTheme.bodyMedium!,
                                  ),
                                  // colorList: generateUniqueColors(state.dataMap.length),
                                  // colorList: constColorList,
                                  colorList:
                                      state.status != ChartsStatus.dataMapEmpty
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
                      }
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: state.constDataMap.length,
                            itemBuilder: (context, index) {
                              String key =
                                  state.constDataMap.keys.elementAt(index);
                              return Container(
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
                                      padding: const EdgeInsets.only(right: 10),
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
                                    Expanded(
                                      flex: 4,
                                      // fit: FlexFit.tight,
                                      child: Container(
                                          child: Text(
                                        '$key',
                                        style: theme.textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      // fit: FlexFit.loose,
                                      child: Container(
                                        child: Text(
                                          '${state.constDataMap[key]} руб.',
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
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
