import 'package:appwrite/models.dart';
import 'package:notepada/features/note/data/models/note.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteFetchLoading extends NoteState {}

class NoteFetchSuccess extends NoteState {
  final List<NoteModel> notes;
  NoteFetchSuccess({required this.notes});
}

class NoteFetchError extends NoteState {
  final String error;
  NoteFetchError({required this.error});
}

class NoteNewEditDeleteLoading extends NoteState {}

class NoteNewEditDeleteSuccess extends NoteState {
  final Document? note;
  NoteNewEditDeleteSuccess({this.note});
}

class NoteNewEditDeleteError extends NoteState {
  final String error;
  NoteNewEditDeleteError({required this.error});
}
