import 'package:charts_example/widgets/line_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:graphx/graphx.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      enableLog: true,
      logWriterCallback: (text, {isError}) => print(text),
      getPages: [
        GetPage(
          name: '/',
          page: () => Home(),
        )
      ],
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (_) => _Home(),
    );
  }
}

class _Home extends GetView<HomeController> {
  const _Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('prueba'),
              const SizedBox(
                height: 36.0,
              ),
              Container(
                height: Get.height / 2,
                width: Get.width,
                child: SceneBuilderWidget(
                  builder: () => SceneController.withLayers(
                    front: ChartNico(
                      Venta.generate(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  @override
  void onInit() {
    obtener();
    super.onInit();
  }

  void obtener() async {
    final lista = Venta.generate();
  }
}

class Venta {
  final DateTime date;
  final double total;
  final double iva;
  final String cliente;

  Venta({
    this.date,
    this.total,
    this.iva,
    this.cliente,
  });
  static List<Venta> generate() {
    final lista = <Venta>[];
    final rng = Random();
    for (int i = 1; i <= 20; i++) {
      lista.add(
        Venta(
          cliente: 'cliente-$i',
          total: rng.nextInt(100).toDouble(),
          iva: rng.nextInt(100).toDouble(),
          date: DateTime.now().subtract(
            Duration(days: 30 * i),
          ),
        ),
      );
    }
    lista.sort((v1, v2) => v1.date.millisecondsSinceEpoch);
    return lista;
  }
}
