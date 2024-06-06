import 'package:finance/core/constants/status/transfer_status.dart';
import 'package:finance/core/models/transfer_model.dart';
import 'package:finance/core/models/view/viewTransferModel.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransfersHistory extends StatelessWidget {
  const TransfersHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('История переводов'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocBuilder<TransfersBloc, TransfersState>(
            builder: (context, state) {
              if (state.status == TransferStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              return Container(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: state.transfers.length,
                      itemBuilder: (context, index) {
                        ViewTransferModel transfer = state.viewTransfers[index];
                    return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${transfer.dateTime.hour}:${transfer.dateTime.minute} - ${transfer.dateTime.day}.${transfer.dateTime.month}.${transfer.dateTime.year}'),
                                Text('${transfer.fromAccount?.name ?? 'Стартовый баланс'}'),
                                Icon(Icons.arrow_downward),
                                Text('${transfer.toAccount.name}'),
                              ],
                            ),
                            Text('${transfer.amount} руб.', style: theme.textTheme.bodyLarge,)
                          ],
                        ));
                  }),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
