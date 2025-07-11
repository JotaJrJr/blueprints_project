import 'package:blueprints_project/features/home_page/widgets/hold_to_delete_button_widget.dart';
import 'package:flutter/material.dart';
import '../../../common/models/node_model.dart';

typedef NodeNavigate = void Function(String targetNodeId);
typedef AttributeUpdate = void Function(String title, List<String> fields);

class NodeDetailPanel extends StatefulWidget {
  final NodeModel? selectedNode;
  final List<NodeModel> allNodes;
  final NodeNavigate onPrev;
  final NodeNavigate onNext;
  final AttributeUpdate onUpdate;

  const NodeDetailPanel({
    super.key,
    required this.selectedNode,
    required this.allNodes,
    required this.onPrev,
    required this.onNext,
    required this.onUpdate,
  });

  @override
  State<NodeDetailPanel> createState() => _NodeDetailPanelState();
}

class _NodeDetailPanelState extends State<NodeDetailPanel> {
  late TextEditingController _titleController;
  late List<TextEditingController> _fieldControllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant NodeDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedNode != oldWidget.selectedNode) {
      _disposeControllers();
      _initControllers();
    }
  }

  void _initControllers() {
    final node = widget.selectedNode;
    _titleController = TextEditingController(text: node?.title ?? '')..addListener(_onTitleChanged);

    _fieldControllers = (node?.fields ?? []).map((f) => TextEditingController(text: f)).toList();
    for (var c in _fieldControllers) {
      c.addListener(_onFieldsChanged);
    }
  }

  void _disposeControllers() {
    _titleController.dispose();
    for (var c in _fieldControllers) {
      c.dispose();
    }
  }

  void _onTitleChanged() {
    widget.onUpdate(_titleController.text, _fieldControllers.map((c) => c.text).toList());
  }

  void _onFieldsChanged() {
    widget.onUpdate(_titleController.text, _fieldControllers.map((c) => c.text).toList());
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.selectedNode;
    if (node == null) {
      return Container(width: 250, color: Colors.grey.shade50, child: const Center(child: Text('No node selected')));
    }

    final index = widget.allNodes.indexWhere((n) => n.id == node.id);
    final hasPrev = index > 0;
    final hasNext = index < widget.allNodes.length - 1;

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
                onPressed: hasPrev ? () => widget.onPrev(widget.allNodes[index - 1].id) : null,
              ),
              Text('Node ${index + 1}/${widget.allNodes.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: hasNext ? () => widget.onNext(widget.allNodes[index + 1].id) : null,
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
                  node.title.isEmpty ? 'Node' : node.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(node.type.toString().split('.').last, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  const Text('Fields', style: TextStyle(fontWeight: FontWeight.bold)),
                  for (var i = 0; i < _fieldControllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fieldControllers[i],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Field ${i + 1}',
                              ),
                              onChanged: (_) => _onFieldsChanged(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          HoldToDeleteButtonWidget(
                            onDelete: () {
                              setState(() {
                                _fieldControllers.removeAt(i);
                              });
                              _onFieldsChanged();
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
