import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import '../../main.dart';
import 'widgets/tooltip.dart';

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
    obj.setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
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
    // $debugBounds = true;
    // final cX = stage.stageWidth / 2;
    // final cY = stage.stageHeight / 2;
    // final container = Sprite();
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
        currentAngle: currentAngle,
        originalColor: color,
        angleStep: angleStep,
        radiusCircle: radiusCircle,
        onTap: (e) {
          // toolTipPie.x = cX - 20;
          // toolTipPie.y = cY - 20;
          toolTipPie.texto = i.toString();
        },
      );
      pie.x = 0;
      pie.y = 0;
      pie.scaleX = -1;
      pie.scaleY = -1;
      pie.rotation = -2;
      pie.alpha = 0;
      
      pie.tween(
        alpha: 1,
        duration: 1,
        scaleX: 1,
        scaleY: 1,
        // colorize: Colors.primaries[i % Colors.primaries.length],
        rotation: 0,
        ease: GEase.defaultEasing,
        delay: .5 + i * .1,
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

  T data;
  void Function(T) onTap;
  // double scaleInternal = 1;
  Color color;
  Pie(
    this.data, {
    this.radiusCircle,
    this.currentAngle,
    this.angleStep,
    this.originalColor,
    @required this.onTap,
  }) {
    init();
  }

  void draw() {
    graphics.clear();
    graphics
        .beginFill(color.value)
        .moveTo(0.0, 0.0)
        .arc(0, 0, radiusCircle, currentAngle, angleStep)
        .lineTo(0, 0)
        .endFill();
  }

  void init() {
    color = originalColor;
    draw();
    onMouseClick.add(
      (_) {},
    );

    onMouseDown.add(
      (e) {
        print(
          deg2rad(angleStep),
        );
        scale = 1.1;
        // draw();
        onMouseUp.addOnce((y) {
          scale = 1;
          // draw();
        });
      },
    );
  }
}
