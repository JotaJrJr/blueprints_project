import '../../common/enums/node_type.dart';
import '../../common/models/edge_model.dart';
import '../../common/models/node_model.dart';

class BluePrintViewModel {
  final List<NodeModel> nodes = [];
  final List<EdgeModel> edges = [];

  NodeType selectedNodeType = NodeType.entity;
}
