import 'package:flutter/material.dart';
import '../../helpers/theme_helpers.dart';

class RoundedGradientBorder extends StatelessWidget {
  RoundedGradientBorder({required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(ThemeHelpers.accentColor),
        border: Border.all(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: child,
    );
  }
}
