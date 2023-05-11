import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class FormfieldPage extends StatelessWidget {
  FormfieldPage(
      {super.key,
      this.txtStyle,
      required this.controller,
      this.validator,
      required this.hinttext});

  TextStyle? txtStyle;
  final String hinttext;
  final TextEditingController controller;
  final Function()? validator;

  @override
  Widget build(BuildContext context) {
    txtStyle = GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400);

    return TextFormField(
      style: txtStyle,
      controller: controller,
      autofocus: true,
      validator: ((value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
      }),
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: txtStyle,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1))),
    );
  }
}
