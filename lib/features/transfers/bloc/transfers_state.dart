part of 'transfers_bloc.dart';

class TransfersState extends Equatable {
  final TransferStatus status;
  final List<TransferModel> transfers;
  final String errorMessage;
  final List<ViewTransferModel> viewTransfers;

  const TransfersState._({
    required this.status,
    required this.transfers,
    required this.errorMessage,
    required this.viewTransfers,
  });

  factory TransfersState.initial() {
    return const TransfersState._(
      status: TransferStatus.initial,
      transfers: [],
      errorMessage: '',
      viewTransfers: [],
    );
  }

  TransfersState copyWith(
      {TransferStatus? status,
      List<TransferModel>? transfers,
      String? errorMessage,
      List<ViewTransferModel>? viewTransfers}) {
    return TransfersState._(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      errorMessage: errorMessage ?? '',
      viewTransfers: viewTransfers ?? this.viewTransfers,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transfers,
        errorMessage,
        viewTransfers,
      ];
}
