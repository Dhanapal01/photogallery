import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    super.key,
    required this.title,
    this.textColor,
    required this.onPressed,
  });

  final String title;
  Color? textColor;

  TextStyle titleStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final Function() onPressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orange)),
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: widget.titleStyle,
        ));
  }
}
