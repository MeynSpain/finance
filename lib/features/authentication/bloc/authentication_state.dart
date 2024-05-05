part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccessState extends AuthenticationState {
  final String? displayName;

  const AuthenticationSuccessState({this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class AuthenticationFailureState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}
