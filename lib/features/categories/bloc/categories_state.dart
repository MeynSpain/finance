part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryModel> listCategories;
  final List<AccountModel> listAccounts;
  final AccountModel? currentAccount;
  final List<TransactionModel> listTransactions;
  final List<TagModel>? listTags;
  final List<CategoryModel> listUnsortedCategories;
  final DateTime selectedDate;
  final String messageError;
  final int totalBalance;

  const CategoriesState._({
    required this.listCategories,
    required this.listUnsortedCategories,
    required this.status,
    required this.listAccounts,
    this.currentAccount,
    required this.listTransactions,
    this.listTags,
    required this.messageError,
    required this.selectedDate,
    required this.totalBalance,
  });

  factory CategoriesState.initial() {
    return CategoriesState._(
      listCategories: [],
      listUnsortedCategories: [],
      status: CategoriesStatus.initial,
      listTransactions: [],
      listTags: [],
      messageError: '',
      selectedDate: DateTime.now(),
      listAccounts: [],
      totalBalance: 0,
    );
  }

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryModel>? listCategories,
    List<TransactionModel>? listTransactions,
    AccountModel? currentAccount,
    List<TagModel>? listTags,
    List<CategoryModel>? listUnsortedCategories,
    String? messageError,
    DateTime? selectedDate,
    List<AccountModel>? listAccounts,
    int? totalBalance,
  }) {
    return CategoriesState._(
      listCategories: listCategories ?? this.listCategories,
      listUnsortedCategories:
          listUnsortedCategories ?? this.listUnsortedCategories,
      status: status ?? this.status,
      listTransactions: listTransactions ?? this.listTransactions,
      currentAccount: currentAccount ?? this.currentAccount,
      listTags: listTags ?? this.listTags,
      messageError: messageError ?? this.messageError,
      selectedDate: selectedDate ?? this.selectedDate,
      listAccounts: listAccounts ?? this.listAccounts,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        listCategories,
        currentAccount,
        listAccounts,
        listTransactions,
        listTags,
        listUnsortedCategories,
        messageError,
        selectedDate,
        totalBalance,
      ];
}
