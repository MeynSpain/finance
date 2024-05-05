import 'package:finance/core/injection.dart';
import 'package:finance/core/models/user_model.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthenticationService {
  final auth = FirebaseAuth.instance;

  /// Авторизация
  Future<UserCredential> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      getIt<Talker>().error('${e.code} ${e.message}');
      throw FirebaseAuthException(
          code: e.code, message: 'Ошибка в методе login :: (${e.message})');
    }
  }

  /// Регистрация
  Future<UserCredential> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      getIt<Talker>().error('${e.code} ${e.message}');
      throw FirebaseAuthException(
          code: e.code, message: 'Ошибка в методе signUp :: (${e.message})');
    }
  }
}

// class AuthenticationService {
//   FirebaseAuth auth = FirebaseAuth.instance;
//
//   Stream<UserModel> retrieveCurrentUser() {
//     return auth.authStateChanges().map((User? user) {
//       if (user != null) {
//         return UserModel(uid: user.uid, email: user.email);
//       } else {
//         return UserModel(uid: 'uid');
//       }
//     });
//   }
//
//   Future<UserCredential?> signUp(UserModel user) async {
//     try{
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
//
//       await verifyEmail();
//
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthException(code: e.code, message: e.message);
//     }
//   }
//
//   Future<UserCredential?> signIn(UserModel user) async {
//     try{
//       UserCredential userCredential = await auth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
//
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthException(code: e.code, message: e.message);
//     }
//   }
//
//   Future<void> signOut() async {
//     return await auth.signOut();
//   }
//
//   Future<void> verifyEmail() async {
//     User? user = auth.currentUser;
//
//     if (user != null && !user.emailVerified) {
//       return await user.sendEmailVerification();
//     }
//   }
// }
