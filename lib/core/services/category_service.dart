import 'package:finance/core/models/category_model.dart';

class CategoryService {
  CategoryModel? getCategoryByType(
      String typeCategory, List<CategoryModel> categories) {
    CategoryModel? categoryModel;

    int index = categories.indexWhere((element) => element.type == typeCategory);

    categoryModel = categories[index];

    return categoryModel;
  }
}
