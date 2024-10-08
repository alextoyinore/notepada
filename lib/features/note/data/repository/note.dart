import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/domain/repository/inote.dart';
import 'package:notepada/common/sources/appwrite.dart';
import 'package:notepada/service_locator.dart';
import 'package:notepada/config/constants/constants.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/error/server_exception.dart';

class NoteRepository extends INoteRepository {
  @override
  Future<Either<Failure, Document>> newNote({
    required String userID,
    required String title,
    String? color,
    String? formattedText,
    String? plainText,
    bool? isSecret,
    bool? isFavourite,
    required String date,
    required String dateModified,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    final id = ID.unique();

    try {
      if (await internetConnectionChecker.hasConnection) {
        final document = await appwriteProvider.database?.createDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.notesCollectionID,
          documentId: id,
          data: {
            'id': id,
            'userID': userID,
            'title': title,
            'formattedText': formattedText,
            'color': color,
            'plainText': plainText,
            'isSecret': isSecret,
            'isFavourite': isFavourite,
            'date': date,
            'dateModified': dateModified,
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

  @override
  Future<Either<Failure, Document>> editNote({
    required String documentID,
    String? title,
    String? formattedText,
    String? color,
    String? plainText,
    bool? isSecret,
    bool? isFavourite,
    required String dateModified,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    try {
      if (await internetConnectionChecker.hasConnection) {
        final document = await appwriteProvider.database?.updateDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.notesCollectionID,
          documentId: documentID,
          data: {
            'title': title,
            'formattedText': formattedText,
            'color': color,
            'plainText': plainText,
            'isSecret': isSecret,
            'isFavourite': isFavourite,
            'dateModified': dateModified,
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

  @override
  Future<Either<Failure, List<NoteModel>>> getNotes({
    required String userID,
    bool? isSecret,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    try {
      if (await internetConnectionChecker.hasConnection) {
        DocumentList? documents = await appwriteProvider.database
            ?.listDocuments(
                databaseId: AppConstants.appwriteDatabaseID,
                collectionId: AppConstants.notesCollectionID,
                queries: [
              Query.equal('userID', userID),
              Query.equal('isSecret', isSecret),
              Query.orderDesc('dateModified'),
            ]);
        Map<String, dynamic> data = documents!.toMap();
        List documentList = data['documents'].toList();
        List<NoteModel> noteList =
            documentList.map((e) => NoteModel.fromMap(e['data'])).toList();
        return Right(noteList);
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
  Future<Either<Failure, List<NoteModel>>> getFavouriteNotes({
    required String userID,
    bool? isSecret,
    bool? isFavourite,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    try {
      if (await internetConnectionChecker.hasConnection) {
        DocumentList? documents = await appwriteProvider.database
            ?.listDocuments(
                databaseId: AppConstants.appwriteDatabaseID,
                collectionId: AppConstants.notesCollectionID,
                queries: [
              Query.equal('userID', userID),
              Query.equal('isSecret', isSecret),
              Query.equal('isFavourite', isFavourite),
              Query.orderDesc('dateModified'),
            ]);
        Map<String, dynamic> data = documents!.toMap();
        List documentList = data['documents'].toList();
        List<NoteModel> noteList =
            documentList.map((e) => NoteModel.fromMap(e['data'])).toList();
        return Right(noteList);
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
  Future<Either<Failure, dynamic>> deleteNote({
    required String documentID,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    try {
      if (await internetConnectionChecker.hasConnection) {
        await appwriteProvider.database?.deleteDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.notesCollectionID,
          documentId: documentID,
        );

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
  Future<Either<Failure, dynamic>> updateFavourite({
    required String documentID,
    required bool isFavourite,
    required String dateModified,
  }) async {
    final appwriteProvider = sl<AppwriteProvider>();
    final internetConnectionChecker = sl<InternetConnectionChecker>();

    try {
      if (await internetConnectionChecker.hasConnection) {
        Document? document = await appwriteProvider.database?.updateDocument(
          databaseId: AppConstants.appwriteDatabaseID,
          collectionId: AppConstants.notesCollectionID,
          documentId: documentID,
          data: {
            'isFavourite': isFavourite,
            'dateModified': dateModified,
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
