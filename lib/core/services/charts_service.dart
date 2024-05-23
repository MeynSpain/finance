import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';

class ChartsService {
  Map<String, double> transactionsToMap(List<TransactionModel> transactions) {
    Map<String, double> transactionsMap = {};

    List<CategoryModel> categories =
        getIt<CategoriesBloc>().state.listUnsortedCategories;

    Map<TransactionModel, String> mapCategoriesNames = {};

    for (TransactionModel transaction in transactions) {
      int indexCategory = categories
          .indexWhere((category) => category.uid == transaction.categoryUid);

      mapCategoriesNames[transaction] = categories[indexCategory].name!;
    }

    for (TransactionModel transaction in transactions) {
      transactionsMap.update(
        mapCategoriesNames[transaction]!,
        (value) => value + transaction.amount.toDouble(),
        ifAbsent: () => transaction.amount.toDouble(),
      );
    }

    return transactionsMap;
  }

  int getTotalValueFromDataMap(Map<String, double> mapData) {
    int totalValue = 0;

    for (var entry in mapData.entries) {
      totalValue += entry.value.toInt();
    }

    return totalValue;
  }

  int getTotalValue(List<TransactionModel> transactions) {
    int totalValue = 0;

    for (TransactionModel transaction in transactions) {
      totalValue += transaction.amount;
    }
    return totalValue;
  }

  List<PairModel<String, double>> mapToList(Map<String, double> mapData) {
    List<PairModel<String, double>> dataList = [];

    for (var entry in mapData.entries) {
      dataList.add(PairModel(entry.key, entry.value));
    }

    return dataList;
  }

  Map<String, double> listToMap(List<PairModel<String, double>> dataList) {
    Map<String, double> dataMap = {};

    for (var data in dataList) {
      dataMap[data.first] = data.second;
    }

    return dataMap;
  }
}
