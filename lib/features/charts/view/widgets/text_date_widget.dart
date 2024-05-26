import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextDateWidget extends StatelessWidget {
  TextDateWidget({super.key});

  int a = 4;

  String text = 'Отображаемый текст';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsBloc, ChartsState>(
      builder: (context, state) {
        return Container(
          child: state.status == ChartsStatus.loading
              ? CircularProgressIndicator()
              : state.getStartDate() == state.getEndDate()
                  ? Text('${state.getStartDate()}')
                  : Text('${state.getStartDate()} - ${state.getStartDate()}'),
          // : Text('aisdsahu $a $text'),
        );
      },
    );
  }
}
