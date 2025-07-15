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
