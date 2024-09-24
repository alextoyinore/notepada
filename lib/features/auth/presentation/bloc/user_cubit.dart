// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notepada/features/auth/data/repository/auth.dart';
// import 'package:notepada/features/auth/presentation/bloc/auth_state.dart';
// import 'package:notepada/service_locator.dart';

// class UserCubit extends Cubit<AuthState> {
//   UserCubit() : super(AuthInitial());

//   final AuthRepository _authRepository = sl<AuthRepository>();

//   void getUser({required String userID}) async {
//     emit(UserLoading());

//     final response = await _authRepository.getUser(userID: userID);

//     response.fold(
//       (failure) => emit(UserError(error: failure.message)),
//       (user) => emit(UserSuccess(user: user)),
//     );
//   }

//   void logout() async {
//     emit(LoggingOut());

//     final response = await _authRepository.logout();

//     response.fold(
//       (failure) => emit(UserError(error: failure.message)),
//       (user) => null,
//     );
//   }
// }
