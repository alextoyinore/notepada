import 'package:hydrated_bloc/hydrated_bloc.dart';

class NoteViewFontCubit extends HydratedCubit<int> {
  NoteViewFontCubit() : super(16);

  void increment() => emit(state + 2);
  void decrement() => emit(state - 2);

  @override
  int fromJson(Map<String, dynamic> json) => json['viewFontSize'] as int;

  @override
  Map<String, int> toJson(int state) => {'viewFontSize': state};
}

class NoteListFontCubit extends HydratedCubit<int> {
  NoteListFontCubit() : super(16);

  void increment() => emit(state + 2);
  void decrement() => emit(state - 2);

  @override
  int fromJson(Map<String, dynamic> json) => json['viewFontSize'] as int;

  @override
  Map<String, int> toJson(int state) => {'viewFontSize': state};
}
