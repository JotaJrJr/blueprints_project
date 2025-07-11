import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? textInputType;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final String? label;
  final IconButton? actionButton;
  final bool isExpandable;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.onSubmitted,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.label,
    this.actionButton,
    this.isExpandable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          keyboardType: isExpandable ? TextInputType.multiline : textInputType,
          textInputAction: isExpandable ? TextInputAction.newline : TextInputAction.done,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          maxLines: isExpandable ? null : maxLines,
          minLines: isExpandable ? minLines : null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: false,
            label: label != null ? Text(label!) : null,
            suffixIcon: actionButton,
          ),
        ),
      ),
    );
  }
}
