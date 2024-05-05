import 'package:finance/core/finance_app.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const FinanceApp());
}
