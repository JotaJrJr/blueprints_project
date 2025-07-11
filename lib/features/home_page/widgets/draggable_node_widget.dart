import 'package:flutter/material.dart';
import '../../../common/enums/node_type.dart';
import '../../../common/models/node_model.dart';
import 'hold_to_delete_button_widget.dart';

class DraggableNodeWidget extends StatefulWidget {
  final NodeModel node;
  final ValueChanged<Offset> onDrag;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<List<String>> onFieldsChanged;
  final bool isSelected;

  const DraggableNodeWidget({
    super.key,
    required this.node,
    required this.onDrag,
    required this.onTitleChanged,
    required this.onFieldsChanged,
    required this.isSelected,
  });

  @override
  State<DraggableNodeWidget> createState() => _DraggableNodeWidgetState();
}

class _DraggableNodeWidgetState extends State<DraggableNodeWidget> {
  late Offset _offset;
  late TextEditingController _titleController;
  late List<TextEditingController> _fieldControllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant DraggableNodeWidget old) {
    super.didUpdateWidget(old);

    final oldNode = old.node;
    final newNode = widget.node;

    if (oldNode.id != newNode.id) {
      _disposeControllers();
      _initControllers();
      return;
    }

    if (oldNode.fields.length != newNode.fields.length) {
      _disposeControllers();
      _initControllers();
      return;
    }

    for (var i = 0; i < newNode.fields.length; i++) {
      final desired = newNode.fields[i];
      final ctrl = _fieldControllers[i];
      if (ctrl.text != desired) {
        final oldPos = ctrl.selection;
        ctrl.text = desired;
        ctrl.selection = oldPos;
      }
    }

    if (_titleController.text != newNode.title) {
      final oldPos = _titleController.selection;
      _titleController.text = newNode.title;
      _titleController.selection = oldPos;
    }
  }

  void _initControllers() {
    _offset = widget.node.position;
    _titleController = TextEditingController(text: widget.node.title)
      ..addListener(() => widget.onTitleChanged(_titleController.text));
    _fieldControllers =
        widget.node.fields.map((text) => TextEditingController(text: text)..addListener(_notifyFields)).toList();
  }

  void _notifyFields() {
    widget.onFieldsChanged(_fieldControllers.map((c) => c.text).toList());
  }

  void _disposeControllers() {
    _titleController.dispose();
    for (var ctrl in _fieldControllers) ctrl.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _addField() {
    setState(() {
      _fieldControllers.add(TextEditingController(text: '')..addListener(_notifyFields));
    });
    _notifyFields();
  }

  void _removeField(int index) {
    if (index < 0 || index >= _fieldControllers.length) return;
    setState(() {
      _fieldControllers[index].dispose();
      _fieldControllers.removeAt(index);
    });
    _notifyFields();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.node.color.withOpacity(widget.isSelected ? 1 : 0.3);
    final borderWidth = widget.isSelected ? 3.0 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (details) {
        _offset += details.delta;
        widget.onDrag(_offset);
      },
      child: Container(
        width: widget.node.size.width,
        decoration: BoxDecoration(
          color: widget.node.color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow:
              widget.isSelected ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 4))] : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getNodeTypeLabel(widget.node.type),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
            ),
            const Divider(height: 16, thickness: 1),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._fieldControllers.asMap().entries.map((entry) {
              final i = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          hintText: 'Field ${i + 1}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    HoldToDeleteButtonWidget(onDelete: () => _removeField(i)),
                  ],
                ),
              );
            }),
            Wrap(spacing: 8, runSpacing: 4, children: [TextButton(onPressed: _addField, child: const Text('+ Field'))]),
          ],
        ),
      ),
    );
  }

  String _getNodeTypeLabel(NodeType type) {
    switch (type) {
      case NodeType.entity:
        return 'Entity';
      case NodeType.interface:
        return 'Interface';
      case NodeType.abstractClass:
        return 'Abstract Class';
    }
  }
}
