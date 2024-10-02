import 'package:hydrated_bloc/hydrated_bloc.dart';

class InputPinCubit extends HydratedCubit<String> {
  InputPinCubit() : super('');

  void updatePIN(String value) => emit(state + value);

  @override
  String fromJson(Map<String, dynamic> json) => json['viewFontSize'] as String;

  @override
  Map<String, String> toJson(String state) => {'viewFontSize': state};
}
