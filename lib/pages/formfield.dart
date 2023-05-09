import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class formfield extends StatelessWidget {
  formfield(
      {super.key,
      this.txtstyle,
      required this.controller,
      this.validator,
      required this.hinttext});

  TextStyle? txtstyle;
  final String hinttext;
  final TextEditingController controller;
  final Function()? validator;

  @override
  Widget build(BuildContext context) {
    txtstyle = GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400);

    return TextFormField(
      style: txtstyle,
      controller: controller,
      autofocus: true,
      validator: ((value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      }),
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: txtstyle,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1))),
    );
  }
}
