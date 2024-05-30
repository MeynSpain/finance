import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/last_transactions_status.dart';
import 'package:finance/features/last_transactions/bloc/last_transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LastTransactionsWidget extends StatelessWidget {
  const LastTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LastTransactionsBloc, LastTransactionsState>(
      builder: (context, state) {
        return state.status == LastTransactionsStatus.loading ||
                state.status == LastTransactionsStatus.initial
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.getFormatDate(state
                            .transactions[index].second.timestamp!
                            .toDate())),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  state.transactions[index].first.name ?? 'Категория не указана',
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
                              state.transactions[index].second.type ==
                                  Globals.typeTransactionsExpense
                                  ? '-${state.transactions[index].second.amount} руб.'
                                  : '+${state.transactions[index].second.amount} руб.',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 20,
                                color: state.transactions[index].second.type ==
                                    Globals.typeTransactionsExpense
                                    ? Colors.redAccent
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        state.transactions[index].second.tags != null
                            ? Wrap(
                          children: [
                            ...List.generate(
                                state.transactions[index].second.tags!
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
                                    state.transactions[index].second.tags![tagIndex].name,
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
                        state.transactions[index].second.description != null &&
                            state.transactions[index].second.description !=
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
                              '${state.transactions[index].second.description}',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 20),
                            )
                          ],
                        )
                            : SizedBox()
                      ],
                    ),
                  );
                });
      },
    );
  }
}
