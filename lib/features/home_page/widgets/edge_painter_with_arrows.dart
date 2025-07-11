import 'package:flutter/material.dart';

import '../../../common/models/edge_model.dart';
import '../../../common/models/node_model.dart';

class EdgePainterWithArrows extends CustomPainter {
  final List<NodeModel> nodes;
  final List<EdgeModel> edges;

  EdgePainterWithArrows({required this.nodes, required this.edges});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2;

    for (final e in edges) {
      final from = nodes.firstWhere((n) => n.id == e.fromNodeId);
      final to = nodes.firstWhere((n) => n.id == e.toNodeId);

      final p1 = from.position + Offset(from.size.width, from.size.height / 2);
      final p2 = to.position + Offset(0, to.size.height / 2);

      canvas.drawLine(p1, p2, paint);

      const arrowSize = 8.0;
      final angle = (p1 - p2).direction;
      final pA = p2 + Offset.fromDirection(angle + 0.4, arrowSize);
      final pB = p2 + Offset.fromDirection(angle - 0.4, arrowSize);
      canvas.drawLine(p2, pA, paint);
      canvas.drawLine(p2, pB, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
