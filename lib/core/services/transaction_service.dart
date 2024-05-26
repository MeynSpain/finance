import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/transaction_model.dart';

class TransactionService {
  List<TransactionModel> getTransactionsByCategoryName(
      {required String categoryName,
      required List<TransactionModel> transactions,
      required List<CategoryModel> categories}) {
    List<TransactionModel> resultTransactions = [];

    int indexCategory = categories
        .indexWhere((category) => category.name!.trim() == categoryName.trim());

    for (TransactionModel transaction in transactions) {
      if (transaction.categoryUid == categories[indexCategory].uid) {
        resultTransactions.add(transaction);
      }
    }

    resultTransactions.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

    return resultTransactions;
  }
}
