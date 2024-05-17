import 'package:finance/features/authentication/view/login_page.dart';
import 'package:finance/features/authentication/view/sign_up_page.dart';
import 'package:finance/features/categories/view/pages/categories_page.dart';
import 'package:finance/features/categories/view/pages/home_page.dart';
import 'package:finance/features/categories/view/pages/new_transaction_page.dart';
import 'package:finance/firebase_stream.dart';

final routes = {
  '/': (context) => FirebaseStream(),
  '/login': (context) => LoginPage(),
  '/signUp': (context) => SignUpScreen(),
  '/home': (context) => HomePage(),
  '/categories': (context) => CategoriesPage(),
  '/newTransaction': (context) => NewTransactionPage(),
};
