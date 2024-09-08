import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/features/auth/data/repository/auth_repository.dart';
import 'package:notepada/features/splash/presentation/bloc/splash_state.dart';
import 'package:notepada/service_locator.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final _authRepository = sl<AuthRepository>();

  void checkSession() async {
    emit(SplashLoading());

    final response = await _authRepository.checkSession();

    response.fold(
      (failure) => emit(SplashError(error: failure.message)),
      (session) => emit(
        SplashSuccess(),
      ),
    );
  }
}

