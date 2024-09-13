import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:notepada/core/error/failure.dart';

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

  Future<Either<Failure, Session>> checkSession();

  Future<Either<Failure, User>> getUser({
    required String userID,
  });
}
