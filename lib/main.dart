import 'package:flutter_quill/translations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notepada/common/bloc/dash/dash_cubit.dart';
import 'package:notepada/common/bloc/input/input_pin_cubit.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';
import 'package:notepada/common/bloc/theme/theme_cubit.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/theme.dart';
import 'package:notepada/core/routes/routes.dart';
import 'package:notepada/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/login_cubit.dart';
import 'package:notepada/features/auth/presentation/bloc/register_cubit.dart';
import 'package:notepada/features/note/presentation/bloc/note_cubit.dart';
import 'package:notepada/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:notepada/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform
  // );

  await GetStorage.init();
  await initializeDependencies();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => NoteCubit()),
        BlocProvider(create: (_) => NoteListFontCubit()),
        BlocProvider(create: (_) => NoteViewFontCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => VoicePitchCubit()),
        BlocProvider(create: (_) => VoiceRateCubit()),
        BlocProvider(create: (_) => VoiceVolumeCubit()),
        BlocProvider(create: (_) => SelectedIndexCubit()),
        BlocProvider(create: (_) => InputPinCubit()),
        BlocProvider(create: (_) => DashboardAppsCubit()),
        BlocProvider(create: (_) => DashPagesCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: FlutterQuillLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          routerConfig: router,
        ),
      ),
    );
  }
}
