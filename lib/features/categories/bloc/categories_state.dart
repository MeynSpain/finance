part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> listCategories;
  final CategoryModel? currentCategory;
  final List<TransactionModel> listTransactions;
  final List<TagModel>? listTags;
  final List<CategoryModel> listUnsortedCategories;
  final String messageError;

  const CategoriesState._({
    required this.listCategories,
    required this.listUnsortedCategories,
    required this.status,
    this.currentCategory,
    required this.listTransactions,
    this.listTags,
    required this.messageError,
  });

  factory CategoriesState.initial() {
    return const CategoriesState._(
        listCategories: [],
        listUnsortedCategories: [],
        status: CategoriesStatus.initial,
        listTransactions: [],
        listTags: [],
        messageError: '',
    );
  }

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? listCategories,
    List<TransactionModel>? listTransactions,
    CategoryModel? currentCategory,
    List<TagModel>? listTags,
    List<CategoryModel>? listUnsortedCategories,
    String? messageError,
  }) {
    return CategoriesState._(
      listCategories: listCategories ?? this.listCategories,
      listUnsortedCategories:
      listUnsortedCategories ?? this.listUnsortedCategories,
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      currentCategory: currentCategory ?? this.currentCategory,
      listTags: listTags ?? this.listTags,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props =>
      [
        status,
        listCategories,
        currentCategory,
        listTransactions,
        listTags,
        listUnsortedCategories,
        messageError,
      ];
}
