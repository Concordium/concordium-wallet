import 'package:flutter/material.dart';

class ProgressSpinner extends StatefulWidget {
  final int progressPercentage;

  const ProgressSpinner({super.key, required this.progressPercentage});

  @override
  State<ProgressSpinner> createState() => _ProgressSpinnerState();
}

class _ProgressSpinnerState extends State<ProgressSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didUpdateWidget(covariant ProgressSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.progressPercentage / 100.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final v = _controller.value;
              // Render as spinner (i.e. indeterminate value) when complete instead of being stuck at full circle.
              return CircularProgressIndicator(value: v > .99 ? null : v);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
