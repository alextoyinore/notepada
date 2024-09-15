import 'package:appwrite/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/features/auth/data/repository/auth.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();

  void oauth2({
    required OAuthProvider provider,
  }) async {
    emit(RegisterLoading());

    final response = await _authRepository.oauth2(provider: provider);
    await Future.delayed(const Duration(microseconds: 500));

    response.fold(
      (failure) => emit(RegisterError(error: failure.message)),
      (session) => emit(OAuth2Success(session: session)),
    );
  }
}
