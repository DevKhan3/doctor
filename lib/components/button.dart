
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  late Widget buttonTitle;
  late VoidCallback onPressed;
  Color? backgroundColor;

  ButtonWidget(
      {super.key,
        required this.buttonTitle,
        required this.onPressed,
        this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        onPressed: onPressed,
        child: buttonTitle,
      ),
    );
  }
}
