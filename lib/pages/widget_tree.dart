import '../pages/auth_page.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/login_register_page.dart';
import '../pages/create_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStatChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CreatePage();
        } else {
          return const RegisterPage();
        }
      },
    );
  }
}
