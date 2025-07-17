import 'package:blueprints_project/external/class.dart';
import 'package:flutter/material.dart';
import 'package:blueprints_project/features/home_page/widgets/hold_to_delete_button_widget.dart';

import '../../../external/ui_node.dart';

typedef NodeNavigate = void Function(String targetNodeId);
typedef AttributeUpdate = void Function(String title, List<String> fields);

class NodeDetailPanel extends StatelessWidget {
  final UINode? selectedNode;
  final List<UINode> allNodes;
  final NodeNavigate onPrev;
  final NodeNavigate onNext;
  //   final AttributeUpdate onUpdate;

  const NodeDetailPanel({
    super.key,
    required this.selectedNode,
    required this.allNodes,
    required this.onPrev,
    required this.onNext,
    // required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedNode == null) {
      return Container(width: 250, color: Colors.grey.shade50, child: const Center(child: Text('No node selected')));
    }

    // final node = selectedNode!;
    // final index = allNodes.indexWhere((n) => n.id == node.id);
    // final hasPrev = index > 0;
    // final hasNext = index < allNodes.length - 1;

    // final title = node.title;
    // // final fields = List<String>.from(node.node.nome ?? '');
    // final elements = node

    final node = selectedNode!;
    final index = allNodes.indexWhere((n) => n.id == node.id);
    final hasPrev = index > 0;
    final hasNext = index < allNodes.length - 1;

    final title = node.node.nome;
    final fields = node.node.elementos;

    return Container(
      width: 250,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: hasPrev ? () => onPrev(allNodes[index - 1].id) : null,
              ),
              Text('Node ${index + 1}/${allNodes.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: hasNext ? () => onNext(allNodes[index + 1].id) : null,
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: node.color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Untitled' : title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(node.node.tipo.toString().split('.').last, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  key: ValueKey('title-${node.id}-$title'),
                  initialValue: title,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (newTitle) {
                    // onUpdate(newTitle, fields);
                  },
                ),
                const SizedBox(height: 12),

                const Text('Fields', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                for (var i = 0; i < fields.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('field-${node.id}-$i-${fields[i].nome}'),
                            initialValue: fields[i].nome,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Field ${i + 1}',
                            ),
                            onChanged: (newValue) {
                              final newFields = List<String>.from(fields)..[i] = newValue;
                              //   onUpdate(title, newFields);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        HoldToTriggerAction(
                          onActionTrigger: () {
                            final newFields = List<String>.from(fields)..removeAt(i);
                            // onUpdate(title, newFields);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElementBase _updateElementName(ElementBase element, String newName) {
    if (element is Dado) {
      return Dado(id: element.id, nome: newName, direcao: element.direcao, dado: element.dado);
    } else if (element is Event) {
      return Event(id: element.id, nome: newName, direcao: element.direcao);
    }
    return element; // Default case, extend for other ElementBase types as needed
  }
}
