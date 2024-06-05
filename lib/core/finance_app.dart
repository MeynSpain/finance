import 'package:finance/core/injection.dart';
import 'package:finance/core/routes/routes.dart';
import 'package:finance/core/theme/theme.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/bar_chart/legend/bloc/bar_legend_bloc.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/charts/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:finance/features/last_transactions/bloc/last_transactions_bloc.dart';
import 'package:finance/features/transfers/bloc/transfers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinanceApp extends StatefulWidget {
  const FinanceApp({super.key});

  @override
  State<FinanceApp> createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CategoriesBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ChartsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TagsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TransactionHistoryBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<BarChartBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<LastTransactionsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<BarLegendBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<TransfersBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance App',
        routes: routes,
        theme: mainTheme,
      ),
    );
  }
}
