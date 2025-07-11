import 'dart:async';
import 'package:flutter/material.dart';

class HoldToDeleteButtonWidget extends StatefulWidget {
  final VoidCallback onDelete;
  final double size;
  final Color fillColor;
  final Color borderColor;
  final Duration holdDuration;

  const HoldToDeleteButtonWidget({
    super.key,
    required this.onDelete,
    this.size = 24,
    this.fillColor = Colors.redAccent,
    this.borderColor = Colors.black38,
    this.holdDuration = const Duration(seconds: 1),
  });

  @override
  State<HoldToDeleteButtonWidget> createState() => _HoldToDeleteButtonWidgetState();
}

class _HoldToDeleteButtonWidgetState extends State<HoldToDeleteButtonWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.holdDuration)..addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onDelete();
        _reset();
      }
    });
  }

  void _startHold() {
    _ctrl.forward();
  }

  void _reset() {
    _timer?.cancel();
    _ctrl.stop();
    _ctrl.reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _reset(),
      onTapCancel: _reset,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.fillColor.withOpacity(_ctrl.value),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: widget.borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(child: Icon(Icons.delete, size: 16)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
