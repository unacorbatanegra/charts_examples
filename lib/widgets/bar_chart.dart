import 'dart:ffi';

import 'package:charts_example/widgets/tooltip_overlay.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'package:graphx/graphx.dart';
import '../main.dart';

class BarChart extends SceneRoot {
  final List<Venta> lista;

  BarChart(this.lista);
  @override
  void init() {
    // owner.core.config.useTicker = true;
    // owner.core.config.usePointer = true;
    config(
      autoUpdateAndRender: true,
      usePointer: true,
    );
  }

  @override
  void ready() {
    super.ready();

    var obj = _Base<Venta>(
      lista,
      (e) => e.total,
    );
    addChild(obj);
    // obj.alignPivot(Alignment.bottomCenter);
    // obj.x = obj.pivotX;
    // obj.y = obj.pivotY;

    // var pic = obj.createPicture();
    // final shape1 = Shape();
    // addChild(shape1);
    // shape1.graphics.drawPicture(pic);
    // // obj.createImage().then((value) {
    // // });
    // obj.visible = false;
    // obj.removeFromParent(true);
    // double counterScale = 0;
    // stage.onEnterFrame.add(() {
    //   counterScale += .01;
    //   obj.rotation = sin(counterScale) * pi;
    // });
  }
}

class _Base<T> extends Sprite {
  final List<T> lista;
  final double Function(T) valor;

  double h;
  double w;
  _Base(this.lista, this.valor) {
    onAddedToStage.addOnce(init);
  }

  void init() {
    final maxTotalData = lista.fold<double>(
      0.0,
      (v, element) {
        if (v < valor(element)) v = valor(element);
        return v;
      },
    );
    final maxTotal = round(maxTotalData.toInt());

    final padding = 40.0;
    w = stage.stageWidth - (padding * 2);
    h = stage.stageHeight - (padding * 2);
    final verticalLines = Shape();
    final horizontalLines = Shape();
    final container = Sprite();

    final overlayContainer = Sprite();

    addChild(overlayContainer);

    var toolTip = ToolTipOverlay<T>(
      texto: (e) => '',
    );
    toolTip.name = 'toolTip';

    container.addChild(verticalLines);
    container.addChild(horizontalLines);
    container.addChild(toolTip);
    container.x = 40;
    container.y = 40;

    verticalLines.graphics.lineStyle(
      5.0,
      Colors.blueGrey.value,
    );

    final separatorX = w / lista.length;
    final separatorY = h / 4;

    verticalLines.graphics.moveTo(0.0, 0.0);
    verticalLines.graphics.lineTo(0.0, h);

    verticalLines.graphics.lineTo(w, h);
    verticalLines.graphics.lineStyle(
      1,
      Colors.blueGrey.value,
      .5,
    );
    horizontalLines.graphics.lineStyle(
      1,
      Colors.blueGrey.value,
      .5,
    );
    final divisions = maxTotal / 4;
    for (int i = 0; i < 5; i++) {
      final tY = i * separatorY;
      horizontalLines.graphics.moveTo(0, tY);
      horizontalLines.graphics.lineTo(w, tY);

      final myAxisText = StaticText();

      myAxisText.text = (maxTotal - (divisions * i)).toString();
      print(tY);
      myAxisText.y = tY - 10;
      myAxisText.x = -40;
      container.addChild(myAxisText);
    }

    final bars = <Bar>[];
    for (int i = 0; i < lista.length; i++) {
      final tX = (i + 1) * separatorX;
      //linea vertical

      verticalLines.graphics.moveTo(tX, 0);
      verticalLines.graphics.lineTo(tX, h);
      final percent = 1 - (valor(lista[i]) / maxTotal);

      final currentY = percent * h;
      final currentX = tX;
      final width = 15 / 2;
      var bar = Bar(
        width,
        currentY,
        () {},
        (e) => '',
      );

      bar.y = h;
      bar.x = currentX - 30;
      bars.add(bar);
      bar.scaleY = 0;
      bar.tween(
        duration: 1,
        scaleY: 1,
        x: '30',
        ease: GEase.linear,
        delay: 1 + i * .1,
      );

      container.addChild(bars[i]);
    }
    addChild(container);
  }

  int round(int n) {
    final a = (n ~/ 10) * 10;
    final b = a + 10;
    final result = (n - a > b - n) ? b : a;
    return result > n ? result : result + 10;
  }
}

class ModelCoordinate<T> {
  T data;
  double x;
  double y;
  double radio;
  ModelCoordinate({
    this.data,
    this.x,
    this.y,
    this.radio,
  });
}

class Bar<T> extends Sprite {
  String texto;
  final double w;
  final double h;
  Color color;
  T data;
  VoidCallback onTap;
  String Function(T) fromString;
  Bar(
    this.w,
    this.h,
    this.onTap,
    this.data,
  ) {
    color = Colors.yellow;
    init();
  }
  void draw() {
    graphics.clear();
    graphics.beginFill(
      color.value,
    );
    graphics
        .drawRect(
          0,
          0,
          w,
          h,
        )
        .endFill();
    alignPivot(Alignment.bottomCenter);
  }

  void init() {
    draw();
    onMouseClick.add((_) => onTap());
    onMouseDown.add((e) {
      color = Colors.red;
      draw();
      onMouseOut.addOnce((y) {
        color = Colors.yellow;
        draw();
      });
    });
  }
}
