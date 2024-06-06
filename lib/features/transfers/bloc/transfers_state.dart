part of 'transfers_bloc.dart';

class TransfersState extends Equatable {
  final TransferStatus status;
  final List<TransferModel> transfers;
  final String errorMessage;
  final List<ViewTransferModel> viewTransfers;
  final List<AccountModel> accounts;
  final List<AccountModel> notSelectedAccounts;
  final AccountModel? fromAccount;
  final AccountModel? toAccount;

  const TransfersState._({
    required this.status,
    required this.transfers,
    required this.errorMessage,
    required this.viewTransfers,
    required this.accounts,
    required this.notSelectedAccounts,
    required this.fromAccount,
    required this.toAccount,
  });

  factory TransfersState.initial() {
    return const TransfersState._(
      status: TransferStatus.initial,
      transfers: [],
      errorMessage: '',
      viewTransfers: [],
      accounts: [],
      notSelectedAccounts: [],
      fromAccount: null,
      toAccount: null,
    );
  }

  TransfersState copyWith({
    TransferStatus? status,
    List<TransferModel>? transfers,
    String? errorMessage,
    List<ViewTransferModel>? viewTransfers,
    List<AccountModel>? accounts,
    List<AccountModel>? notSelectedAccounts,
    AccountModel? fromAccount,
    AccountModel? toAccount,
  }) {
    return TransfersState._(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      errorMessage: errorMessage ?? '',
      viewTransfers: viewTransfers ?? this.viewTransfers,
      accounts: accounts ?? this.accounts,
      notSelectedAccounts: notSelectedAccounts ?? this.notSelectedAccounts,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transfers,
        errorMessage,
        viewTransfers,
        accounts,
        notSelectedAccounts,
        fromAccount,
        toAccount,
      ];
}
