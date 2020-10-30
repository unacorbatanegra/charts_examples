import 'package:charts_example/widgets/tooltip_overlay.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'package:charts_example/main.dart';
import 'package:get/get.dart';

class BarChart extends RootScene {
  final List<Venta> lista;

  BarChart(this.lista);
  @override
  void init() {
    owner.core.config.useTicker = true;
  }

  @override
  void ready() {
    super.ready();
    owner.needsRepaint = true;
    stage.scene.core.resumeTicker();
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
    container.addChild(verticalLines);
    container.addChild(horizontalLines);

    container.x = 40;
    container.y = 40;

    // stage.onEnterFrame.add(
    //   () {
    //     print('algo ${DateTime.now().toIso8601String()}');
    //   },
    // );

    stage?.onClick?.add(
      (e) {
        print('asdasda');
        e.localX.printInfo();
        e.localY.printInfo();
      },
    );
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

    for (int i = 0; i < lista.length; i++) {
      final tX = (i + 1) * separatorX;
      //linea vertical

      verticalLines.graphics.moveTo(tX, 0);
      verticalLines.graphics.lineTo(tX, h);
      final percent = 1 - (valor(lista[i]) / maxTotal);

      final bar = Shape();
      bar.graphics.beginFill(
        Colors.yellow.value,
      );

      final currentY = percent * h;
      final currentX = tX;
      final width = 15 / 2;
      bar.graphics.moveTo(currentX - width, currentY);
      bar.graphics.lineTo(
        currentX + width,
        currentY,
      );
      // bar.stage.$onEnterFrame.add(() => print('entro a un bar'));
      bar.graphics.lineTo(
        currentX + width,
        h - 2.5,
      );
      bar.graphics.lineTo(
        currentX - width,
        h - 2.5,
      );
      bar.graphics.lineTo(
        currentX - width,
        currentY,
      );
      bar.graphics.closePolygon().endFill();
      container.addChild(bar);
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
