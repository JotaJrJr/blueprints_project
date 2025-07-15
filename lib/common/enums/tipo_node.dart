enum TipoNode {
  toLower,
  trim,
  regex,
  textoEstatico,
  print,
  renderFormulario,
  ifNode;

  static TipoNode? fromString(String value) {
    return TipoNode.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw Exception('TipoNode desconhecido: $value'),
    );
  }
}
