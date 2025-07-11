import 'package:blueprints_project/common/enums/device_type.dart';
import 'package:blueprints_project/common/view_layout_manager.dart';
import 'package:blueprints_project/features/home_page/home_view_model.dart';
import 'package:blueprints_project/features/home_page/view/home_page_desktop.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewLayoutManager<HomeViewModel>(
      pages: {DeviceType.desktop: (model) => HomePageDesktop(viewModel: viewModel)},
      viewModel: viewModel,
    );
  }
}
