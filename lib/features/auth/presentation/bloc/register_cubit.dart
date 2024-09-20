import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/features/auth/data/repository/auth.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class RegisterCubit extends Cubit<AuthState> {
  RegisterCubit() : super(AuthInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();

  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    final response = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    response.fold(
      (failure) => emit(RegisterError(error: failure.message)),
      (user) => emit(RegisterSuccess(user: user)),
    );
  }
}
