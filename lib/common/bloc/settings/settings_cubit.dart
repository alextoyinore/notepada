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

class VoicePitchCubit extends HydratedCubit<int> {
  VoicePitchCubit() : super(50);

  void increment() => state <= 95 ? emit(state + 5) : null;
  void decrement() => state >= 5 ? emit(state - 5) : null;

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json['voiceDepth'] as int;
  }

  @override
  Map<String, int>? toJson(int state) {
    return {'voiceDepth': state};
  }
}

class VoiceRateCubit extends HydratedCubit<int> {
  VoiceRateCubit() : super(50);

  void increment() => state <= 95 ? emit(state + 5) : null;
  void decrement() => state >= 5 ? emit(state - 5) : null;

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json['voiceRate'] as int;
  }

  @override
  Map<String, int>? toJson(int state) {
    return {'voiceRate': state};
  }
}

class VoiceVolumeCubit extends HydratedCubit<int> {
  VoiceVolumeCubit() : super(50);

  void increment() => state <= 95 ? emit(state + 5) : null;
  void decrement() => state >= 5 ? emit(state - 5) : null;

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json['voiceVolume'] as int;
  }

  @override
  Map<String, int>? toJson(int state) {
    return {'voiceVolume': state};
  }
}
