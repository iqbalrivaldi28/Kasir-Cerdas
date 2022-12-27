import 'package:flutter/material.dart';

class LongFab extends StatelessWidget {
  const LongFab({
    Key? key,
    this.onTap,
    this.isVisible = true,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget child;
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton.extended(
        onPressed: onTap,
        extendedPadding: EdgeInsets.zero,
        label: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
