import 'package:flutter/material.dart';
import '../../helpers/theme_helpers.dart';

class CustomButton extends StatefulWidget {
  CustomButton({required this.action, required this.text});
  void Function()? action;
  String text;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.action,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(300, 45)),
        backgroundColor: MaterialStateProperty.all(
          const Color(ThemeHelpers.primaryColor),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
