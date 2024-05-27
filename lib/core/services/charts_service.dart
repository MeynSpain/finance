import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/pair_model.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/material.dart';

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

  Map<String, double> transactionsToMapByTags(
      List<TransactionModel> transactions) {
    Map<String, double> transactionsMap = {};

    for (TransactionModel transaction in transactions) {
      if (transaction.tags != null) {
        for (TagModel tag in transaction.tags!) {
          transactionsMap.update(
            tag.name,
            (value) => value + transaction.amount.toDouble(),
            ifAbsent: () => transaction.amount.toDouble(),
          );
        }
      }
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

  void divideTransactionsIntoIncomeAndExpense({
    required List<TransactionModel> transactions,
    required List<TransactionModel> listIncome,
    required List<TransactionModel> listExpense,
  }) {
    for (TransactionModel transaction in transactions) {
      if (transaction.type == Globals.typeTransactionsIncome) {
        listIncome.add(transaction);
      } else if (transaction.type == Globals.typeTransactionsExpense) {
        listExpense.add(transaction);
      }
    }
  }

  Color hslToColor(double h, double s, double l) {
    double chroma = (1.0 - (2.0 * l - 1.0).abs()) * s;
    double x = chroma * (1.0 - ((h / 60.0) % 2 - 1.0).abs());
    double m = l - chroma / 2.0;
    double r = 0, g = 0, b = 0;

    if (0 <= h && h < 60) {
      r = chroma;
      g = x;
      b = 0;
    } else if (60 <= h && h < 120) {
      r = x;
      g = chroma;
      b = 0;
    } else if (120 <= h && h < 180) {
      r = 0;
      g = chroma;
      b = x;
    } else if (180 <= h && h < 240) {
      r = 0;
      g = x;
      b = chroma;
    } else if (240 <= h && h < 300) {
      r = x;
      g = 0;
      b = chroma;
    } else if (300 <= h && h < 360) {
      r = chroma;
      g = 0;
      b = x;
    }

    r = ((r + m) * 255).round().toDouble();
    g = ((g + m) * 255).round().toDouble();
    b = ((b + m) * 255).round().toDouble();

    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1.0);
  }

  // Функция для генерации списка уникальных цветов
  List<Color> generateUniqueColors(int numberOfColors) {
    double saturation = 1.0;
    double lightness = 0.5;

    List<Color> colors = [];
    for (int i = 0; i < numberOfColors; i++) {
      double hue = (i * 360 / numberOfColors) % 360;
      colors.add(hslToColor(hue, saturation, lightness));
      saturation = 0.7 + (i % 2) * 0.3;
      lightness = 0.4 + ((i % 2) * 0.3);
    }
    return colors;
  }

  Map<String, Color> getMapColor(
      Map<String, double> dataMap, List<Color> colors) {
    Map<String, Color> colorMap = {};

    int i = 0;
    for (var entry in dataMap.entries) {
      colorMap[entry.key] = colors[i];
      i++;
    }

    return colorMap;
  }
}
