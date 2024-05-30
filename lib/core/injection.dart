import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/legend/bloc/bar_legend_bloc.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/charts/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:finance/features/last_transactions/bloc/last_transactions_bloc.dart';
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

  // Регистрация блоков
  getIt.registerLazySingleton<CategoriesBloc>(() => CategoriesBloc());
  getIt.registerLazySingleton<ChartsBloc>(() => ChartsBloc());
  getIt.registerLazySingleton<TagsBloc>(() => TagsBloc());
  getIt.registerLazySingleton<TransactionHistoryBloc>(
      () => TransactionHistoryBloc());
  getIt.registerLazySingleton<BarChartBloc>(() => BarChartBloc());
  getIt.registerLazySingleton<LastTransactionsBloc>(
      () => LastTransactionsBloc());
  getIt.registerLazySingleton<BarLegendBloc>(() => BarLegendBloc());

  //Talker bloc logger
  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: true,
      ));

  if (FirebaseAuth.instance.currentUser != null) {
    getIt<Talker>()
        .info('Current User: ${FirebaseAuth.instance.currentUser!.uid}');

    getIt<CategoriesBloc>().add(CategoriesInitialEvent(
        userUid: FirebaseAuth.instance.currentUser!.uid));

    getIt<TagsBloc>().add(
        TagsGetAllTagsEvent(userUid: FirebaseAuth.instance.currentUser!.uid));
  }
}
