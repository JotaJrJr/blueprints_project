import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../external/class.dart';

class FormCreationPage extends StatefulWidget {
  const FormCreationPage({super.key});

  @override
  State<FormCreationPage> createState() => _FormCreationPageState();
}

class _FormCreationPageState extends State<FormCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _formName = '';
  final List<FieldDefinition> _fields = [];

  void _addField(TipoCampo type) {
    setState(() {
      _fields.add(FieldDefinition(id: Uuid().v4(), name: 'Campo ${_fields.length + 1}', type: type, isRequired: false));
    });
  }

  // form_creation_page.dart
  void _navigateToCanvas() {
    if (_formKey.currentState!.validate()) {
      final formBlueprint = Formulario(
        objectName: _formName,
        nome: _formName,
        elements: _fields.map((f) => f.toCampoBase()).toList(),
        tipo: TipoElemento.dado,
        direcao: DirecaoElemento.entrada,
        blueprint: Blueprint(nodes: [], conexoes: []),
      );

      Navigator.pushNamed(context, "/home", arguments: formBlueprint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Builder')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Form Name'),
              onChanged: (v) => _formName = v,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _fields.length,
                itemBuilder:
                    (ctx, i) => FieldEditor(
                      key: Key(_fields[i].id),
                      field: _fields[i],
                      onChanged: (updated) => _fields[i] = updated,
                      onDeleted: () => setState(() => _fields.removeAt(i)),
                    ),
                onReorder: (oldIndex, newIndex) {
                  setState(() => _fields.insert(newIndex, _fields.removeAt(oldIndex)));
                },
              ),
            ),
            FieldTypeSelector(onSelect: _addField),
            ElevatedButton(onPressed: _navigateToCanvas, child: Text('Open Canvas')),
          ],
        ),
      ),
    );
  }
}

class FieldDefinition {
  final String id;
  String name;
  TipoCampo type;
  bool isRequired;
  String? defaultValue;
  List<String>? options; // For select fields

  FieldDefinition({
    String? id,
    required this.name,
    required this.type,
    this.isRequired = false,
    this.defaultValue,
    this.options,
  }) : id = id ?? const Uuid().v4();

  // Converts to the complex CampoBase when moving to canvas
  CampoBase toCampoBase() {
    switch (type) {
      case TipoCampo.textoCurto:
        return CampoTextoCurto(nome: name, obrigatorio: isRequired);
      case TipoCampo.textoLongo:
        return CampoTextoLongo(nome: name, obrigatorio: isRequired);
      case TipoCampo.inteiro:
        return CampoInteiro(nome: name, obrigatorio: isRequired);
      case TipoCampo.monetario:
        return CampoMonetario(nome: name, obrigatorio: isRequired);
      case TipoCampo.data:
        return CampoData(nome: name, obrigatorio: isRequired);
      case TipoCampo.select:
        return CampoSelect(nome: name, obrigatorio: isRequired);
      case TipoCampo.multiSelect:
        return CampoMultiSelect(nome: name, obrigatorio: isRequired);
    }
  }

  FieldDefinition copyWith({
    String? name,
    TipoCampo? type,
    bool? isRequired,
    String? defaultValue,
    List<String>? options,
  }) {
    return FieldDefinition(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
    );
  }
}

class FieldEditor extends StatelessWidget {
  final FieldDefinition field;
  final ValueChanged<FieldDefinition> onChanged;
  final VoidCallback onDeleted;

  const FieldEditor({super.key, required this.field, required this.onChanged, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(field.id),
      title: TextFormField(
        initialValue: field.name,
        decoration: const InputDecoration(labelText: 'Field Name'),
        onChanged: (v) => onChanged(field.copyWith(name: v)),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${field.type.toString().split('.').last}'),
          SwitchListTile(
            title: const Text('Required'),
            value: field.isRequired,
            onChanged: (v) => onChanged(field.copyWith(isRequired: v)),
          ),
        ],
      ),
      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: onDeleted),
    );
  }
}

class FieldTypeSelector extends StatelessWidget {
  final ValueChanged<TipoCampo> onSelect;

  const FieldTypeSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _buildButton(TipoCampo.textoCurto, Icons.short_text, 'Short Text'),
        _buildButton(TipoCampo.textoLongo, Icons.notes, 'Long Text'),
        _buildButton(TipoCampo.inteiro, Icons.numbers, 'Integer'),
        _buildButton(TipoCampo.monetario, Icons.attach_money, 'Currency'),
        _buildButton(TipoCampo.data, Icons.calendar_today, 'Date'),
        _buildButton(TipoCampo.select, Icons.list, 'Select'),
        _buildButton(TipoCampo.multiSelect, Icons.checklist, 'Multi-Select'),
      ],
    );
  }

  Widget _buildButton(TipoCampo type, IconData icon, String tooltip) {
    return Tooltip(message: tooltip, child: IconButton(icon: Icon(icon), onPressed: () => onSelect(type)));
  }
}
