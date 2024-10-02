import 'package:flutter/material.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/auth/presentation/pages/auth.dart';
import 'package:notepada/features/auth/presentation/pages/change_password.dart';
import 'package:notepada/features/auth/presentation/pages/recover_password.dart';
import 'package:notepada/features/auth/presentation/pages/secret_key.dart';
import 'package:notepada/features/dashboard/presentation/pages/dashboard.dart';
import 'package:notepada/features/favourites/presentation/pages/favourite.dart';
import 'package:notepada/features/note/presentation/pages/note_list.dart';
import 'package:notepada/features/listen/presentation/pages/listen.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/pages/edit.dart';
import 'package:notepada/features/note/presentation/pages/view_note.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/secret/presentation/pages/secret_note.dart';
import 'package:notepada/features/splash/presentation/pages/splash.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/features/auth/presentation/pages/login.dart';
import 'package:notepada/features/auth/presentation/pages/register.dart';
import 'package:notepada/features/intro/presentation/pages/intro.dart';
import 'package:notepada/features/translate/presentation/pages/translator.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.splash,
      builder: (context, state) => const Splash(),
    ),
    GoRoute(
      path: '/intro',
      name: RouteNames.intro,
      builder: (context, state) => const Intro(),
    ),
    GoRoute(
      path: '/auth',
      name: RouteNames.auth,
      builder: (context, state) => const Auth(),
    ),
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/register',
      name: RouteNames.register,
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/recoverPassword',
      name: RouteNames.recoverPassword,
      builder: (context, state) => const RecoverPassword(),
    ),
    GoRoute(
      path: '/changePassword',
      name: RouteNames.changePassword,
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: '/dashboard',
      name: RouteNames.dashboard,
      builder: (context, state) => Dashboard(
        key: UniqueKey(),
      ),
    ),
    GoRoute(
      path: '/notes',
      name: RouteNames.notes,
      builder: (context, state) => Notes(
        key: UniqueKey(),
      ),
    ),
    GoRoute(
      path: '/secretNotes',
      name: RouteNames.secretNotes,
      builder: (context, state) => SecretNotes(
        key: UniqueKey(),
      ),
    ),
    GoRoute(
      path: '/secretKey',
      name: RouteNames.secretKey,
      builder: (context, state) => const SecretKey(),
    ),
    GoRoute(
      path: '/editNote',
      name: RouteNames.editNote,
      builder: (context, state) => EditNote(
        note: state.extra as NoteModel?,
      ),
    ),
    GoRoute(
      path: '/viewNote',
      name: RouteNames.viewNote,
      builder: (context, state) => ViewNote(
        note: state.extra as NoteModel,
      ),
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (context, state) => const Profile(),
    ),
    GoRoute(
      path: '/favourites',
      name: RouteNames.favourites,
      builder: (context, state) => const Favourites(),
    ),
    GoRoute(
      path: '/listen',
      name: RouteNames.listen,
      builder: (context, state) => const Listen(),
    ),
    GoRoute(
      path: '/translate',
      name: RouteNames.translate,
      builder: (context, state) => const Translator(),
    ),
  ],
);
