import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:notepada/core/error/failure.dart';
import 'package:notepada/features/note/data/models/note.dart';

abstract class INoteRepository {
  Future<Either<Failure, Document>> newNote({
    required String userID,
    required String title,
    required String text,
    required String audio,
    required String image,
    required String date,
  });

  Future<Either<Failure, List<NoteModel>>> getNotes({required String userID});
}
