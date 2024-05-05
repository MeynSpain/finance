import 'package:finance/core/routes/routes.dart';
import 'package:finance/features/authentication/bloc/authentication_bloc.dart';
import 'package:finance/features/authentication/view/login_page.dart';
import 'package:finance/features/home_page.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      routes: routes,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}


