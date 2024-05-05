part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStartedEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationSignedOutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
