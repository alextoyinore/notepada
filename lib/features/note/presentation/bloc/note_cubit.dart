import 'package:flutter_bloc/flutter_bloc.dart';
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
    String? text,
    String? color,
    String? audio,
    String? image,
  }) async {
    emit(NoteNewEditDeleteLoading());
    final response = await _noteRepository.newNote(
        userID: _storageService.getValue('userID'),
        title: title,
        date: DateTime.now().toIso8601String(),
        text: text,
        color: color,
        audio: audio,
        image: image);
    response.fold(
      (error) => emit(NoteNewEditDeleteError(error: error.message)),
      (note) => emit(NoteNewEditDeleteSuccess(note: note)),
    );
  }

  void editNote({
    String? title,
    required String documentID,
    String? text,
    String? color,
    String? audio,
    String? image,
  }) async {
    emit(NoteNewEditDeleteLoading());
    final response = await _noteRepository.editNote(
      title: title!,
      text: text,
      color: color,
      audio: audio,
      image: image,
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
