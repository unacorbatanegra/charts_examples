import 'package:charts_example/charts/pie_chart/widgets/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import '../../main.dart';

class PieChart extends SceneRoot {
  final List<Venta> lista;

  PieChart(this.lista);
  @override
  void init() {
    config(
      usePointer: true,
      autoUpdateAndRender: true,
    );
  }

  @override
  void ready() {
    super.ready();

    var obj = _Base<Venta>(
      lista,
      150,
      (e) => e.total,
    );
    addChild(obj);
  }
}

class _Base<T> extends Sprite {
  final List<T> lista;
  final double radiusCircle;
  final double Function(T) valor;
  _Base(
    this.lista,
    this.radiusCircle,
    this.valor,
  ) {
    onAddedToStage.addOnce(init);
  }
  void init() {
    final total = lista.fold<double>(
      0.0,
      (v, element) => v += valor(element),
    );
    final cX = stage.stageWidth / 2;
    final cY = stage.stageHeight / 2;
    // final angleStep = 1 / lista.length * deg2rad(360);
    var currentAngle = 0.0;
    var toolTipPie = ToolTipPie<T>(
      texto: 'prueba',
    );
    toolTipPie.name = 'toolTip';
    addChild(toolTipPie);
    for (int i = 0; i < lista.length; i++) {
      var color = Colors.primaries[i % Colors.primaries.length];
      final percent = valor(lista[i]) / total;
      final angleStep = deg2rad(percent * 360);
      var pie = Pie<T>(
        lista[i],
        cX: cX,
        cY: cY,
        currentAngle: currentAngle,
        originalColor: color,
        angleStep: angleStep,
        radiusCircle: radiusCircle,
        onTap: (e) {
          toolTipPie.x = cX - 20;
          toolTipPie.y = cY - 20;
          toolTipPie.texto = i.toString();
        },
      );
      Get.log(
        'El percent es ${(percent * 100).roundToDouble()}%\n su anglestep es de $angleStep\nel current angle es  $currentAngle',
      );
      currentAngle += angleStep;

      addChild(pie);
    }
    print(currentAngle);
  }
}

class Pie<T> extends Sprite {
  double radiusCircle;
  double currentAngle;
  double angleStep;
  Color originalColor;
  double cX;
  double cY;
  T data;
  void Function(T) onTap;
  double scaleInternal = 1;
  Color color;
  Pie(
    this.data, {
    this.radiusCircle,
    this.currentAngle,
    this.angleStep,
    this.originalColor,
    this.cX,
    this.cY,
    @required this.onTap,
  }) {
    init();
  }

  void draw() {
    graphics.clear();
    graphics
        .beginFill(color.value)
        .moveTo(cX, cY)
        .arc(cX, cY, radiusCircle, currentAngle, angleStep)
        .lineTo(cX, cY)
        .endFill();
  }

  void init() {
    color = originalColor;
    draw();
    onMouseClick.add(
      (_) {
        parent.getChildByName('toolTip').x = cX - 50;
        parent.getChildByName('toolTip').y = cY - 50;
      },
    );

    onMouseDown.add(
      (e) {
        // scaleInternal = 2;
        color = Colors.black;
        draw();
        onMouseUp.addOnce((y) {
          color = originalColor;
          // scaleInternal = 1;
          draw();
        });
      },
    );
  }
}
