import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'package:charts_example/main.dart';

class LineChart extends SceneRoot {
  final List<Venta> lista;

  LineChart(this.lista);
  @override
  void init() {
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
    // final obj = Prueba();
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

class Prueba extends Sprite {
  Prueba() {
    onAddedToStage.addOnce(init);
  }
  final lista = <Sprite>[];
  @override
  void update(double delta) {
    super.update(delta);

    graphics.clear();
    graphics.moveTo(lista.first.x, lista.first.y);
    var temp = Offset(0.0, 0.0);
    for (int i = 1; i < lista.length - 1; i++) {}

    graphics
        .lineStyle(
          2.5,
          Colors.red.value,
        )
        .moveTo(
          lista[0].x,
          lista[0].y,
        )
        .lineTo(
          lista[1].x,
          lista[1].y,
        )
        .lineTo(
          lista[2].x,
          lista[2].y,
        )
        .lineTo(
          lista[3].x,
          lista[3].y,
        )
        .endFill();
  }

  void init() {
    for (int i = 0; i < 4; i++) {
      lista.add(
        _buildDot(i),
      );
    }
  }

  Sprite _buildDot(int index) {
    final shape = Sprite();

    shape.graphics.beginFill(Colors.black.value);
    shape.graphics.drawCircle(0, 0, 20.0).endFill();
    shape.graphics.beginFill(Colors.green.value);

    final text = StaticText(
      text: '$index',
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
    text.alignPivot(Alignment.center);
    shape.addChild(text);
    addChild(shape);
    shape.onMouseDown.add(
      (e) {
        shape.alpha = .5;
        print('onMouseDown  llamado');

        stage.onMouseUp.addOnce(
          (i) {
            print('onMouseUp llamado');
            shape.alpha = 1;
            stage.onMouseMove.removeAll();
          },
        );
        stage.onMouseMove.add(
          (i) {
            print('se va a mover a la x $mouseX y la Y $mouseY');
            shape.x = mouseX;
            shape.y = mouseY;
          },
        );
      },
    );
    final xx = GameUtils.rndRange(0, 100);
    final yy = GameUtils.rndRange(0, 100);
    shape.x = xx;
    shape.y = yy;
    return shape;
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

  final listaSprites = <Shape>[];
  var impreso = false;
  @override
  void update(double delta) {
    // print('corrio el update');
    super.update(delta);
    graphics.clear();

    if (!impreso) {
      impreso = true;
    }
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

    container.addChild(verticalLines);
    container.addChild(horizontalLines);

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

    for (int i = 1; i < lista.length; i++) {
      final tX = (i + 1) * separatorX;

      // verticalLines.graphics.moveTo(tX, 0);
      // verticalLines.graphics.lineTo(tX, h);

      final dot = Shape();
      dot.graphics.beginFill(Colors.red.value, .7);

      dot.graphics
          .drawCircle(
            0.0,
            0.0,
            5.0,
          )
          .endFill();
      // _buildDot();

      container.addChild(dot);

      final percent = 1 - (valor(lista[i]) / maxTotal);

      dot.y = percent * h;
      dot.x = tX;

      if (i == 0) {
        container.graphics.moveTo(dot.x, dot.y);
      } else {
        container.graphics.lineTo(dot.x, dot.y);
      }
      // print('la x del punto es ${dot.x} y su Y es ${dot.y}');
      listaSprites.add(dot);
    }
    addChild(container);
    var temp = Offset(0.0, 0);
    

    for (int i = 1; i < listaSprites.length; i++) {
      final current = Offset(
        listaSprites[i].x,
        listaSprites[i].y,
      );

      final previous = Offset(
        listaSprites[i - 1].x,
        listaSprites[i - 1].y,
      );

      final next = Offset(
        listaSprites[i + 1 < listaSprites.length ? i + 1 : i].x,
        listaSprites[i + 1 < listaSprites.length ? i + 1 : i].y,
      );

      final smoothness = .35;
      final controlPoint1 = previous + temp;

      temp = ((next - previous) / 2) * smoothness;

      final controlPoint2 = current - temp;
      verticalLines.graphics
          .lineStyle(
            4.0,
            Colors.green.value,
          )
          .moveTo(current.dx, current.dy)
          .cubicCurveTo(
            controlPoint1.dx,
            controlPoint1.dy,
            controlPoint2.dx,
            controlPoint2.dy,
            current.dx,
            current.dy,
          )
          .endFill();

      verticalLines.graphics.lineStyle(
        2,
        Colors.black.value,
        .9,
      );
    }
  }

  int round(int n) {
    final a = (n ~/ 10) * 10;
    final b = a + 10;
    final result = (n - a > b - n) ? b : a;
    return result > n ? result : result + 10;
  }

  Shape _buildDot() {
    final shape = Shape();

    shape.graphics.beginFill(Colors.black.value);
    shape.graphics.drawCircle(0, 0, 20.0).endFill();
    addChild(shape);
    shape.onMouseDown.add((e) {
      shape.alpha = .5;
      stage.onMouseUp.addOnce((i) {
        shape.alpha = 1;
      });
    });
    return shape;
  }
}
