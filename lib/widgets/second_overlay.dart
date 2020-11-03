import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'package:meta/meta.dart';

class ToolTipOverlay<T> extends Sprite {
  final x;
  final y;
  final T value;
  final String Function(T) texto;
  ToolTipOverlay({
    this.texto,
    this.x,
    this.y,
    this.value,
  });
  @override
  void addedToStage() {
    super.addedToStage();
    init();
  }

  void init() {
    var toolTip = Shape();

    toolTip.graphics
        .lineStyle(0, 0xffffff, .1)
        .beginFill(0x0, .67)
        .drawRoundRect(0, 0, 50, 30, 4)
        .endFill();
    stage.addChild(toolTip);
    var title = StaticText(
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    // title.text = texto(value)??'';
    stage.addChild(title);
  }
}
