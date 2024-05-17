part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> listCategories;
  final CategoryModel? currentCategory;
  final List<TransactionModel> listTransactions;
  final List<TagModel>? listTags;

  const CategoriesState._({
    required this.listCategories,
    required this.status,
    this.currentCategory,
    required this.listTransactions,
     this.listTags,
  });

  factory CategoriesState.initial() {
    return const CategoriesState._(
      listCategories: [],
      status: CategoriesStatus.initial,
      listTransactions: [],
      listTags: [],
    );
  }

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? listCategories,
    List<TransactionModel>? listTransactions,
    CategoryModel? currentCategory,
    List<TagModel>? listTags,
  }) {
    return CategoriesState._(
      listCategories: listCategories ?? this.listCategories,
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      currentCategory: currentCategory ?? this.currentCategory,
      listTags: listTags ?? this.listTags,
    );
  }

  @override
  List<Object?> get props => [
        status,
        listCategories,
        currentCategory,
        listTransactions,
        listTags,
      ];
}
