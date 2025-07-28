import 'package:blueprints_project/features/form_creation/form_creation_page.dart';
import 'package:blueprints_project/features/home_page/home_page.dart';
import 'package:blueprints_project/features/home_page/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:route_definer/route_definer.dart';
import 'dart:convert';

import 'external/class.dart';

void main() {
  AppRouter.init(
    GlobalRouteDefiner(
      initialRoute: '/',
      title: 'Route Example',
      isAuthorized: (_) => true,
      unauthorizedBuilder: (_, __) => const Scaffold(body: Center(child: Text("Unauthorized"))),
      onUnknownRoute: (_, __) => MaterialPageRoute(builder: (_) => const Scaffold(body: Text("404"))),
    ),
    [
      RouteDefiner(path: '/', builder: (_, __) => FormCreationPage()),
      RouteDefiner(
        path: '/home',
        builder: (_, routeState) => HomePage(viewModel: HomeViewModel(input: routeState.arguments as Input)),
      ),
      RouteDefiner(
        path: '/mock',
        builder: (_, routeState) => HomePage(viewModel: HomeViewModel(input: mockFormularioCriarUsuario())),
      ),
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppRouter.title,
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}


class JsonViewerPage extends StatefulWidget {
  const JsonViewerPage({super.key});
  @override
  State<JsonViewerPage> createState() => _JsonViewerPageState();
}

class _JsonViewerPageState extends State<JsonViewerPage> {
  late String jsonString;

  @override
  void initState() {
    super.initState();

    // Gerar o formulário
    // final formulario = mockFormularioCriarUsuario();

    // Converter para JSON string formatada
    // jsonString = const JsonEncoder.withIndent('  ').convert(formulario.toJson());
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('JSON copiado para a área de transferência!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizador JSON')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: SelectableText(jsonString))),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copiar JSON'),
              onPressed: copyToClipboard,
            ),
          ],
        ),
      ),
    );
  }
}

// Formulario mockFormularioCriarUsuario() {
//   var email = CampoTextoCurto(nome: "Email", obrigatorio: true);
//   var toLower = ToLowerNode();
//   var trim = TrimNode(start: true, end: true);
//   var regex = RegexNode(regex: r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
//   var texto = TextoEstaticoNode(nome: "Mensagem de erro do e-mail", valor: "E-mail inválido");
//   var print = PrintNode(nome: "Exibir erro do e-mail");
=======
Formulario mockFormularioCriarUsuario() {
  var email = CampoTextoCurto(nome: "Email", obrigatorio: true);
//   email.blueprint.addNode(regex);
//   email.blueprint.addNode(texto);
//   email.blueprint.addNode(print);

//   // Caminho feliz
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: email.input, destino: toLower.input)!);
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: toLower.output, destino: trim.input)!);
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: trim.output, destino: regex.input)!);
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: regex.output, destino: email.output)!);

//   // Caminho ruim (validação falha)
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: texto.output, destino: print.texto)!);
//   email.blueprint.conexoes.add(Conexao.createConexao(origem: regex.error, destino: print.evento)!);

//   // Campos de senha
//   var senha = CampoTextoCurto(nome: "Senha", obrigatorio: true);
//   var repetirSenha = CampoTextoCurto(nome: "Repetir Senha", obrigatorio: true);

//   // Nó de comparação de senhas
//   var ifNode = IfNode.forCondition(CondicaoIfNode.isEqual, nome: "Comparar senhas");

//   // Mensagem e print
//   var msgErro = TextoEstaticoNode(nome: "erro-texto", valor: "As senhas não coincidem.");
//   var mostrarErro = PrintNode(nome: "print");

//   var blueprint = Blueprint(
//     nodes: [ifNode, msgErro, mostrarErro],
//     conexoes: [
//       // Conectando campos ao IfNode
//       Conexao.createConexao(origem: senha.result, destino: ifNode.inputs.elementAt(0))!,
//       Conexao.createConexao(origem: repetirSenha.result, destino: ifNode.inputs.elementAt(1))!,

//       // Se falso, exibe erro
//       Conexao.createConexao(origem: ifNode.onError, destino: mostrarErro.evento)!, // "False" evento
//       Conexao.createConexao(origem: msgErro.output, destino: mostrarErro.texto)!,
//     ],
//   );

//   return Formulario(
//     objectName: "Usuario",
//     nome: "Criar Usuário",
//     tipo: TipoElemento.dado,
//     direcao: DirecaoElemento.entrada,
//     elements: [
//       CampoTextoCurto(nome: "Nome", obrigatorio: true),
//       email,
//       senha,
//       repetirSenha,
//       CampoData(nome: "Data de Nascimento", obrigatorio: false),
//     ],
//     blueprint: blueprint,
//   );
// }
