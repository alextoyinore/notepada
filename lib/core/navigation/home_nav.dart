import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/features/auth/presentation/pages/secret_key.dart';
import 'package:notepada/features/dashboard/presentation/pages/dash_content.dart';
import 'package:notepada/features/listen/presentation/pages/voice_note.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/pages/edit.dart';
import 'package:notepada/features/note/presentation/pages/note_list.dart';
import 'package:notepada/features/note/presentation/pages/view_note.dart';
import 'package:notepada/features/secret/presentation/pages/secret_note.dart';

class HomeNav extends StatefulWidget {
  final NoteModel? note;
  HomeNav({super.key, this.note});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) {
          if (settings.name == '/editNote') {
            context.read<SelectedIndexCubit>().updateSelectedIndex(0);
            return const EditNote();
          }
          if (settings.name == '/viewNote') {
            context.read<SelectedIndexCubit>().updateSelectedIndex(0);
            return ViewNote(note: widget.note!);
          }
          if (settings.name == '/secretNotes') {
            context.read<SelectedIndexCubit>().updateSelectedIndex(0);
            return const SecretKey();
          }
          if (settings.name == '/secretKey') {
            context.read<SelectedIndexCubit>().updateSelectedIndex(0);
            return const SecretKey();
          }
          if (settings.name == '/voiceNote') {
            context.read<SelectedIndexCubit>().updateSelectedIndex(0);
            return const VoiceNote();
          }
          return const DashContent();
        },
      ),
    );
  }
}
