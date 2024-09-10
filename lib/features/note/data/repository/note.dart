import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/features/note/domain/repository/inote.dart';
import 'package:notepada/common/sources/appwrite.dart';
import 'package:notepada/service_locator.dart';
import 'package:notepada/config/constants/constants.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/error/server_exception.dart';


class NoteRepository extends INoteRepository {
  @override
  Future<Either<Failure, Document>> addNote({
    required String id,
    required String userID,
    required String title,
    String? text,
    String? audio,
    String? image,
    required DateTime date,
  }) async {
    final _appwriteProvider = sl<AppwriteProvider>();
    final _internetConnectionChecker = sl<InternetConnectionChecker>();

    final id = ID.unique();

    try {
      if (await _internetConnectionChecker.hasConnection) {
       final document = await _appwriteProvider.database?.createDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.notesCollectionID,
          documentId: id,
          data: {
            'id': id,
            'userID': userID,
            'title': title,
            'text': text,
            'audio': audio,
            'image': image,
            'date': date,
          },
        );
        return Right(document!);
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

