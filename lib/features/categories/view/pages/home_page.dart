import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DatabaseService databaseService = DatabaseService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<DocumentReference> listCategories = [];

  final List<DocumentReference> listSubCategories = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${FirebaseAuth.instance.currentUser?.email}'),
            leading: IconButton(
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.of(context).pushNamed('/categories');
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/categories');
                  },
                  icon: SvgPicture.asset('assets/icons/button.svg')),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: (state.status == CategoriesStatus.initial ||
                  state.status == CategoriesStatus.gettingAllCategories ||
                  state.status == CategoriesStatus.gettingTags)
              ? Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 38),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Баланс',
                                style: theme.textTheme.bodyLarge,
                              ),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              Text(
                                '${state.currentCategory?.balance}',
                                style: theme.textTheme.headlineLarge,
                              ),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              SvgPicture.asset('assets/icons/Rouble.svg'),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.ac_unit,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  getIt<ChartsBloc>().add(
                                      ChartsGetLastMonthTransactionsEvent(
                                          userUid: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          rootCategoryUid:
                                              state.currentCategory!.uid!));
                                  Navigator.of(context).pushNamed(
                                    '/charts',
                                  );
                                },
                                icon: SvgPicture.asset(Globals.chars_icon),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 68,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 68),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Доходы'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  textStyle: theme.textTheme.bodyMedium,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Расходы'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  textStyle: theme.textTheme.bodyMedium,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 1,
                        )),
                        // SizedBox(height: ,),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                            onPressed: () {
                              // getIt<CategoriesBloc>().add(
                              //     CategoriesGetTagsEvent(
                              //         useUid: FirebaseAuth
                              //             .instance.currentUser!.uid));

                              getIt<TagsBloc>().add(TagsGetAllTagsEvent(
                                  userUid:
                                      FirebaseAuth.instance.currentUser!.uid));

                              Navigator.of(context)
                                  .pushNamed('/newTransaction');
                            },
                            child: Text('Добавить'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              textStyle: theme.textTheme.bodyMedium,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 140,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
