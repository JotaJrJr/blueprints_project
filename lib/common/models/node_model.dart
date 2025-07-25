import 'package:flutter/material.dart';
import '../enums/node_type.dart';

class NodeModel {
  final String id;
  Offset position;
  Size size;
  NodeType type;
  String title;
  List<String> fields;
  Color color;
  Map<String, dynamic>? config; // Store node-specific configuration
  List<String> inputs = []; // Input handles
  List<String> outputs = [];

  NodeModel({
    required this.id,
    required this.position,
    this.size = const Size(150, 100),
    this.type = NodeType.entity,
    this.title = '',
    this.fields = const [],
    this.color = Colors.lightBlueAccent,
    this.config,
    this.inputs = const [],
    this.outputs = const [],
  });
}
