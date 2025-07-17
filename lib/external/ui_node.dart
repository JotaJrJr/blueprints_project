import 'package:flutter/material.dart';
import 'package:blueprints_project/external/class.dart';

class UINode {
  final dynamic node; // NodeBase or Input
  Offset position;
  Size size;
  Color color;

  UINode({
    required this.node,
    required this.position,
    this.size = const Size(150, 100),
    this.color = Colors.lightBlueAccent,
  });

  String get id => node.id;
  String get title => node is NodeBase ? (node as NodeBase).nome ?? (node as NodeBase).tipo.name : (node as Input).nome;
  List<ElementBase> get elements => node is NodeBase ? (node as NodeBase).elementos : (node as Input).elements;

  List<ElementBase> get inputs => elements.where((e) => e.direcao == DirecaoElemento.entrada).toList();
  List<ElementBase> get outputs => elements.where((e) => e.direcao == DirecaoElemento.saida).toList();

  Offset getHandlePosition(ElementBase element) {
    final isInput = element.direcao == DirecaoElemento.entrada;
    final handles = isInput ? inputs : outputs;
    final index = handles.indexOf(element);
    if (index == -1) return position;
    final numHandles = handles.length;
    final yStep = size.height / (numHandles + 1);
    final x = isInput ? position.dx : position.dx + size.width;
    final y = position.dy + yStep * (index + 1);
    return Offset(x, y);
  }
}
