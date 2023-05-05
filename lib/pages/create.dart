import 'dart:html';

import '../Serivce/firebase_attach.dart';
import '../model/text.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';

class createpage extends StatefulWidget {
  const createpage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _createpage();
  }
}

class _createpage extends State<createpage> {
  late DocumentReference likesref;

  late String uid;
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('AppGallery');
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _photoURLcontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  late Timestamp t = Timestamp.now();
  late bool Isliked = false;
  late int _likescount = 0;

  var result;

  var count;

  @override
  void initState() {
    super.initState();
  }

  void toggleviewfav() {
    setState(() {
      Isliked = true;
      _likescount += Isliked ? 1 : -1;
    });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _namecontroller.text = documentSnapshot['Photographername'];
      _photoURLcontroller.text = documentSnapshot['photoURL'];
      _descriptioncontroller.text = documentSnapshot['Description'];
    }
    final _formkey = GlobalKey<FormState>();

    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
            padding: const EdgeInsets.all(60),
            child: AlertDialog(
                title: const Center(child: Text('details')),
                content: Form(
                  key: _formkey,
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            autofocus: true,
                            controller: _namecontroller,
                            validator: ((value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                            }),
                            decoration:
                                const InputDecoration(labelText: 'name'),
                          ),
                          TextFormField(
                              controller: _photoURLcontroller,
                              validator: ((value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                              }),
                              decoration: InputDecoration(
                                  labelText: ("PhotographerName :"),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: "Name",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                          TextFormField(
                            controller: _descriptioncontroller,
                            validator: ((value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required';
                              }
                            }),
                            decoration:
                                const InputDecoration(labelText: 'description'),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Stack(children: <Widget>[
                            Container(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                  autofocus: true,
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    final String name = _namecontroller.text;
                                    final String photoURL =
                                        _photoURLcontroller.text;
                                    final String description =
                                        _descriptioncontroller.text;

                                    DateTime date = t.toDate();
                                    if (_formkey.currentState!.validate()) {
                                      if (action == 'create') {
                                        await _collection.add({
                                          "Photographername":
                                              name.toUpperCase(),
                                          "photoURL": photoURL,
                                          "Description": description,
                                          'CreatedTime': date,
                                        });

                                        _namecontroller.text = '';
                                        _photoURLcontroller.text = '';
                                        _descriptioncontroller.text = '';
                                        t;

                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "created successfully")));
                                      }
                                    }
                                  }),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Container(
                                child: TextButton(
                                    onPressed: () => Navigator.pop(
                                          context,
                                        ),
                                    child: Container(
                                      child: const Text('cancel'),
                                    )))
                          ]),
                        ],
                      ),
                    ),
                  ),
                )));
      },
    );
  }

  Future<void> _deletephoto(String AppGalleryid) async {
    showDialog(
        useRootNavigator: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Center(
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: AlertDialog(
                    title: const Center(
                        child: Text(
                      "Confirm",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    content: Container(
                      margin: EdgeInsets.all(20),
                      child: const Text(
                          "Sure you want to delete the selected photo?"),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await _collection.doc(AppGalleryid).delete();
                            Navigator.pop(context);
                          },
                          child: const Text("DELETE")),
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("CANCEL"))
                    ],
                  ))));
        });
  }

  final _numbertomonthmap = {
    1: "Jan",
    2: "Feb",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var time = DateTime.now();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photo Gallery'),
        ),
        body: StreamBuilder(
            stream: _collection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Container(
                    padding: EdgeInsets.all(25.0),
                    child: GridView.builder(
                        padding: const EdgeInsets.all(25.0),
                        itemCount: streamSnapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 20.0,
                        ),
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                          Timestamp t =
                              documentSnapshot['CreatedTime'] as Timestamp;
                          DateTime date = t.toDate();
                          bool Isliked = documentSnapshot['Isliked'];
                          return Card(
                            elevation: 40,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Image.network(
                                      documentSnapshot['photoURL'],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(110),
                                    color: Colors.transparent.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '-by ' +
                                        documentSnapshot['Photographername'],
                                    // ignore: prefer_const_constructors
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 28, left: 10),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(documentSnapshot['Description'],
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ))),
                                Container(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () =>
                                          _deletephoto(documentSnapshot.id),
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.redAccent,
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(bottom: 5, left: 10),
                                  child: Text(
                                    '${date.day} ${_numbertomonthmap[date.month]} ${date.year}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                      onPressed: toggleviewfav,
                                      icon: Icon(
                                        Isliked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Isliked ? Colors.red : null,
                                      )),
                                ),
                              ],
                            ),
                          );
                        }));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  handleLikedpost() {
    Icon(
      Icons.favorite,
    );
  }
}
