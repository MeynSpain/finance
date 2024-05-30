import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/pair_model.dart';
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

    resultTransactions.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    return resultTransactions;
  }

  List<PairModel<CategoryModel, TransactionModel>> getTransactionsByCategories({
    required List<CategoryModel> categories,
    required List<TransactionModel> transactions,
  }) {
    List<PairModel<CategoryModel, TransactionModel>> resultList = [];

    for (TransactionModel transaction in transactions) {
      int indexCategory = categories
          .indexWhere((category) => category.uid == transaction.categoryUid);

      resultList.add(PairModel(categories[indexCategory], transaction));
    }

    return resultList;
  }
}
