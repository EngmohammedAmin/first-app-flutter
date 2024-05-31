// ignore_for_file: hash_and_equals

import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String username;
  final String password;

  const LoginEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];

  @override
  String toString() => 'LoginEvent{username: $username, password: $password}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginEvent &&
        other.username == username &&
        other.password == password;
  }
}

class LogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];

  const LogoutEvent();

  @override
  String toString() => 'LogoutEvent{}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogoutEvent;
  }
}
