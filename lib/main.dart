
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:graphx/graphx.dart';

import 'charts/bar_chart.dart';
import 'charts/pie_chart.dart';

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
              Obx(
                () => controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: Get.height / 2,
                        width: Get.width,
                        child: SceneBuilderWidget(
                          builder: () => SceneController.withLayers(
                            front: PieChart(
                              controller.lista,
                            ),
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
  final lista = <Venta>[].obs;
  final _isLoading = false.obs;
  @override
  void onInit() {
    obtener();
    super.onInit();
  }

  void obtener() async {
    _isLoading.toggle();
    lista.value = Venta.generate();
    _isLoading.toggle();
  }

  bool get isLoading => _isLoading.value;
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
    for (int i = 1; i <= 10; i++) {
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

class Pedido {
  final DateTime date;
  final double total;
  final double iva;
  final String cliente;

  Pedido({
    this.date,
    this.total,
    this.iva,
    this.cliente,
  });
  static List<Pedido> generate() {
    final lista = <Pedido>[];
    final rng = Random();
    for (int i = 1; i <= 20; i++) {
      lista.add(
        Pedido(
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
