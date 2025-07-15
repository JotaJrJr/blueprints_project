import 'package:blueprints_project/common/enums/device_type.dart';
import 'package:blueprints_project/common/view_layout_manager.dart';
import 'package:blueprints_project/external/class.dart';
import 'package:blueprints_project/features/home_page/home_view_model.dart';
import 'package:blueprints_project/features/home_page/view/home_page_desktop.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Formulario formBlueprint;
  const HomePage({super.key, required this.formBlueprint});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();

    if (widget.formBlueprint != null) {
      viewModel.initializeFromBlueprint(widget.formBlueprint);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewLayoutManager<HomeViewModel>(
      pages: {DeviceType.desktop: (model) => HomePageDesktop(viewModel: viewModel)},
      viewModel: viewModel,
    );
  }
}
