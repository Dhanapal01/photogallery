import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    super.key,
    required this.title,
    this.textcolor,
    required this.onpressed,
  });

  final String title;
  Color? textcolor;

  TextStyle titlestyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final Function() onpressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orange)),
        onPressed: widget.onpressed,
        child: Text(
          widget.title,
          style: widget.titlestyle,
        ));
  }
}
