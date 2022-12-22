import 'package:flutter/material.dart';
import '../../helpers/theme_helpers.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        text,
        style: const TextStyle(
            color: Color(ThemeHelpers.primaryColor),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'OpenSans'),
      ),
    );
  }
}
