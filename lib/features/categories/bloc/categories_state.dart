part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> listCategories;

  const CategoriesState._({
    required this.listCategories,
    required this.status,
  });

  factory CategoriesState.initial() {
    return const CategoriesState._(
      listCategories: [],
      status: CategoriesStatus.initial,
    );
  }

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? listCategories,
  }) {
    return CategoriesState._(
      listCategories: listCategories ?? this.listCategories,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, listCategories];
}
