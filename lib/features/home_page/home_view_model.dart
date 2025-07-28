import 'dart:math';
import 'package:flutter/material.dart';
import '../../common/models/edge_model.dart';
import '../../external/class.dart';
import '../../external/ui_node.dart';

class HomeViewModel extends ChangeNotifier {
  final List<UINode> nodes = [];
  final List<EdgeModel> edges = [];
  TipoNode selectedNodeType = TipoNode.textoEstatico;
  Color selectedColor = Colors.lightBlueAccent;
  bool _isConnectingMode = false;
  String? _pendingConnectionStartElement;
  String? _currentSelectedNodeId;

  bool get isConnectingMode => _isConnectingMode;
  String? get currentSelectedNodeId => _currentSelectedNodeId;

  void initializeFromBlueprint(Formulario form) {
    nodes.clear();
    edges.clear();

    // Add form fields as nodes
    for (final node in form.blueprint.nodes) {
      nodes.add(
        UINode(
          position: Offset(Random().nextDouble() * 500, Random().nextDouble() * 500),
          color: Colors.blue,
          node: node,
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
  }

  void handleElementTap(String elementId) {
    if (!_isConnectingMode) return;
    if (_pendingConnectionStartElement == null) {
      _pendingConnectionStartElement == elementId;
    } else {
      addEdge(_pendingConnectionStartElement!, elementId);
      _pendingConnectionStartElement = null;
    }
    notifyListeners();
  }

  void setConnectingMode(bool on) {
    _isConnectingMode = on;
    _pendingConnectionStartElement = null;
    notifyListeners();
  }

  void setSelectedNodeType(TipoNode newType) {
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

  void addNodeAt(Offset position, TipoNode type, Color color) {
    NodeBase nodeBase;
    switch (type) {
      case TipoNode.textoEstatico:
        nodeBase = TextoEstaticoNode(nome: 'New Node', valor: '', elementos: []);
        break;
      case TipoNode.print:
        nodeBase = PrintNode(nome: 'Print');
        break;
      case TipoNode.ifNode:
        nodeBase = IfNode(nome: 'If', condicao: CondicaoIfNode.isEqual);
        break;
      case TipoNode.toLower:
        nodeBase = ToLowerNode();
        break;
      case TipoNode.trim:
        nodeBase = TrimNode(start: true, end: false);
        break;
      case TipoNode.regex:
        nodeBase = RegexNode(regex: '');
        break;
      default:
        nodeBase = TextoEstaticoNode(nome: 'New Node', valor: '', elementos: []);
    }
    final node = UINode(position: position, color: color, node: nodeBase);
    nodes.add(node);
    notifyListeners();
  }

  void updateNodePosition(String nodeId, Offset newPosition) {
    final node = nodes.firstWhere((n) => n.id == nodeId);
    node.position = newPosition;
    notifyListeners();
  }

  void addEdge(String fromElementId, String toElementId) {
    edges.add(EdgeModel(fromNodeId: fromElementId, toNodeId: toElementId));
    notifyListeners();
  }

  void updateNode(String nodeId, {String? title, List<ElementBase>? fields}) {
    final node = nodes.firstWhere((n) => n.id == nodeId);
    if (title != null) {
      node.node.nome = title;
    }
    if (fields != null) {
      node.node.elementos = fields;
    }
    notifyListeners();
  }

  //   void removeNode(String nodeId) {
  //     nodes.removeWhere((n) => n.id == nodeId);
  //     edges.removeWhere(
  //       (e) => nodes.every((n) => n.nodeBase.elementos.every((el) => el.id != e.fromElementId && el.id != e.toElementId)),
  //     );
  //     if (_currentSelectedNodeId == nodeId) {
  //       _currentSelectedNodeId = null;
  //     }
  //     notifyListeners();
  //   }
}
