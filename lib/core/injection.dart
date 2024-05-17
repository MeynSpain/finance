import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Инстанс [GetIt]
final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Firebase init
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Talker init
  final talker = TalkerFlutter.init();
  getIt.registerSingleton(talker);
  getIt<Talker>().info('Application started...');
  getIt<Talker>()
      .info('Current User: ${FirebaseAuth.instance.currentUser!.uid}');

  // Регистрация блоков
  getIt.registerLazySingleton<CategoriesBloc>(() => CategoriesBloc());

  //Talker bloc logger
  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: true,
      ));

  getIt<CategoriesBloc>().add(
      CategoriesInitialEvent(userUid: FirebaseAuth.instance.currentUser!.uid));
}
