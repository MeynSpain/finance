import 'package:finance/core/constants/globals.dart';
import 'package:finance/features/charts/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Транзакции'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
                builder: (context, state) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            // color: Colors.grey[300],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.getFormatDate(state
                                  .transactions[index].timestamp!
                                  .toDate())),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        state.categoryName,
                                        style:
                                            theme.textTheme.bodyLarge!.copyWith(
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    flex: 6,
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                    flex: 1,
                                  ),
                                  Text(
                                    state.transactions[index].type ==
                                            Globals.typeTransactionsExpense
                                        ? '-${state.transactions[index].amount} руб.'
                                        : '+${state.transactions[index].amount} руб.',
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontSize: 20,
                                      color: state.transactions[index].type ==
                                              Globals.typeTransactionsExpense
                                          ? Colors.redAccent
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              state.transactions[index].tags != null
                                  ? Wrap(
                                      children: [
                                        ...List.generate(
                                            state.transactions[index].tags!
                                                .length, (tagIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 2),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              padding:
                                                  EdgeInsetsDirectional.all(10),
                                              child: Text(
                                                '${state.transactions[index].tags![tagIndex].name}',
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                      ],
                                    )
                                  : SizedBox(),
                              state.transactions[index].description != null &&
                                      state.transactions[index].description !=
                                          ''
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, bottom: 2),
                                          child: Divider(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${state.transactions[index].description}',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(fontSize: 20),
                                        )
                                      ],
                                    )
                                  : SizedBox()
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: state.transactions.length,
                    ),
                  );
                },
              ),
            ],
          )),
    );
  }
}
