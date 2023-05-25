import 'package:flutter/material.dart';
import 'package:photogalery/pages/create_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photogalery/pages/widget_tree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCWCNuIU9H5tfA0Xc2MQJ61BFfP4F5qYMs",
            authDomain: "appgallery-cf6d9.firebaseapp.com",
            projectId: "appgallery-cf6d9",
            storageBucket: "appgallery-cf6d9.appspot.com",
            messagingSenderId: "871301741064",
            appId: "1:871301741064:web:6ded57a6b31efcd4a66fbd",
            measurementId: "G-RT3M2KC29T"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Photo Galery',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Color.fromRGBO(74, 76, 80, 1)),
        ),
        debugShowCheckedModeBanner: false,
        home: const WidgetTree());
  }
}
