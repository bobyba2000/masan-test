import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_test/common/extension/num_extension.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/model/result/model.dart';

class PointSpectrumWidget extends StatefulWidget {
  final List<ResultModel> results;
  const PointSpectrumWidget({super.key, required this.results});

  @override
  State<PointSpectrumWidget> createState() => _PointSpectrumWidgetState();
}

class _PointSpectrumWidgetState extends State<PointSpectrumWidget> {
  List<QuestionType> types = [
    QuestionType.logical,
    QuestionType.numerical,
    // QuestionType.scenario,
    QuestionType.critical,
    QuestionType.verbal,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Point Spectrum',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CompetencyChartWidget(
                results: widget.results,
                // type: QuestionType.scenario,
                type: QuestionType.critical,
                maxPoint: 4,
              ),
            ),
            40.wSpace,
            Expanded(
              child: CompetencyChartWidget(
                results: widget.results,
                type: QuestionType.verbal,
                maxPoint: 6,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CompetencyChartWidget(
                results: widget.results,
                type: QuestionType.logical,
                maxPoint: 10,
              ),
            ),
            40.wSpace,
            Expanded(
              child: CompetencyChartWidget(
                results: widget.results,
                type: QuestionType.numerical,
                maxPoint: 10,
              ),
            ),
          ],
        ),
        60.hSpace,
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SizedBox(
            width: 1000.w,
            child: CompetencyChartWidget(
              results: widget.results,
              type: null,
              maxPoint: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final int count;

  ChartData({required this.category, required this.count});
}

class CompetencyChartWidget extends StatelessWidget {
  final List<ResultModel> results;
  final QuestionType? type;
  final int maxPoint;
  const CompetencyChartWidget({super.key, required this.results, required this.type, required this.maxPoint});

  @override
  Widget build(BuildContext context) {
    List<int> points = [];
    for (var data in results) {
      int totalPoint = 0;
      for (var answer in data.answers) {
        if (answer.question.type == type || type == null) {
          totalPoint += answer.point;
        }
      }
      points.add(totalPoint);
    }
    List<ChartData> datas = [];
    for (var i = 0; i <= maxPoint; i++) {
      datas.add(
        ChartData(
          category: i.toString(),
          count: points.where((element) => element == i).length,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: SfCartesianChart(
        title: ChartTitle(
          text: type?.name.toUpperCase() ?? 'Overall',
        ),
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          interval: 1,
        ),
        series: [
          ColumnSeries<ChartData, String>(
            dataSource: datas,
            xValueMapper: (datum, index) => datum.category,
            yValueMapper: (data, index) => data.count,
          ),
        ],
      ),
    );
  }
}

// class CompetencyRadarWidget extends StatelessWidget {
//   final List<ResultModel> results;
//   const CompetencyRadarWidget({super.key, required this.results});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       width: 300,
//       child: RadarChart(
//         RadarChartData(
//           dataSets: [
//             RadarDataSet(
//               fillColor: Colors.blue.withOpacity(0.4),
//               borderColor: Colors.blue,
//               entryRadius: 2.0,
//               dataEntries: [
//                 RadarEntry(value: 3),
//                 RadarEntry(value: 4),
//                 RadarEntry(value: 5),
//                 RadarEntry(value: 1),
//                 RadarEntry(value: 4),
//               ],
//             ),
//             RadarDataSet(
//               fillColor: Colors.red.withOpacity(0.4),
//               borderColor: Colors.red,
//               entryRadius: 2.0,
//               dataEntries: [
//                 RadarEntry(value: 2),
//                 RadarEntry(value: 3),
//                 RadarEntry(value: 2),
//                 RadarEntry(value: 5),
//                 RadarEntry(value: 3),
//               ],
//             ),
//           ],
//           radarBackgroundColor: Colors.transparent,
//           radarBorderData: BorderSide(
//             color: Colors.grey.withOpacity(0.5),
//           ),
//           radarShape: RadarShape.circle,
//           titlePositionPercentageOffset: 0.2,
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 14,
//           ),
//           getTitle: (index, angle) {
//             switch (index) {
//               case 0:
//                 return RadarChartTitle(text: 'A', angle: angle);
//               case 1:
//                 return RadarChartTitle(text: 'B', angle: angle);
//               case 2:
//                 return RadarChartTitle(text: 'C', angle: angle);
//               case 3:
//                 return RadarChartTitle(text: 'D', angle: angle);
//               case 4:
//                 return RadarChartTitle(text: 'E', angle: angle);
//             }
//             return RadarChartTitle(text: 'F', angle: angle);
//           },
//         ),
//       ),
//     );
//   }
// }
