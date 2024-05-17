import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/services/authentication_service.dart';
import 'package:finance/core/services/snack_bar_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();

  // final formKey = GlobalKey<FormState>();

  final AuthenticationService authenticationService = AuthenticationService();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void tooglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);

    // final isValid = formKey.currentState!.validate();

    // if (!isValid) {
    //   print('###### NOT VALID ######');
    // }

    try {
      String email = emailTextInputController.text.trim();
      String password = passwordTextInputController.text.trim();

      if (email != '' && password != '') {
        UserCredential userCredential =
            await authenticationService.login(email: email, password: password);

        getIt<Talker>().info(userCredential.user.toString());

        getIt<Talker>().info(
            'Current user after login: ${FirebaseAuth.instance.currentUser!.uid}');

        getIt<CategoriesBloc>().add(CategoriesInitialEvent(
            userUid: FirebaseAuth.instance.currentUser!.uid));

        navigator.pushNamedAndRemoveUntil('/home', (route) => false);
      }

      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: emailTextInputController.text.trim(),
      //   password: passwordTextInputController.text.trim(),
      // );

      // print('Здесь проходит?');
      // print(FirebaseAuth.instance.currentUser);
      // final user = FirebaseAuth.instance.currentUser;

      // CollectionReference users = FirebaseFirestore.instance.collection('users');
      //
      // users.doc(user?.uid).set({
      //   'username': user?.displayName,
      //   'email': user?.email,
      //   'id': user?.uid,
      // });
    } on FirebaseAuthException catch (exception) {
      print(exception.code);

      if (exception.code == 'user-not-found' ||
          exception.code == 'wrong-password') {
        SnackBarService.showSnackBar(
            context, 'Неправильный email или пароль', true);

        return;
      } else {
        SnackBarService.showSnackBar(
            context, 'Неизвестная ошибка:${exception}', true);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Войти'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          // key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailTextInputController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Password',
                    suffix: InkWell(
                      onTap: tooglePasswordView,
                      child: Icon(
                        isHiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: login,
                child: const Text('Войти'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/'
                    'signUp'),
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
