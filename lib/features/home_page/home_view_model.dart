import 'dart:math';

import 'package:flutter/material.dart';

import '../../common/enums/node_type.dart';
import '../../common/models/edge_model.dart';
import '../../common/models/node_model.dart';
import '../../external/class.dart';

class HomeViewModel extends ChangeNotifier {
  final List<NodeModel> nodes = [];
  final List<EdgeModel> edges = [];
  final Input input;
  HomeViewModel({required this.input});

  NodeType selectedNodeType = NodeType.entity;
  Color selectedColor = Colors.lightBlueAccent;

  bool _isConnectingMode = false;

  String? _pendingConnectionStart;

  String? _currentSelectedNodeId;

  bool get isConnectingMode => _isConnectingMode;
  String? get currentSelectedNodeId => _currentSelectedNodeId;

  NodeType _convertNodeType(TipoNode tipo) {
    switch (tipo) {
      case TipoNode.toLower:
        return NodeType.entity;
      case TipoNode.trim:
        return NodeType.entity;
      case TipoNode.regex:
        return NodeType.interface;
      case TipoNode.textoEstatico:
        return NodeType.abstractClass;
      case TipoNode.print:
        return NodeType.interface;
      case TipoNode.ifNode:
        return NodeType.abstractClass;
      default:
        return NodeType.entity;
    }
  }

  Future<void> init() async {
    if (input == null) return;

    nodes.clear();
    edges.clear();

    nodes.add(
      NodeModel(
        id: input.id,
        title: input.nome,
        type: NodeType.entity,
        fields: input.elements.map((e) => e.nome).toList(),
        position: Offset(Random().nextDouble() * 500, Random().nextDouble() * 500),
        color: Colors.blue,
      ),
    );

    for (final node in input.blueprint.nodes) {
      nodes.add(
        NodeModel(
          id: node.id,
          title: node.nome ?? node.tipo.name,
          type: _convertNodeType(node.tipo),
          position: Offset(Random().nextDouble() * 500, Random().nextDouble() * 500),
          color: Colors.green,
        ),
      );
    }

    for (final conexao in input.blueprint.conexoes) {
      edges.add(EdgeModel(fromNodeId: conexao.origem, toNodeId: conexao.destino));
    }

    notifyListeners();
  }

  void handleNodeTap(String nodeId) {
    if (!_isConnectingMode) {
      selectNode(nodeId);
      return;
    }

    if (_pendingConnectionStart == null) {
      _pendingConnectionStart = nodeId;
    } else {
      addEdge(_pendingConnectionStart!, nodeId);
      _pendingConnectionStart = null;
    }
    notifyListeners();
  }

  void setConnectingMode(bool on) {
    _isConnectingMode = on;
    _pendingConnectionStart = null;
    notifyListeners();
  }

  void setSelectedNodeType(NodeType newType) {
    selectedNodeType = newType;
    notifyListeners();
  }

  void setSelectedColor(Color newColor) {
    selectedColor = newColor;
    notifyListeners();
  }

  void selectNode(String nodeId) {
    _currentSelectedNodeId = nodeId;
    notifyListeners();
  }

  void deselectNode() {
    _currentSelectedNodeId = null;
    notifyListeners();
  }

  void addNodeAt(Offset position, NodeType type, Color color) {
    final node = NodeModel(id: UniqueKey().toString(), position: position, type: type, color: color);
    nodes.add(node);
    notifyListeners();
  }

  void addEdge(String fromNodeId, String toNodeId) {
    edges.add(EdgeModel(fromNodeId: fromNodeId, toNodeId: toNodeId));
    notifyListeners();
  }

  void updateNodePosition(String nodeId, Offset newPosition) {
    final node = nodes.firstWhere((n) => n.id == nodeId);
    node.position = newPosition;
    notifyListeners();
  }

  void updateNode(String nodeId, {String? title, List<String>? fields}) {
    final node = nodes.firstWhere((n) => n.id == nodeId);
    if (title != null) node.title = title;
    if (fields != null) node.fields = fields;
    notifyListeners();
  }

  void removeNode(String nodeId) {
    nodes.removeWhere((n) => n.id == nodeId);
    edges.removeWhere((e) => e.fromNodeId == nodeId || e.toNodeId == nodeId);
    if (_currentSelectedNodeId == nodeId) {
      _currentSelectedNodeId = null;
    }
    notifyListeners();
  }

  void removeEdge(String edgeId) {
    edges.removeWhere((e) => e.fromNodeId == edgeId || e.toNodeId == edgeId);
    notifyListeners();
  }
}
