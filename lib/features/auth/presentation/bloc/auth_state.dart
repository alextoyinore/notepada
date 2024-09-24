import 'package:appwrite/models.dart';
import 'package:notepada/features/auth/data/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

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

class OAuth2Loading extends AuthState {}

class OAuth2Error extends AuthState {
  final String error;
  OAuth2Error({required this.error});
}

class OAuth2Success extends AuthState {
  final bool? success;
  OAuth2Success({this.success});
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

class ChangePasswordLoading extends AuthState {}

class ChangePasswordError extends AuthState {
  final String error;
  ChangePasswordError({required this.error});
}

class ChangePasswordSuccess extends AuthState {
  final dynamic response;
  ChangePasswordSuccess({this.response});
}

class CreateSecretKeyLoading extends AuthState {}

class CreateSecretKeyError extends AuthState {
  final String error;
  CreateSecretKeyError({required this.error});
}

class CreateSecretKeySuccess extends AuthState {
  final dynamic response;
  CreateSecretKeySuccess({this.response});
}
