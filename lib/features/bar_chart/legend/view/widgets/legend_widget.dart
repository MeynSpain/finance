import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/bar_legend_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/services/money_service.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/legend/bloc/bar_legend_bloc.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/charts/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LegendWidget extends StatelessWidget {
  LegendWidget({super.key});

  final MoneyService moneyService = MoneyService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BarLegendBloc, BarLegendState>(
      builder: (context, state) {
        if (state.status == BarLegendStatus.loading) {
          return const CircularProgressIndicator();
        }
        if (state.status == BarLegendStatus.error) {
          return Center(
            child: Text(
              state.errorMessage,
              style: theme.textTheme.bodyLarge,
            ),
          );
        }
        return ListView.builder(
            itemCount: state.showingMap.length,
            itemBuilder: (context, index) {
              CategoryModel key = state.showingMap.keys.elementAt(index);
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: GestureDetector(
                  onTap: () {
                    getIt<TransactionHistoryBloc>().add(
                        TransactionHistoryLoadTransactionsEvent(
                            transactions: state.transactions,
                            categoryName: key.name!,
                            categories: getIt<CategoriesBloc>()
                                .state
                                .listUnsortedCategories));
                    Navigator.of(context).pushNamed('/charts/transactions');
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          key.name ?? 'Неизвестная категория',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: state.typeTransaction ==
                                Globals.typeTransactionsExpense
                            ? Text(
                                '-${moneyService.convert(state.showingMap[key]!.toInt(), 100)} руб.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              )
                            : Text(
                                '+${moneyService.convert(state.showingMap[key]!.toInt(), 100)} руб.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.green,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
