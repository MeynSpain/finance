import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/constants/widgets/list_item_container.dart';
import 'package:finance/features/categories/bloc/categories_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListAccountsWidgets extends StatelessWidget {
  const ListAccountsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.listAccounts.length,
          separatorBuilder: (context, index) {
            // return VerticalDivider();
            return SizedBox();
          },
          itemBuilder: (context, index) {
            return ListItemContainer(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              leftText: state.listAccounts[index].name,
              rightText: '${state.listAccounts[index].balance} руб.',
            );
          },
        );
      },
    );
  }
}
