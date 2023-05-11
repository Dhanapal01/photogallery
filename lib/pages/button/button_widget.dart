import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
@immutable
class CustomButton extends StatefulWidget {
  CustomButton({
    super.key,
    required this.title,
    required this.textcolor,
    required this.onPressed,
    th
  });

  final String title;
 final Color textcolor;

 

  final Function() onPressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  titlestyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.orange)),
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: widget.titlestyle,
        ));
  }
}
