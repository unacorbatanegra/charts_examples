import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ToolTipPie<T> extends Sprite {
  final T value;
  String texto;
  final Function(T) onTap;
  ToolTipPie({
    this.value,
    this.texto,
     this.onTap,
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
    addChild(toolTip);
    var title = StaticText(
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    title.text = texto;

    addChild(title);
  }
}
