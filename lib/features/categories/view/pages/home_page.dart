import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:finance/features/bar_chart/bloc/bar_chart_bloc.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:finance/features/categories/tags/bloc/tags_bloc.dart';
import 'package:finance/features/categories/view/dialogs/select_current_account_dialog.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:finance/features/last_transactions/view/last_transactions_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DatabaseService databaseService = DatabaseService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final List<DocumentReference> listCategories = [];

  final List<DocumentReference> listSubCategories = [];

  String _selected = '1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${FirebaseAuth.instance.currentUser?.email}'),
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/button.svg'),
              onPressed: () {
                Navigator.of(context).pushNamed('/accounts');
              },
            ),
            actions: [
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 38),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      SelectCurrentAccountDialog());
                            },
                            child: RichText(
                              text: TextSpan(
                                  style: theme.textTheme.bodyLarge,
                                  children: [
                                    TextSpan(
                                      text: state.currentAccount?.name ??
                                          'Баланс',
                                    ),
                                    WidgetSpan(
                                        child: Icon(Icons.arrow_drop_down))
                                  ]),
                            ),
                          ),
                          Text(
                            '${state.currentAccount?.balance}',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              getIt<BarChartBloc>().add(BarChartInitialEvent(
                                userUid: FirebaseAuth.instance.currentUser!.uid,
                                accountUid: getIt<CategoriesBloc>()
                                    .state
                                    .currentAccount!
                                    .uid!,
                              ));
                              Navigator.of(context).pushNamed('/barChart');
                            },
                            icon: Image.asset('assets/icons/bar_charts.png'),
                          ),
                          IconButton(
                            onPressed: () {
                              getIt<ChartsBloc>().add(
                                  ChartsGetLastMonthTransactionsEvent(
                                      userUid: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      accountUid: state.currentAccount!.uid!));
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        // color: Colors.red,
                        child: LastTransactionsWidget(),
                      ),
                    ),
                    // SizedBox(height: 10,),
                    // Expanded(
                    //     child: SizedBox(
                    //       height: 1,
                    //     )),
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
                              userUid: FirebaseAuth.instance.currentUser!.uid));

                          Navigator.of(context).pushNamed('/newTransaction');
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
        );
      },
    );
  }
}
