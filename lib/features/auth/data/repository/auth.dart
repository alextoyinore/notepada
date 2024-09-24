import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notepada/common/sources/appwrite.dart';
import 'package:notepada/config/constants/constants.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/core/error/server_exception.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/data/models/user.dart';
import 'package:notepada/service_locator.dart';
import 'package:notepada/features/auth/domain/repositories/iauth.dart';

class AuthRepository extends IAuthRepository {
  final _appwriteProvider = sl<AppwriteProvider>();
  final _internetConnectionChecker = sl<InternetConnectionChecker>();

  final _storageService = StorageService();

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
  Future<Either<Failure, User>> changePassword({
    required String? oldPassword,
    required String newPassword,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        User user = await _appwriteProvider.account!.updatePassword(
          password: newPassword,
          oldPassword: oldPassword!,
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
  Future<Either<Failure, Document>> createSecretKeyPIN({
    required String userID,
    required String secretKeyPIN,
  }) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        Document secretKey = await _appwriteProvider.database!.updateDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.usersCollectionID,
          documentId: userID,
          data: {
            'secretKey': secretKeyPIN,
          },
        );
        return Right(secretKey);
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

  @override
  Future<Either<Failure, dynamic>> oauth2(
      {required OAuthProvider provider}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        await _appwriteProvider.account!
            .createOAuth2Session(provider: provider);

        Future<Session> session =
            _appwriteProvider.account!.getSession(sessionId: 'current');

        // await _appwriteProvider.database?.createDocument(
        //   databaseId: AppConstants.appwriteDatabaseID,
        //   collectionId: AppConstants.usersCollectionID,
        //   documentId: user.$id,
        //   data: {
        //     'id': user.$id,
        //     'email': user.email,
        //     'firstName': user.name.split(' ')[0],
        //     'lastName': user.name.split(' ')[1],
        //     'fullName': user.name,
        //   },
        // );

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

  @override
  Future<Either<Failure, dynamic>> recoverPassword(
      {required String email}) async {
    try {
      if (await _internetConnectionChecker.hasConnection) {
        await _appwriteProvider.account!.createRecovery(
            email: email, url: 'https://notepada.com/account/passwordRecovery');
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
