import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

// Enums
enum TipoElemento { evento, dado }

enum DirecaoElemento { entrada, saida }

enum TipoNode {
  toLower,
  trim,
  regex,
  textoEstatico,
  print,
  ifNode;

  static TipoNode? fromString(String value) {
    return TipoNode.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw Exception('TipoNode desconhecido: $value'),
    );
  }
}

enum CondicaoIfNode {
  isEqual(
    nome: "Igual a",
    descricao: "Verifica se os valores são iguais",
    metadados: [
      ElementoMeta("Valor 1", TipoDado.string, DirecaoElemento.entrada),
      ElementoMeta("Valor 2", TipoDado.string, DirecaoElemento.entrada),
    ],
  ),
  isNotEqual(
    nome: "Diferente de",
    descricao: "Verifica se os valores são diferentes",
    metadados: [
      ElementoMeta("Valor 1", TipoDado.string, DirecaoElemento.entrada),
      ElementoMeta("Valor 2", TipoDado.string, DirecaoElemento.entrada),
    ],
  ),
  contains(
    nome: "Contém",
    descricao: "Verifica se a lista contém o valor",
    metadados: [
      ElementoMeta("Lista", TipoDado.list, DirecaoElemento.entrada, tipagemLista: TipoDado.string),
      ElementoMeta("Valor", TipoDado.string, DirecaoElemento.entrada),
    ],
  ),
  isGreaterThan(
    nome: "Maior que",
    descricao: "Verifica se o primeiro valor é maior que o segundo",
    metadados: [
      ElementoMeta("Valor 1", TipoDado.number, DirecaoElemento.entrada),
      ElementoMeta("Valor 2", TipoDado.number, DirecaoElemento.entrada),
    ],
  ),
  isLessThan(
    nome: "Menor que",
    descricao: "Verifica se o primeiro valor é menor que o segundo",
    metadados: [
      ElementoMeta("Valor 1", TipoDado.number, DirecaoElemento.entrada),
      ElementoMeta("Valor 2", TipoDado.number, DirecaoElemento.entrada),
    ],
  ),
  isDateBefore(
    nome: "Data anterior",
    descricao: "Verifica se uma data é anterior à outra",
    metadados: [
      ElementoMeta("Data 1", TipoDado.string, DirecaoElemento.entrada),
      ElementoMeta("Data 2", TipoDado.string, DirecaoElemento.entrada),
    ],
  ),
  isEmpty(
    nome: "Está vazio",
    descricao: "Verifica se um valor está vazio",
    metadados: [ElementoMeta("Valor", TipoDado.string, DirecaoElemento.entrada)],
  );

  final String nome;
  final String descricao;
  final List<ElementoMeta> metadados;

  const CondicaoIfNode({required this.nome, required this.descricao, required this.metadados});

  /// Método auxiliar para criar os elementos reais com UUIDs
  List<ElementBase> createElements() {
    return metadados.map((meta) => meta.toElement()).toList();
  }
}

/// Classe auxiliar para representar metadados de elemento
class ElementoMeta {
  final String nome;
  final TipoDado tipo;
  final DirecaoElemento direcao;
  final TipoDado? tipagemLista;

  const ElementoMeta(this.nome, this.tipo, this.direcao, {this.tipagemLista});

  ElementBase toElement() {
    if (tipo == TipoDado.list) {
      return DadoList(nome: nome, direcao: direcao, tipagem: tipagemLista ?? TipoDado.string);
    } else {
      return Dado(nome: nome, direcao: direcao, dado: tipo);
    }
  }
}

enum TipoCampo {
  textoCurto,
  textoLongo,
  inteiro,
  monetario,
  data,
  select,
  multiSelect;

  static TipoCampo fromString(String value) {
    return TipoCampo.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw Exception('TipoCampo desconhecido: $value'),
    );
  }
}

enum TipoDado { string, number, list, boolean }

class Dado extends ElementBase {
  final TipoDado dado;

  Dado({super.id, required super.nome, required this.dado, required super.direcao}) : super(tipo: TipoElemento.dado);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipoElemento': tipo.name,
    'direcao': direcao.name,
    'dado': dado.name,
    'isRemovable': isRemovable,
  };
}

class DadoList extends Dado {
  final TipoDado tipagem;

  DadoList({super.id, required super.nome, required this.tipagem, required super.direcao}) : super(dado: TipoDado.list);
  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['tipagem'] = tipagem.name;
    return map;
  }
}

class Event extends ElementBase {
  Event({super.id, required super.nome, required super.direcao}) : super(tipo: TipoElemento.evento);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipoElemento': tipo.name,
    'direcao': direcao.name,
    'isRemovable': isRemovable,
  };
}

// Elemento base
abstract class ElementBase {
  final String id;
  final String nome;
  final TipoElemento tipo;
  final DirecaoElemento direcao;
  final bool isRemovable;

  ElementBase({String? id, required this.nome, required this.tipo, required this.direcao, this.isRemovable = true})
    : id = id ?? const Uuid().v4();

  static ElementBase fromJson(Map<String, dynamic> json) {
    final tipoElemento = TipoElemento.values.firstWhere(
      (e) => e.name.toLowerCase() == json['tipoElemento'].toLowerCase(),
    );
    final direcao = DirecaoElemento.values.firstWhere((e) => e.name.toLowerCase() == json['direcao'].toLowerCase());

    switch (tipoElemento) {
      case TipoElemento.dado:
        if (json['dado'] != null) {
          return Dado(
            id: json['id'],
            nome: json['nome'],
            direcao: direcao,
            dado: TipoDado.values.firstWhere((d) => d.name.toLowerCase() == json['dado'].toLowerCase()),
          );
        }
        break;

      case TipoElemento.evento:
        return Event(id: json['id'], nome: json['nome'], direcao: direcao);
    }

    throw Exception("Tipo de Elemento não suportado: $tipoElemento");
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipoElemento': tipo.name,
    'direcao': direcao.name,
    'isRemovable': isRemovable,
  };
}

// Conexao
class Conexao {
  final String id;
  final String origem;
  final String destino;

  Conexao({String? id, required this.origem, required this.destino}) : id = id ?? const Uuid().v4();

  factory Conexao.fromJson(Map<String, dynamic> json) {
    return Conexao(origem: json['origemId'], destino: json['destinoId']);
  }

  static Conexao? createConexao({required ElementBase origem, required ElementBase destino, bool force = false}) {
    final validation = _validarConexao(origem, destino, force: force);
    if (!validation.isValid) {
      throw Exception('Conexão inválida: ${validation.message}');
    }

    return Conexao(id: const Uuid().v4(), origem: origem.id, destino: destino.id);
  }

  static _ValidationResult _validarConexao(ElementBase origem, ElementBase destino, {bool force = false}) {
    if (!force) {
      // Caso padrão: origem deve ser saída, destino deve ser entrada
      if (origem.direcao != DirecaoElemento.saida) {
        return _ValidationResult(false, "Origem '${origem.nome}' não é de saída");
      }
      if (destino.direcao != DirecaoElemento.entrada) {
        return _ValidationResult(false, "Destino '${destino.nome}' não é de entrada");
      }
    } else {
      // Caso force: permite origem entrada e destino saída
      if (!((origem.direcao == DirecaoElemento.saida && destino.direcao == DirecaoElemento.entrada) ||
          (origem.direcao == DirecaoElemento.entrada && destino.direcao == DirecaoElemento.saida))) {
        return _ValidationResult(
          false,
          "Conexão inválida com force: Origem(${origem.direcao}), Destino(${destino.direcao})",
        );
      }
    }

    // Validação de tipos (mesmos tipos ou evento para dado etc)
    if (origem.tipo == TipoElemento.evento && destino.tipo == TipoElemento.evento) {
      return _ValidationResult(true, '');
    }

    if (origem.tipo == TipoElemento.dado && destino.tipo == TipoElemento.evento) {
      return _ValidationResult(true, '');
    }

    if (origem.tipo == TipoElemento.dado && destino.tipo == TipoElemento.dado) {
      return _ValidationResult(true, '');
    }

    return _ValidationResult(false, "Conexão inválida: Origem(${origem.tipo}), Destino(${destino.tipo})");
  }

  Map<String, dynamic> toJson() => {'id': id, 'origemId': origem, 'destinoId': destino};
}

class _ValidationResult {
  final bool isValid;
  final String message;
  _ValidationResult(this.isValid, this.message);
}

// Node base
abstract class NodeBase {
  final String id;
  final String? nome;
  final TipoNode tipo;
  List<ElementBase> elementos;

  NodeBase({String? id, required this.tipo, this.nome, required this.elementos}) : id = id ?? const Uuid().v4();

  factory NodeBase.fromJson(Map<String, dynamic> json) {
    final tipo = TipoNode.fromString(json['tipo']);
    final elementos = (json['elementos'] as List).map((e) => ElementBase.fromJson(e)).toList();

    switch (tipo) {
      case TipoNode.toLower:
        return ToLowerNode.fromJson(json, elementos);
      case TipoNode.trim:
        return TrimNode.fromJson(json, elementos);
      case TipoNode.regex:
        return RegexNode.fromJson(json, elementos);
      case TipoNode.textoEstatico:
        return TextoEstaticoNode.fromJson(json, elementos);
      case TipoNode.print:
        return PrintNode.fromJson(json, elementos);
      case TipoNode.ifNode:
        return IfNode.fromJson(json, elementos);
      default:
        throw Exception("teste");
    }
  }

  onAdd(Blueprint blueprint);

  Map<String, dynamic> toJson() => {
    'id': id,
    if (nome != null) 'nome': nome,
    'tipo': tipo.name,
    'elementos': elementos.map((e) => e.toJson()).toList(),
  };
}

class ToLowerNode extends NodeBase {
  late final ElementBase input;
  late final ElementBase output;

  ToLowerNode({super.id, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.toLower,
        elementos:
            elementos ??
            [
              Dado(nome: "Input", direcao: DirecaoElemento.entrada, dado: TipoDado.string),
              Dado(nome: "Output", direcao: DirecaoElemento.saida, dado: TipoDado.string),
            ],
      ) {
    final elems = elementos ?? this.elementos;
    input = elems.firstWhere((e) => e.direcao == DirecaoElemento.entrada);
    output = elems.firstWhere((e) => e.direcao == DirecaoElemento.saida);
  }

  factory ToLowerNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    return ToLowerNode(id: json['id'], elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    blueprint.conexoes.add(Conexao.createConexao(origem: input, destino: output, force: true)!);
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    return base;
  }
}

class TrimNode extends NodeBase {
  final bool start;
  final bool end;

  late final ElementBase input;
  late final ElementBase output;

  TrimNode({super.id, required this.start, required this.end, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.trim,
        elementos:
            elementos ??
            [
              Dado(nome: "Input", direcao: DirecaoElemento.entrada, dado: TipoDado.string),
              Dado(nome: "Output", direcao: DirecaoElemento.saida, dado: TipoDado.string),
            ],
      ) {
    final elems = elementos ?? this.elementos;
    input = elems.firstWhere((e) => e.direcao == DirecaoElemento.entrada);
    output = elems.firstWhere((e) => e.direcao == DirecaoElemento.saida);
  }

  factory TrimNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    return TrimNode(id: json['id'], start: json['start'] ?? false, end: json['end'] ?? false, elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    blueprint.conexoes.add(Conexao.createConexao(origem: input, destino: output, force: true)!);
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['start'] = start;
    base['end'] = end;
    return base;
  }
}

class RegexNode extends NodeBase {
  final String regex;

  late final ElementBase input;
  late final ElementBase output;
  late final ElementBase success;
  late final ElementBase error;

  RegexNode({super.id, required this.regex, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.regex,
        elementos:
            elementos ??
            [
              Dado(nome: "Input", direcao: DirecaoElemento.entrada, dado: TipoDado.string),
              Dado(nome: "Output", direcao: DirecaoElemento.saida, dado: TipoDado.string),
              Event(nome: "Sucesso", direcao: DirecaoElemento.saida),
              Event(nome: "Falha", direcao: DirecaoElemento.saida),
            ],
      ) {
    final elems = elementos ?? this.elementos;
    input = elems.firstWhere((e) => e.direcao == DirecaoElemento.entrada && e.tipo == TipoElemento.dado);
    output = elems.firstWhere((e) => e.direcao == DirecaoElemento.saida && e.tipo == TipoElemento.dado);
    success = elems.firstWhere((e) => e.nome == "Sucesso" && e.tipo == TipoElemento.evento);
    error = elems.firstWhere((e) => e.nome == "Falha" && e.tipo == TipoElemento.evento);
  }

  factory RegexNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    return RegexNode(id: json['id'], regex: json['regex'], elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    blueprint.conexoes.add(Conexao.createConexao(origem: input, destino: output, force: true)!);
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['regex'] = regex;
    return base;
  }
}

class TextoEstaticoNode extends NodeBase {
  final String valor;
  late final ElementBase output;

  TextoEstaticoNode({super.id, required super.nome, required this.valor, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.textoEstatico,
        elementos: elementos ?? [Dado(nome: "Output", dado: TipoDado.string, direcao: DirecaoElemento.saida)],
      ) {
    final elems = elementos ?? this.elementos;
    output = elems.firstWhere((e) => e.direcao == DirecaoElemento.saida);
  }

  factory TextoEstaticoNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    return TextoEstaticoNode(id: json['id'], nome: json['nome'], valor: json['valor'], elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    // Não gera conexões automáticas
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['valor'] = valor;
    return base;
  }
}

class PrintNode extends NodeBase {
  late final ElementBase evento;
  late final ElementBase texto;

  PrintNode({super.id, required super.nome, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.print,
        elementos:
            elementos ??
            [
              Event(nome: "Exibir", direcao: DirecaoElemento.entrada),
              Dado(nome: "Texto", direcao: DirecaoElemento.entrada, dado: TipoDado.string),
            ],
      ) {
    final elems = elementos ?? this.elementos;
    evento = elems.firstWhere((e) => e.nome == "Exibir");
    texto = elems.firstWhere((e) => e.nome == "Texto");
  }

  factory PrintNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    return PrintNode(id: json['id'], nome: json['nome'], elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    // Não gera conexões automáticas
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}

class IfNode extends NodeBase {
  final CondicaoIfNode condicao;

  late final Iterable<ElementBase> inputs;
  late final ElementBase isTrue;
  late final ElementBase isFalse;
  late final ElementBase onSuccesso;
  late final ElementBase onError;

  IfNode({super.id, required super.nome, required this.condicao, List<ElementBase>? elementos})
    : super(
        tipo: TipoNode.ifNode,
        elementos:
            elementos ??
            [
              ...condicao.createElements(),
              Dado(nome: "True", dado: TipoDado.boolean, direcao: DirecaoElemento.saida),
              Dado(nome: "False", dado: TipoDado.boolean, direcao: DirecaoElemento.saida),
              Event(nome: "Successo", direcao: DirecaoElemento.saida),
              Event(nome: "Error", direcao: DirecaoElemento.saida),
            ],
      ) {
    final elems = elementos ?? this.elementos;
    isTrue = elems.firstWhere((e) => e.nome == "True");
    isFalse = elems.firstWhere((e) => e.nome == "False");
    onSuccesso = elems.firstWhere((e) => e.nome == "Successo");
    onError = elems.firstWhere((e) => e.nome == "Error");
    inputs = elems.where((e) => e.direcao == DirecaoElemento.entrada);
  }

  factory IfNode.forCondition(CondicaoIfNode condicao, {String nome = ""}) {
    return IfNode(nome: nome, condicao: condicao);
  }

  factory IfNode.fromJson(Map<String, dynamic> json, List<ElementBase> elementos) {
    final cond = CondicaoIfNode.values.firstWhere(
      (e) => e.name.toLowerCase() == (json['condicao']?.toLowerCase() ?? 'isequal'),
    );
    return IfNode(id: json['id'], nome: json['nome'], condicao: cond, elementos: elementos);
  }

  @override
  void onAdd(Blueprint blueprint) {
    if (elementos.length >= 2) {
      final a = elementos[0];
      final b = elementos[1];
      if (a.direcao == DirecaoElemento.entrada && b.direcao == DirecaoElemento.entrada) {
        blueprint.conexoes.add(Conexao.createConexao(origem: a, destino: b, force: true)!);
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['condicao'] = condicao.name;
    return base;
  }
}

// BlueprintCampo
class Blueprint {
  final List<NodeBase> nodes;
  final List<Conexao> conexoes;

  Blueprint({required this.nodes, required this.conexoes});

  factory Blueprint.fromJson(Map<String, dynamic> json) {
    return Blueprint(
      nodes: (json['nodes'] as List).map((n) => NodeBase.fromJson(n)).toList(),
      conexoes: (json['conexoes'] as List).map((c) => Conexao.fromJson(c)).toList(),
    );
  }

  addNode(NodeBase node) {
    nodes.add(node);
    node.onAdd(this);
  }

  remove(NodeBase node) {
    nodes.remove(node);
    var elementsIds = node.elementos.map((e) => e.id);
    conexoes.removeWhere((x) => elementsIds.contains(x.origem) || elementsIds.contains(x.destino));
  }

  Map<String, dynamic> toJson() => {
    'nodes': nodes.map((n) => n.toJson()).toList(),
    'conexoes': conexoes.map((c) => c.toJson()).toList(),
  };
}

class Input extends ElementBase {
  final List<ElementBase> elements;
  late Blueprint blueprint;

  Input({
    super.id,
    required super.nome,
    required this.elements,
    required super.tipo,
    required super.direcao,
    Blueprint? blueprint,
  }) : super(isRemovable: false) {
    this.blueprint = blueprint ?? Blueprint(nodes: [], conexoes: []);
  }

  factory Input.fromJson(Map<String, dynamic> json) {
    return Input(
      id: json['id'],
      nome: json['nome'],
      elements: (json['elements'] as List).map((e) => CampoBase.fromJson(e)).toList(),
      blueprint: Blueprint.fromJson(json['blueprint']),
      tipo: TipoElemento.values.firstWhere((e) => e.name == json['tipo']),
      direcao: DirecaoElemento.values.firstWhere((e) => e.name == json['direcao']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'id': id,
    'nome': nome,
    'elements': elements.map((e) => e.toJson()).toList(),
    'tipo': tipo.name,
    'direcao': direcao.name,
    'blueprint': blueprint.toJson(),
    'isRemovable': isRemovable,
  };
}

class Formulario extends Input {
  String objectName;

  Formulario({
    required this.objectName,
    required super.nome,
    required super.elements,
    required super.tipo,
    required super.direcao,
    required super.blueprint,
  });

  @override
  Map<String, dynamic> toJson() => {
    'objectName': objectName,
    ...super.toJson(), // inclui os campos da classe base
  };
}

abstract class CampoBase extends Input {
  final TipoCampo fieldType;
  final bool obrigatorio;

  ElementBase get input => elements.firstWhere((x) => x.nome == "Input" && x.direcao == DirecaoElemento.saida);
  ElementBase get output => elements.firstWhere((x) => x.direcao == DirecaoElemento.entrada);
  ElementBase get result => this;

  CampoBase({required super.nome, required this.fieldType, required this.obrigatorio, Blueprint? blueprintCampo})
    : super(
        id: _generateId(),
        tipo: TipoElemento.dado,
        direcao: DirecaoElemento.saida,
        elements: _buildElements(),
        blueprint: blueprintCampo ?? _buildBlueprint(_lastGeneratedId!, _entradaId!, _saidaId!),
      );

  // Variáveis temporárias para manter os mesmos UUIDs durante a construção
  static String? _lastGeneratedId;
  static String? _entradaId;
  static String? _saidaId;

  static String _generateId() {
    _lastGeneratedId = const Uuid().v4();
    _entradaId = const Uuid().v4();
    _saidaId = const Uuid().v4();
    return _lastGeneratedId!;
  }

  static List<ElementBase> _buildElements() {
    return [
      Dado(id: _entradaId!, nome: "Input", direcao: DirecaoElemento.saida, dado: TipoDado.string), //ajustar
      Dado(id: _saidaId!, nome: "Output", direcao: DirecaoElemento.entrada, dado: TipoDado.string), //ajustar
    ];
  }

  static Blueprint _buildBlueprint(String campoId, String entradaId, String saidaId) {
    return Blueprint(
      nodes: [],
      conexoes: [
        Conexao(id: const Uuid().v4(), origem: entradaId, destino: saidaId),
        Conexao(id: const Uuid().v4(), origem: saidaId, destino: campoId),
      ],
    );
  }

  factory CampoBase.fromJson(Map<String, dynamic> json) {
    final tipo = TipoCampo.fromString(json['tipo']);
    switch (tipo) {
      case TipoCampo.textoCurto:
        return CampoTextoCurto.fromJson(json);
      case TipoCampo.textoLongo:
        return CampoTextoLongo.fromJson(json);
      case TipoCampo.inteiro:
        return CampoInteiro.fromJson(json);
      case TipoCampo.monetario:
        return CampoMonetario.fromJson(json);
      case TipoCampo.data:
        return CampoData.fromJson(json);
      case TipoCampo.select:
        return CampoSelect.fromJson(json);
      case TipoCampo.multiSelect:
        return CampoMultiSelect.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'id': id,
    'nome': nome,
    'tipo': fieldType.name,
    'obrigatorio': obrigatorio,
    'elements': elements.map((e) => e.toJson()).toList(),
    'blueprintCampo': blueprint.toJson(),
  };
}

// Implementações dos tipos de campo
class CampoTextoCurto extends CampoBase {
  CampoTextoCurto({required super.nome, required super.obrigatorio, super.blueprintCampo})
    : super(fieldType: TipoCampo.textoCurto);

  factory CampoTextoCurto.fromJson(Map<String, dynamic> json) {
    return CampoTextoCurto(
      nome: json['nome'],
      obrigatorio: json['obrigatorio'],
      blueprintCampo: json['blueprintCampo'] != null ? Blueprint.fromJson(json['blueprintCampo']) : null,
    );
  }
}

class CampoTextoLongo extends CampoBase {
  CampoTextoLongo({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.textoLongo);

  factory CampoTextoLongo.fromJson(Map<String, dynamic> json) {
    return CampoTextoLongo(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

class CampoInteiro extends CampoBase {
  CampoInteiro({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.inteiro);

  factory CampoInteiro.fromJson(Map<String, dynamic> json) {
    return CampoInteiro(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

class CampoMonetario extends CampoBase {
  CampoMonetario({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.monetario);

  factory CampoMonetario.fromJson(Map<String, dynamic> json) {
    return CampoMonetario(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

class CampoData extends CampoBase {
  CampoData({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.data);

  factory CampoData.fromJson(Map<String, dynamic> json) {
    return CampoData(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

class CampoSelect extends CampoBase {
  CampoSelect({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.select);

  factory CampoSelect.fromJson(Map<String, dynamic> json) {
    return CampoSelect(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

class CampoMultiSelect extends CampoBase {
  CampoMultiSelect({required super.nome, required super.obrigatorio}) : super(fieldType: TipoCampo.multiSelect);

  factory CampoMultiSelect.fromJson(Map<String, dynamic> json) {
    return CampoMultiSelect(nome: json['nome'], obrigatorio: json['obrigatorio']);
  }
}

// class UINode {
//   final NodeBase nodeBase;
//   Offset position;
//   Size size;
//   Color color;

//   UINode({
//     required this.nodeBase,
//     required this.position,
//     this.size = const Size(150, 150),
//     this.color = Colors.blueAccent,
//   });

//   String get id => nodeBase.id;
//   String get title => nodeBase.nome ?? nodeBase.tipo.name;
//   List<ElementBase> get inputs => nodeBase.elementos.where((e) => e.direcao == DirecaoElemento.entrada).toList();
//   List<ElementBase> get outputs => nodeBase.elementos.where((e) => e.direcao == DirecaoElemento.saida).toList();

//   Offset getHandlePosition(ElementBase element) {
//     final isInput = element.direcao == DirecaoElemento.entrada;
//     final handles = isInput ? inputs : outputs;
//     final index = handles.indexOf(element);
//     if (index == -1) return position;
//     final numHandles = handles.length;
//     final yStep = size.height / (numHandles + 1);
//     final x = isInput ? position.dx : position.dx + size.width;
//     final y = position.dy + yStep * (index + 1);
//     return Offset(x, y);
//   }
// }
