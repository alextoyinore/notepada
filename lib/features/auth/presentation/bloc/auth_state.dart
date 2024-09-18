import 'package:appwrite/models.dart';
import 'package:notepada/features/auth/data/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class OAuthLoading extends AuthState {}

class OAuthSuccess extends AuthState {
  final User user;
  OAuthSuccess({required this.user});
}

class OAuthError extends AuthState {
  final String error;
  OAuthError({required this.error});
}

// REGISTER STATES

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final User user;
  RegisterSuccess({required this.user});
}

class RegisterError extends AuthState {
  final String error;
  RegisterError({required this.error});
}

// LOGIN STATES

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final Session session;
  LoginSuccess({required this.session});
}

class LoginError extends AuthState {
  final String error;
  LoginError({required this.error});
}

// USER DATA

class UserLoading extends AuthState {}

class UserSuccess extends AuthState {
  final UserModel? user;
  UserSuccess({this.user});
}

class UserError extends AuthState {
  final String error;
  UserError({required this.error});
}

class LoggingOut extends AuthState {}

class OAuth2Success extends AuthState {
  final Session? session;
  OAuth2Success({this.session});
}

class RecoverPasswordLoading extends AuthState {}

class RecoverPasswordError extends AuthState {
  final String error;
  RecoverPasswordError({required this.error});
}

class RecoverPasswordSuccess extends AuthState {
  final dynamic response;
  RecoverPasswordSuccess({this.response});
}
