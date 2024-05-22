import 'package:finance/core/models/transaction_model.dart';

class ChartsService {
  Map<String, double> transactionsToMap(List<TransactionModel> transactions) {
    Map<String, double> transactionsMap = {};

    for (TransactionModel transaction in transactions) {
      late String name;
      if (transaction.tags!.isEmpty) {
        name = 'Без тега';
      } else {
        name = transaction.tags!.first.name;
      }

      transactionsMap.update(
        name,
        (value) => value + transaction.amount.toDouble(),
        ifAbsent: () => transaction.amount.toDouble(),
      );
    }

    print('MAP DATA: $transactionsMap}');
    return transactionsMap;
  }
}
