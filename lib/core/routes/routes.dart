import 'package:flutter/material.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/features/auth/presentation/pages/auth.dart';
import 'package:notepada/features/auth/presentation/pages/recover_password.dart';
import 'package:notepada/features/home/presentation/pages/home.dart';
import 'package:notepada/features/note/data/models/note.dart';
import 'package:notepada/features/note/presentation/pages/edit.dart';
import 'package:notepada/features/note/presentation/pages/view_note.dart';
import 'package:notepada/features/auth/presentation/pages/profile.dart';
import 'package:notepada/features/splash/presentation/pages/splash.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/features/auth/presentation/pages/login.dart';
import 'package:notepada/features/auth/presentation/pages/register.dart';
import 'package:notepada/features/intro/presentation/pages/intro.dart';

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
      path: '/home',
      name: RouteNames.home,
      builder: (context, state) => Home(
        key: UniqueKey(),
      ),
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
  ],
);
