import 'package:blueprints_project/common/enums/device_type.dart';
import 'package:blueprints_project/common/view_layout_manager.dart';
import 'package:blueprints_project/external/class.dart';
import 'package:blueprints_project/features/home_page/home_view_model.dart';
import 'package:blueprints_project/features/home_page/view/home_page_desktop.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.init(),
      builder: (context, asyncSnapshot) {
        return ViewLayoutManager<HomeViewModel>(
          pages: {DeviceType.desktop: (model) => HomePageDesktop(viewModel: viewModel)},
          viewModel: viewModel,
        );
      },
    );
  }
}
