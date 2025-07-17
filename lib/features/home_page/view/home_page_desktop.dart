import 'package:flutter/material.dart';
import 'package:blueprints_project/features/home_page/widgets/node_detail_panel.dart';
import 'package:blueprints_project/features/home_page/widgets/board_canvas_widget.dart';
import 'package:blueprints_project/features/home_page/widgets/bottom_panel_widget.dart';
import '../home_view_model.dart';

class HomePageDesktop extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomePageDesktop({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
      ),
      body: Row(
        children: [
          AnimatedBuilder(
            animation: viewModel,
            builder: (_, __) {
              final selectedNodeId = viewModel.currentSelectedNodeId;
              final selectedNode =
                  selectedNodeId != null && viewModel.nodes.any((n) => n.id == selectedNodeId)
                      ? viewModel.nodes.firstWhere((n) => n.id == selectedNodeId)
                      : null;

              return NodeDetailPanel(
                selectedNode: selectedNode,
                allNodes: viewModel.nodes,
                onPrev: viewModel.selectNode,
                onNext: viewModel.selectNode,
                // onUpdate: (newTitle, newFields) {
                //   if (selectedNodeId != null) {
                //     viewModel.updateNode(selectedNodeId, title: newTitle, fields: newFields);
                //   }
                // },
              );
            },
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: viewModel,
                    builder:
                        (_, __) => InteractiveViewer(
                          maxScale: 4.0,
                          minScale: 0.25,
                          boundaryMargin: const EdgeInsets.all(1000),
                          constrained: false,
                          child: BoardCanvasWidget(
                            nodes: viewModel.nodes,
                            edges: viewModel.edges,
                            selectedNodeType: viewModel.selectedNodeType,
                            selectedColor: viewModel.selectedColor,
                            onAddNode: viewModel.addNodeAt,
                            onNodeDrag: viewModel.updateNodePosition,
                            // onNodeContentChanged: viewModel.updateNode,
                            onNodeTap: viewModel.handleNodeTap,
                            selectedNodeId: viewModel.currentSelectedNodeId ?? '',
                          ),
                        ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: viewModel,
                    builder:
                        (_, __) => BottomPanelWidget(
                          selectedNodeType: viewModel.selectedNodeType,
                          selectedColor: viewModel.selectedColor,
                          isConnecting: viewModel.isConnectingMode,
                          selectedNodeId: viewModel.currentSelectedNodeId,
                          nodes: viewModel.nodes,
                          onTypeChanged: viewModel.setSelectedNodeType,
                          onColorChanged: viewModel.setSelectedColor,
                          onConnectToggled: viewModel.setConnectingMode,
                          onNodeSelected: viewModel.selectNode,

                          onAddNodeRequest: () {
                            const defaultOffset = Offset(400, 400);
                            viewModel.addNodeAt(defaultOffset, viewModel.selectedNodeType, viewModel.selectedColor);
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
