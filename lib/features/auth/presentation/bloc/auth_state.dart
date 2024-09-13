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
