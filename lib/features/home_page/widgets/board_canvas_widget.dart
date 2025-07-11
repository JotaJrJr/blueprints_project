import 'package:blueprints_project/features/home_page/widgets/edge_painter_with_arrows.dart';
import 'package:blueprints_project/features/home_page/widgets/grid_painter_widget.dart';
import 'package:flutter/material.dart';

import '../../../common/models/node_model.dart';
import '../../../common/models/edge_model.dart';
import '../../../common/enums/node_type.dart';
import 'draggable_node_widget.dart';

class BoardCanvasWidget extends StatelessWidget {
  final void Function(String nodeId) onNodeTap;

  final List<NodeModel> nodes;
  final List<EdgeModel> edges;

  final NodeType selectedNodeType;
  final Color selectedColor;

  final AddNodeCallback onAddNode;
  final UpdateNodePositionCallback onNodeDrag;
  final UpdateNodeContentCallback onNodeContentChanged;

  final String selectedNodeId;

  static const double canvasSize = 3000;

  const BoardCanvasWidget({
    super.key,
    required this.nodes,
    required this.edges,
    required this.selectedNodeType,
    required this.selectedColor,
    required this.onAddNode,
    required this.onNodeDrag,
    required this.onNodeContentChanged,
    required this.onNodeTap,
    required this.selectedNodeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        onAddNode(details.localPosition, selectedNodeType, selectedColor);
      },
      child: SizedBox(
        width: canvasSize,
        height: canvasSize,
        child: CustomPaint(
          painter: GridPainterWidget(step: 200),
          foregroundPainter: EdgePainterWithArrows(nodes: nodes, edges: edges),
          child: Stack(
            children: [
              for (final node in nodes)
                Positioned(
                  left: node.position.dx,
                  top: node.position.dy,
                  child: GestureDetector(
                    onTap: () {
                      onNodeTap(node.id);
                    },
                    child: DraggableNodeWidget(
                      isSelected: node.id == selectedNodeId,
                      node: node,
                      onDrag: (newPos) => onNodeDrag(node.id, newPos),
                      onTitleChanged: (newTitle) => onNodeContentChanged(node.id, title: newTitle),
                      onFieldsChanged: (newFields) => onNodeContentChanged(node.id, fields: newFields),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef AddNodeCallback = void Function(Offset position, NodeType type, Color color);

typedef UpdateNodePositionCallback = void Function(String nodeId, Offset newPosition);

typedef UpdateNodeContentCallback = void Function(String nodeId, {String? title, List<String>? fields});
