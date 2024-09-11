import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notepada/common/sources/appwrite.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:notepada/features/auth/data/repository/auth.dart';
import 'package:notepada/features/note/data/repository/note.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // SOURCES
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<NoteRepository>(() => NoteRepository());

  // SERVICES
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<AppwriteProvider>(() => AppwriteProvider());
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // REPOSITORY

  // USE CASES
}
