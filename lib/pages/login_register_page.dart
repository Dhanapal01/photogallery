import 'dart:core';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photogalery/pages/button/button_widget.dart';
import 'package:photogalery/pages/form_field.dart';
import '../pages/auth_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorMessage = '';
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 5));
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      Future.delayed(Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 5));
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
    isLoading = false;
  }

  Widget _title() {
    return const Text("Login Page");
  }

  Widget _entryField(String title, TextEditingController controller) {
    return FormfieldPage(
      controller: controller,
      hinttext: title,
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Humm ? $errorMessage',
      style: const TextStyle(color: Colors.redAccent),
    );
  }

  Widget _submitButton() {
    return CustomButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        title: isLogin ? 'Login' : 'Register');
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: _entryField('email', _emailController),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: _entryField('password', _passwordController),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: _errorMessage(),
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : _submitButton()),
              _loginOrRegisterButton(),
            ]),
      ),
    );
  }
}
