import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/features/auth/data/repository/auth.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class LoginCubit extends Cubit<AuthState> {
  LoginCubit() : super(AuthInitial());

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
