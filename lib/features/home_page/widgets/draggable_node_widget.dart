import 'package:blueprints_project/features/home_page/widgets/hold_to_delete_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:blueprints_project/external/class.dart';

import '../../../external/ui_node.dart';

class DraggableNodeWidget extends StatelessWidget {
  final UINode node;
  final ValueChanged<Offset> onDrag;
  final void Function(String elementId) onElementTap;
  final bool isSelected;

  const DraggableNodeWidget({
    super.key,
    required this.node,
    required this.onDrag,
    required this.onElementTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = node.color.withOpacity(isSelected ? 1 : 0.3);
    final borderWidth = isSelected ? 3.0 : 1.0;
    // final nodeBase = node.node is NodeBase ? node.node as NodeBase : null;
    // final fieldType = node.node is CampoBase ? (node.node as CampoBase).fieldType.name : null;

    List<String> tipoConexoes = TipoNode.values.map((e) => e.name).toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) => onDrag(node.position + details.delta),
      child: Container(
        width: node.size.width,
        // height: node.size.height,
        decoration: BoxDecoration(
          color: node.color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))] : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(node.title, style: TextStyle(fontWeight: FontWeight.bold)),
                Divider(height: 16, thickness: 1),
                if (node.outputs.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text('Outputs:', style: TextStyle(fontSize: 12)),
                  for (var output in node.outputs)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Conexão de entrada (se precisar)
                        PopupMenuButton<String>(
                          icon: Icon(Icons.radio_button_unchecked),
                          onSelected: (choice) {},
                          itemBuilder:
                              (_) => [
                                PopupMenuItem(value: 'connect', child: Text('Conectar')),
                                PopupMenuItem(value: 'delete', child: Text('Excluir')),
                              ],
                        ),

                        Text(output.nome),

                        PopupMenuButton<String>(
                          icon: Icon(Icons.radio_button_unchecked),
                          onSelected: (choice) => onElementTap(choice),
                          itemBuilder: (_) {
                            return TipoNode.values
                                .map((e) => PopupMenuItem<String>(value: e.name, child: Text(e.name)))
                                .toList()
                              ..add(PopupMenuItem<String>(value: 'delete', child: Text("Deletar")));
                          },
                        ),
                      ],
                    ),

                  //   for (var output in node.outputs)
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         // HoldToTriggerAction(onActionTrigger: () {}),
                  //         IconButton(onPressed: () {}, icon: Icon(Icons.radio_button_checked)),
                  //         Text(output.nome),
                  //         IconButton(onPressed: () {}, icon: Icon(Icons.radio_button_checked)),

                  //         // HoldToTriggerAction(onActionTrigger: () {}),
                  //       ],
                  //     ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateHandleY(int numHandles, int index) {
    final step = numHandles > 0 ? node.size.height / (numHandles + 1) : node.size.height / 2;
    return step * (index + 1);
  }
}
