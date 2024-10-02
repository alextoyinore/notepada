import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notepada/common/helpers/extensions.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/dashboard/presentation/pages/dash_content.dart';
import 'package:notepada/features/favourites/presentation/pages/favourite.dart';
import 'package:notepada/features/listen/presentation/pages/listen.dart';
import 'package:notepada/features/note/presentation/pages/note_list.dart';

class DashPagesState {
  final int listIndex;
  final List<Widget> list;

  DashPagesState({required this.listIndex, required this.list});

  Map<String, dynamic> toJson() {
    return {
      'listIndex': listIndex,
      'list': list,
    };
  }

  factory DashPagesState.fromJson(Map<String, dynamic> json) {
    return DashPagesState(
      listIndex: json['listIndex'],
      list: List<Widget>.from(json['list']),
    );
  }
}

List<Widget> _pages = <Widget>[
  const Notes(),
  const Favourites(),
  const DashContent(),
  const Listen(),
  const Profile(),
];

class DashPagesCubit extends HydratedCubit<DashPagesState> {
  DashPagesCubit() : super(DashPagesState(listIndex: 0, list: _pages));

  void updateDashPages(int value, Widget widget) => emit(
      DashPagesState(listIndex: value, list: _pages.update(value, widget)));

  @override
  DashPagesState fromJson(Map<String, dynamic> json) {
    return DashPagesState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DashPagesState state) {
    return state.toJson();
  }
}

class SelectedIndexCubit extends HydratedCubit<int> {
  SelectedIndexCubit() : super(2);

  void updateSelectedIndex(int value) => emit(value);

  @override
  int fromJson(Map<String, dynamic> json) =>
      json['dashboardSelectedIndex'] as int;

  @override
  Map<String, int> toJson(int state) => {'dashboardSelectedIndex': state};
}

List<Map<String, dynamic>> dashboardApps = [
  {
    'title': 'Notes',
    'description': 'Take notes',
    'icon': Icons.notes_outlined,
    'color': AppColors.primary,
    'routeName': RouteNames.editNote,
  },
  {
    'title': 'Voice Notes',
    'description': 'Take voice notes',
    'icon': Icons.mic_outlined,
    'color': AppColors.green,
    'routeName': RouteNames.voiceNote,
  },
  {
    'title': 'Translate',
    'description': 'Translate text',
    'icon': Icons.translate_outlined,
    'color': AppColors.grey,
    'routeName': RouteNames.translate,
  },
  {
    'title': 'Secret Notes',
    'description': 'View your secret notes',
    'icon': Icons.lock_outline,
    'color': AppColors.red,
    'routeName': RouteNames.secretKey,
  },
  {
    'title': 'Dictionary',
    'description': 'Define words',
    'icon': Icons.book_outlined,
    'color': AppColors.voilet,
    'routeName': RouteNames.dictionary,
  },
  {
    'title': 'Scan to Read',
    'description': 'Scan to read',
    'icon': Icons.qr_code_scanner_outlined,
    'color': AppColors.orange,
    'routeName': RouteNames.scanToRead,
  },
  {
    'title': 'Bible',
    'description': 'Read the bible',
    'icon': Icons.lightbulb,
    'color': AppColors.blue,
    'routeName': RouteNames.bible,
  },
];

class DashboardAppsCubit extends HydratedCubit<List<Map<String, dynamic>>> {
  DashboardAppsCubit() : super(dashboardApps);

  void updateApps(Map<String, dynamic> value) => emit([...state, value]);

  @override
  List<Map<String, dynamic>> fromJson(Map<String, dynamic> json) =>
      json['dashboardApps'] as List<Map<String, dynamic>>;

  @override
  Map<String, List<Map<String, dynamic>>> toJson(
          List<Map<String, dynamic>> state) =>
      {'dashboardApps': state};
}
