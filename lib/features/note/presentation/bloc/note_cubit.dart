import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/note/data/repository/note.dart';
import 'package:notepada/features/note/presentation/bloc/note_state.dart';
import 'package:notepada/service_locator.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  final _noteRepository = sl<NoteRepository>();
  final _storageService = sl<StorageService>();

  void newNote({
    required String title,
    String? formattedText,
    String? plainText,
    String? color,
    bool? isSecret,
  }) async {
    emit(NoteNewEditDeleteLoading());

    if (title.isEmpty) {
      emit(NoteNewEditDeleteError(error: AppStrings.noEmptyTitle));
    } else {
      final response = await _noteRepository.newNote(
          userID: _storageService.getValue('userID'),
          title: title,
          date: DateTime.now().toIso8601String(),
          dateModified: DateTime.now().toIso8601String(),
          formattedText: formattedText,
          color: color,
          plainText: plainText,
          isSecret: isSecret);
      response.fold(
        (error) => emit(NoteNewEditDeleteError(error: error.message)),
        (note) => emit(NoteNewEditDeleteSuccess(note: note)),
      );
    }
  }

  void editNote({
    String? title,
    required String documentID,
    String? formattedText,
    String? color,
    String? plainText,
    bool? isSecret,
    required String dateModified,
  }) async {
    emit(NoteNewEditDeleteLoading());
    final response = await _noteRepository.editNote(
      title: title!,
      formattedText: formattedText,
      color: color,
      plainText: plainText,
      isSecret: isSecret,
      dateModified: dateModified,
      documentID: documentID,
    );
    response.fold(
      (error) => emit(NoteNewEditDeleteError(error: error.message)),
      (note) => emit(NoteNewEditDeleteSuccess()),
    );
  }

  void getNotes({required String userID}) async {
    emit(NoteFetchLoading());

    final response = await _noteRepository.getNotes(
        userID: _storageService.getValue('userID'));
    response.fold(
      (error) => emit(NoteFetchError(error: error.message)),
      (notes) => emit(NoteFetchSuccess(notes: notes)),
    );
  }

  void deleteNote({required String documentID}) async {
    emit(NoteNewEditDeleteLoading());

    final response = await _noteRepository.deleteNote(documentID: documentID);
    response.fold(
      (error) => emit(NoteNewEditDeleteError(error: error.message)),
      (note) => emit(NoteNewEditDeleteSuccess()),
    );
  }
}
