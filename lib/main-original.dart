// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:math';

// void main() {
//   runApp(
//     GetMaterialApp(
//       initialRoute: '/',
//       enableLog: true,
//       logWriterCallback: (text, {isError}) => print(text),
//       getPages: [
//         GetPage(
//           name: '/',
//           page: () => Home(),
//         )
//       ],
//     ),
//   );
// }

// class Home extends StatelessWidget {
//   const Home({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//       init: HomeController(),
//       builder: (_) => _Home(),
//     );
//   }
// }

// class _Home extends GetView<HomeController> {
//   const _Home({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//       ),
//       body: Obx(
//         () => Container(
//           margin: const EdgeInsets.all(12.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text('prueba'),
//                 const SizedBox(
//                   height: 36.0,
//                 ),
//                 LineChart(
//                   controller.data.value,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeController extends GetxController {
//   final data = LineChartData().obs;
//   @override
//   void onInit() {
//     obtener();
//     super.onInit();
//   }

//   void obtener() async {
//     final lista = Venta.generate();
//     data.value = LineChartData(
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d), width: 1),
//       ),
//       showingTooltipIndicators: [],
//       lineTouchData: LineTouchData(
//         enabled: true,
//         touchTooltipData: LineTouchTooltipData(
//           getTooltipItems: (List<LineBarSpot> touchedBarSpots) =>
//               touchedBarSpots
//                   .map(
//                     (barSpot) => LineTooltipItem(
//                       lista[barSpot.spotIndex].cliente,
//                       const TextStyle(color: Colors.white),
//                     ),
//                   )
//                   .toList(),
//           tooltipBgColor: Colors.black.withOpacity(0.8),
//         ),
//         touchCallback: (LineTouchResponse touchResponse) {
//           touchResponse.touchInput.getOffset().dx.printInfo();
//         },
//         handleBuiltInTouches: true,
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           spots: lista
//               .map(
//                 (e) => FlSpot(
//                   e.date.millisecondsSinceEpoch.toDouble(),
//                   e.total,
//                 ),
//               )
//               .toList(),
//           isCurved: true,
//           // colors: [
//           //   Colors.green,
//           //   Colors.red,
//           // ],
//           barWidth: 4.5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: true,
//             checkToShowDot: (spot, barData) => true,
//             // getDotPainter:
//           ),
//           lineChartStepData: LineChartStepData(stepDirection: 12.0),
//           // showingIndicators: [1, 2, 3, 4, 5, 6],
//           aboveBarData: BarAreaData(
//             show: true,
//             colors: [
//               Colors.blue.withOpacity(.3),
//             ],
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             colors: [
//               Colors.brown.withOpacity(.3),
//             ],
//           ),
//         ),
//       ],
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         drawHorizontalLine: false,
//         getDrawingHorizontalLine: (value) => FlLine(color: Colors.red),
//         getDrawingVerticalLine: (value) => FlLine(color: Colors.blue),
//         checkToShowHorizontalLine: (value) => value > 0,
//       ),
//       axisTitleData: FlAxisTitleData(
//         bottomTitle: AxisTitle(
//           titleText: 'algo',
//           showTitle: true,
//           reservedSize: 12.0,
//         ),
//         show: true,
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           rotateAngle: 90,
//           getTextStyles: (value) =>
//               TextStyle(color: Colors.black, fontSize: 12.0),
//           getTitles: (value) {
//             final date = DateTime.fromMillisecondsSinceEpoch(
//               value.toInt(),
//             );
//             return '${date.month}-${date.year}';
//           },
//         ),
//         // topTitles: SideTitles(),
//       ),
//     );
//   }
// }

// class Venta {
//   final DateTime date;
//   final double total;
//   final double iva;
//   final String cliente;

//   Venta({
//     this.date,
//     this.total,
//     this.iva,
//     this.cliente,
//   });
//   static List<Venta> generate() {
//     final lista = <Venta>[];
//     final rng = Random();
//     for (int i = 1; i <= 20; i++) {
//       lista.add(
//         Venta(
//           cliente: 'cliente-$i',
//           total: rng.nextInt(100).toDouble(),
//           iva: rng.nextInt(100).toDouble(),
//           date: DateTime.now().subtract(
//             Duration(days: 30 * i),
//           ),
//         ),
//       );
//     }
//     lista.sort((v1, v2) => v1.date.millisecondsSinceEpoch);
//     lista.forEach((element) => element.date.toIso8601String().printInfo());
//     return lista;
//   }
// }
