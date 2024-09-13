import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notepada/common/sources/appwrite.dart';
import 'package:notepada/config/constants/constants.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/core/error/server_exception.dart';
import 'package:notepada/features/auth/data/models/user.dart';
import 'package:notepada/service_locator.dart';
import 'package:notepada/features/auth/domain/repositories/iauth.dart';

class AuthRepository extends IAuthRepository {
  final _appwriteProvider = sl<AppwriteProvider>();
  final _internetConnectionChecker = sl<InternetConnectionChecker>();

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        User user = await _appwriteProvider.account!.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: '$firstName $lastName');
        await _appwriteProvider.database?.createDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.usersCollectionID,
          documentId: user.$id,
          data: {
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'fullName': user.name,
          },
        );
        return Right(user);
      } else {
        return Left(
          Failure(message: AppStrings.noInternetConnection),
        );
      }
    } on AppwriteException catch (e) {
      return Left(Failure(message: e.message!));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Session>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Session session =
            await _appwriteProvider.account!.createEmailPasswordSession(
          email: email,
          password: password,
        );
        return Right(session);
      } else {
        return Left(
          Failure(message: AppStrings.noInternetConnection),
        );
      }
    } on AppwriteException catch (e) {
      return Left(Failure(message: e.message!));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Session>> checkSession() async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Session session =
            await _appwriteProvider.account!.getSession(sessionId: 'current');
        return Right(session);
      } else {
        return Left(
          Failure(message: AppStrings.noInternetConnection),
        );
      }
    } on AppwriteException catch (e) {
      return Left(Failure(message: e.message!));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser({required String userID}) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();
    try {
      if (await internetConnectionChecker.hasConnection) {
        Document? document = await appwriteProvider.database?.getDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.usersCollectionID,
          documentId: userID,
        );
        // print(document!.data);
        final user = UserModel.fromMap(document!.data);
        return Right(user);
      } else {
        return Left(
          Failure(message: AppStrings.noInternetConnection),
        );
      }
    } on AppwriteException catch (e) {
      return Left(Failure(message: e.message!));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> logout() async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        await _appwriteProvider.account!.deleteSession(sessionId: 'current');
        return const Right(1);
      } else {
        return Left(
          Failure(message: AppStrings.noInternetConnection),
        );
      }
    } on AppwriteException catch (e) {
      return Left(Failure(message: e.message!));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
