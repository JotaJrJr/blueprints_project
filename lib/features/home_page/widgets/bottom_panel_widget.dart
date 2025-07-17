import 'package:blueprints_project/external/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../external/ui_node.dart';

typedef NodeTypeChanged = void Function(TipoNode newType);
typedef ColorChanged = void Function(Color newColor);
typedef NodeSelected = void Function(String nodeId);

typedef ConnectToggled = void Function(bool isConnecting);
typedef AddNodeRequested = void Function();

class BottomPanelWidget extends StatelessWidget {
  final TipoNode selectedNodeType;
  final Color selectedColor;
  final bool isConnecting;
  final String? selectedNodeId;
  final List<UINode> nodes;

  final NodeTypeChanged onTypeChanged;
  final ColorChanged onColorChanged;
  final ConnectToggled onConnectToggled;
  final NodeSelected onNodeSelected;

  final AddNodeRequested onAddNodeRequest;

  const BottomPanelWidget({
    super.key,
    required this.selectedNodeType,
    required this.selectedColor,
    required this.isConnecting,
    required this.selectedNodeId,
    required this.nodes,
    required this.onTypeChanged,
    required this.onColorChanged,
    required this.onConnectToggled,
    required this.onNodeSelected,

    required this.onAddNodeRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [const Text("Connect"), Switch(value: isConnecting, onChanged: onConnectToggled)]),

          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: nodes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final node = nodes[i];
                final isSelected = node.id == selectedNodeId;
                return GestureDetector(
                  onTap: () => onNodeSelected(node.id),
                  //   onLongPress: () => onNodeDeleted(node.id),
                  onLongPress: () {
                    debugPrint('long tap');
                  },
                  child: Chip(
                    label: Text(
                      node.title.isEmpty ? "(no title)" : node.title,
                      style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                    backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    Color temp = selectedColor;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: BlockPicker(pickerColor: selectedColor, onColorChanged: (c) => temp = c),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onColorChanged(temp);
                },
                child: const Text('Select'),
              ),
            ],
          ),
    );
  }
}
