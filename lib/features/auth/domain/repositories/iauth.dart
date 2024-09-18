import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/features/auth/data/models/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, dynamic>> recoverPassword({
    required String email,
  });

  Future<Either<Failure, Session>> checkSession();

  Future<Either<Failure, UserModel>> getUser({
    required String userID,
  });

  Future<Either<Failure, dynamic>> logout();

  Future<Either<Failure, dynamic>> oauth2({required OAuthProvider provider});
}
