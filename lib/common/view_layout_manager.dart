import 'package:flutter/material.dart';
import 'enums/device_type.dart';

class ViewLayoutManager<TModel> extends StatelessWidget {
  final TModel viewModel;
  final void Function(DeviceType deviceType)? onChangeView;
  final Map<DeviceType, Widget Function(TModel)> pages;

  const ViewLayoutManager({super.key, this.onChangeView, required this.pages, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var media = MediaQuery.of(context);
        var currentDeviceType = DeviceType.getDevice(constraints.maxWidth, constraints.maxHeight, media.orientation);
        var deviceType = pages.keys.firstWhere(
          (type) => type == currentDeviceType,
          orElse: () => DeviceType.getNearestDeviceType(constraints.maxWidth, constraints.maxHeight, media.orientation, pages.keys.toList()),
        );

        return pages[deviceType]?.call(this.viewModel) ?? const SizedBox();
      },
    );
  }
}
