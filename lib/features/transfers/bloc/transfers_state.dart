part of 'transfers_bloc.dart';

class TransfersState extends Equatable {
  final TransferStatus status;
  final List<TransferModel> transfers;
  final String errorMessage;

  const TransfersState._({
    required this.status,
    required this.transfers,
    required this.errorMessage,
  });

  factory TransfersState.initial() {
    return const TransfersState._(
      status: TransferStatus.initial,
      transfers: [],
      errorMessage: '',
    );
  }

  TransfersState copyWith({
    TransferStatus? status,
    List<TransferModel>? transfers,
    String? errorMessage,
  }) {
    return TransfersState._(
      status: status ?? this.status,
      transfers: transfers ?? this.transfers,
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [
        status,
        transfers,
        errorMessage,
      ];
}
