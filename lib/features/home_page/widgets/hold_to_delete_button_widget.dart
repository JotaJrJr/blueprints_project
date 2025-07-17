import 'dart:async';
import 'package:flutter/material.dart';

class HoldToTriggerAction extends StatefulWidget {
  final VoidCallback onActionTrigger;
  final double size;
  final Color fillColor;
  final Color borderColor;
  final Duration holdDuration;

  const HoldToTriggerAction({
    super.key,
    required this.onActionTrigger,
    this.size = 24,
    this.fillColor = Colors.redAccent,
    this.borderColor = Colors.black38,
    this.holdDuration = const Duration(seconds: 1),
  });

  @override
  State<HoldToTriggerAction> createState() => _HoldToTriggerActionState();
}

class _HoldToTriggerActionState extends State<HoldToTriggerAction> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.holdDuration)..addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onActionTrigger();
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
                  child: const Center(child: Icon(Icons.radio_button_checked, size: 16)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
