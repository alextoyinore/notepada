import 'package:hydrated_bloc/hydrated_bloc.dart';

class DashBoardCubit extends HydratedCubit<int> {
  DashBoardCubit() : super(2);

  void updateSelectedIndex(int value) => emit(value);

  @override
  int fromJson(Map<String, dynamic> json) =>
      json['dashboardSelectedIndex'] as int;

  @override
  Map<String, int> toJson(int state) => {'dashboardSelectedIndex': state};
}
