import 'package:flutter/material.dart';
import 'package:photogalery/pages/create.dart';
import '../model/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCWCNuIU9H5tfA0Xc2MQJ61BFfP4F5qYMs",
          authDomain: "appgallery-cf6d9.firebaseapp.com",
          projectId: "appgallery-cf6d9",
          storageBucket: "appgallery-cf6d9.appspot.com",
          messagingSenderId: "871301741064",
          appId: "1:871301741064:web:6ded57a6b31efcd4a66fbd",
          measurementId: "G-RT3M2KC29T"));
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
          primarySwatch: Colors.green,
        ),
        debugShowCheckedModeBanner: false,
        home: createpage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              )),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'nothing to show',
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
