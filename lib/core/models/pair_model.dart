import 'package:equatable/equatable.dart';

class PairModel<T, K> extends Equatable {
  T _first;
  K _second;

  PairModel(this._first, this._second);

  K get second => _second;

  set second(K value) {
    _second = value;
  }

  T get first => _first;

  set first(T value) {
    _first = value;
  }

  @override
  String toString() {
    return 'PairModel{$_first, $_second}';
  }

  @override
  List<Object?> get props => [_first, _second];

// PairModel({required this.first, required this.second});
}
