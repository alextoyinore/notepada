import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/features/auth/data/repository/auth_repository.dart';
import 'package:notepada/features/auth/presentation/bloc/login_state.dart';
import 'package:notepada/service_locator.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();

  void login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final response = await _authRepository.login(
      email: email,
      password: password,
    );

    response.fold(
      (failure) => emit(LoginError(error: failure.message)),
      (session) => emit(LoginSuccess(session: session)),
    );
  }
}
