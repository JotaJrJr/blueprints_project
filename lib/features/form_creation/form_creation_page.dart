import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:blueprints_project/external/class.dart';
import 'package:blueprints_project/features/home_page/home_page.dart';

class FormCreationPage extends StatefulWidget {
  const FormCreationPage({super.key});

  @override
  State<FormCreationPage> createState() => _FormCreationPageState();
}

class _FormCreationPageState extends State<FormCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _formName = '';
  final List<NodeDefinition> _nodes = [];

  void _addNode() {
    setState(() {
      _nodes.add(NodeDefinition(name: 'Node ${_nodes.length + 1}'));
    });
  }

  void _removeNode(int index) {
    setState(() {
      _nodes.removeAt(index);
    });
  }

  void _addField(int nodeIndex) {
    setState(() {
      _nodes[nodeIndex].fields.add(
        FieldDefinition(name: 'Field ${_nodes[nodeIndex].fields.length + 1}', type: TipoCampo.textoCurto),
      );
    });
  }

  void _removeField(int nodeIndex, int fieldIndex) {
    setState(() {
      _nodes[nodeIndex].fields.removeAt(fieldIndex);
    });
  }

  void _navigateToCanvas() {
    if (_formKey.currentState!.validate()) {
      final blueprintNodes =
          _nodes.map((n) {
            final elements =
                n.fields
                    .map(
                      (f) => Dado(
                        id: const Uuid().v4(),
                        nome: f.name,
                        direcao: DirecaoElemento.saida,
                        dado: _mapTipoCampoToTipoDado(f.type),
                      ),
                    )
                    .toList();
            return TextoEstaticoNode(nome: n.name, valor: '', elementos: elements);
          }).toList();
      final blueprint = Blueprint(nodes: blueprintNodes, conexoes: []);
      final formBlueprint = Formulario(
        objectName: _formName,
        nome: _formName,
        elements: [],
        tipo: TipoElemento.dado,
        direcao: DirecaoElemento.entrada,
        blueprint: blueprint,
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(formBlueprint: formBlueprint)));
    }
  }

  TipoDado _mapTipoCampoToTipoDado(TipoCampo tipoCampo) {
    switch (tipoCampo) {
      case TipoCampo.textoCurto:
      case TipoCampo.textoLongo:
      case TipoCampo.data:
      case TipoCampo.select:
      case TipoCampo.multiSelect:
        return TipoDado.string;
      case TipoCampo.inteiro:
      case TipoCampo.monetario:
        return TipoDado.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Builder')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Form Name'),
                onChanged: (v) => _formName = v,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _nodes.length,
                  itemBuilder: (ctx, i) {
                    final node = _nodes[i];
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: node.name,
                              decoration: const InputDecoration(labelText: 'Node Name'),
                              onChanged: (v) => setState(() => node.name = v),
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeNode(i)),
                        ],
                      ),
                      children: [
                        for (var j = 0; j < node.fields.length; j++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: node.fields[j].name,
                                    decoration: const InputDecoration(labelText: 'Field Name'),
                                    onChanged: (v) => setState(() => node.fields[j].name = v),
                                  ),
                                ),
                                DropdownButton<TipoCampo>(
                                  value: node.fields[j].type,
                                  items:
                                      TipoCampo.values
                                          .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                                          .toList(),
                                  onChanged: (v) => setState(() => node.fields[j].type = v!),
                                ),
                                IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeField(i, j)),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextButton(onPressed: () => _addField(i), child: const Text('Add Field')),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(onPressed: () => _addNode(), child: const Text('Add Node')),
              const SizedBox(height: 8),

              //   ElevatedButton(
              //     // onPressed: _nodes.any((n) => n.fields.isNotEmpty) ? _navigateToCanvas : null,
              //     onPressed: () {
              //       if (_nodes.any((n) => n.fields.isNotEmpty)) {
              //         _navigateToCanvas();
              //       } else {
              //         ScaffoldMessenger.of(
              //           context,
              //         ).showSnackBar(const SnackBar(content: Text('Add at least one field to a node')));
              //       }
              //     },
              //     child: const Text('Open Canvas'),
              //   ),
              ElevatedButton(
                onPressed: () {
                  print('Nodes: ${_nodes.length}');
                  for (var node in _nodes) {
                    print('Node ${node.name}: ${node.fields.length} fields');
                  }
                  if (_nodes.any((n) => n.fields.isNotEmpty)) {
                    print('Condition true, calling _navigateToCanvas');
                    _navigateToCanvas();
                  } else {
                    print('Condition false, showing SnackBar');
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Add at least one field to a node')));
                  }
                },
                child: const Text('Open Canvas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NodeDefinition {
  final String id;
  String name;
  List<FieldDefinition> fields;

  NodeDefinition({required this.name, List<FieldDefinition>? fields}) : id = const Uuid().v4(), fields = fields ?? [];
}

class FieldDefinition {
  final String id;
  String name;
  TipoCampo type;

  FieldDefinition({required this.name, required this.type}) : id = const Uuid().v4();
}
