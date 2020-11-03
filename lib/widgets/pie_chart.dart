import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../main.dart';

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

  // double h;
  // double w;
  _Base(
    this.lista,
    this.radiusCircle,
    this.valor,
  ) {
    onAddedToStage.addOnce(init);
  }
  void init() {
    final circle = Shape();
    final parte = Shape();
    final cX = stage.stageWidth / 2;
    final cY = stage.stageHeight / 2;
    circle.graphics.beginFill(Colors.black.value, .8);
    circle.graphics
        .drawCircle(
          cX,
          cY,
          radiusCircle,
        )
        .endFill();
    addChild(circle);
    // parte.graphics.mask.arc(cx, cy, radius, startAngle, sweepAngle)
    for (int i = 0; i < lista.length; i++) {
      parte.graphics.moveTo(cX, cY);
    }
  }

  int round(int n) {
    final a = (n ~/ 10) * 10;
    final b = a + 10;
    final result = (n - a > b - n) ? b : a;
    return result > n ? result : result + 10;
  }
}
