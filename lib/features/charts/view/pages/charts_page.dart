import 'package:finance/core/constants/status/charts_status.dart';
import 'package:finance/features/charts/bloc/charts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  Map<String, double> dataMap = {
    'A': 5,
    'B': 22,
    'C': 10,
    'D': 12,
    'D1': 12,
    'D2': 12,
    'D3': 12,
    'D4': 12,
    'D5': 12,
    'D6': 12,
  };

  List<Color> colorList = [];

  @override
  void initState() {
    colorList = generateColors(dataMap.length);
    print(colorList);
    super.initState();
  }

  List<Color> generateColors(int count) {
    List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      double t = i / (count - 1);
      colors.add(Color.lerp(Colors.black, Colors.grey[300], t)!);
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: Center(
        child: BlocBuilder<ChartsBloc, ChartsState>(
          builder: (context, state) {
            if (state.status == ChartsStatus.loading) {
              return CircularProgressIndicator();
            } else {
              // colorList = generateColors(state.dataMap.length);
              return PieChart(
                dataMap: state.dataMap,
                chartType: ChartType.ring,
                legendOptions: LegendOptions(
                  legendPosition: LegendPosition.bottom,
                ),
                // colorList: colorList,
              );
            }
          },
        ),
      ),
    );
  }
}
