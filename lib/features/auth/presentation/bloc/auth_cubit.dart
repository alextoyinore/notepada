import 'package:appwrite/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/data/repository/auth.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
import 'package:notepada/service_locator.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();
  final StorageService _storageService = sl<StorageService>();

  void getUser({required String userID}) async {
    emit(UserLoading());

    final response = await _authRepository.getUser(userID: userID);

    response.fold(
      (failure) => emit(UserError(error: failure.message)),
      (user) => emit(UserSuccess(user: user)),
    );
  }

  void logout() async {
    emit(LoggingOut());

    final response = await _authRepository.logout();

    response.fold(
      (failure) => emit(UserError(error: failure.message)),
      (user) => null,
    );
  }

  void oauth2({
    required OAuthProvider provider,
  }) async {
    emit(OAuth2Loading());

    final response = await _authRepository.oauth2(provider: provider);
    await Future.delayed(const Duration(microseconds: 500));

    response.fold(
      (failure) => emit(RegisterError(error: failure.message)),
      (session) => emit(OAuth2Success()),
    );
  }

  void recoverPassword({required String email}) async {
    emit(RecoverPasswordLoading());

    final response = await _authRepository.recoverPassword(email: email);

    response.fold(
      (failure) => emit(RecoverPasswordError(error: failure.message)),
      (response) => emit(RecoverPasswordSuccess(response: response)),
    );
  }

  void createSecretKey(
      {required String userID, required String secretKeyPIN}) async {
    emit(CreateSecretKeyLoading());

    if (secretKeyPIN.length != 4) {
      emit(CreateSecretKeyError(error: AppStrings.secretKeyMustBe4Digits));
      return;
    }

    if (secretKeyPIN.contains(RegExp(r'[a-zA-Z]'))) {
      emit(CreateSecretKeyError(error: AppStrings.secretKeyPINErrorNumeric));
      return;
    }

    final response = await _authRepository.createSecretKeyPIN(
        userID: userID, secretKeyPIN: secretKeyPIN);
    _storageService.setValue(StorageKeys.secretKeyPIN, secretKeyPIN);

    response.fold(
      (failure) => emit(CreateSecretKeyError(error: failure.message)),
      (success) => emit(CreateSecretKeySuccess(response: success)),
    );
  }

  void changePassword(
      {required String newPassword, String? oldPassword}) async {
    emit(ChangePasswordLoading());

    final response = await _authRepository.changePassword(
        newPassword: newPassword, oldPassword: oldPassword);

    response.fold(
      (failure) => emit(ChangePasswordError(error: failure.message)),
      (response) => emit(ChangePasswordSuccess(response: response)),
    );
  }
}
