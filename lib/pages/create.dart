import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

import '../Serivce/firebase_attach.dart';
import '../model/text.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _namecontroller.text = documentSnapshot['Photographername'];
      _photoURLcontroller.text = documentSnapshot['photoURL'];
      _descriptioncontroller.text = documentSnapshot['Description'];
      Isliked = documentSnapshot["Isliked"];
    }
    final _formkey = GlobalKey<FormState>();
    Container(
      child: Center(
          child: await showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: AlertDialog(
                  title: Center(
                      child: Text(
                    'Add Photo',
                    style: GoogleFonts.poppins(color: Colors.black),
                  )),
                  content: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Table(columnWidths: <int, TableColumnWidth>{
                            0: FlexColumnWidth(),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth()
                          }, children: <TableRow>[
                            TableRow(children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  "Photographer name ",
                                  style: GoogleFonts.poppins(fontSize: 10),
                                ),
                              ),
                              TableCell(
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 8, bottom: 8, right: 3),
                                      width: 25,
                                      height: 30,
                                      child: TextFormField(
                                          style:
                                              GoogleFonts.poppins(fontSize: 10),
                                          autofocus: true,
                                          controller: _namecontroller,
                                          validator: ((value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'This field is required';
                                            }
                                          }),
                                          decoration: InputDecoration(
                                              hintText: "Enter Text",
                                              border: OutlineInputBorder())))),
                            ]),
                            TableRow(children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Image Url ",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 25,
                                    height: 30,
                                    child: Center(
                                        child: TextFormField(
                                            style: GoogleFonts.poppins(
                                                fontSize: 10),
                                            controller: _photoURLcontroller,
                                            validator: ((value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'This field is required';
                                              }
                                            }),
                                            decoration: InputDecoration(
                                                hintText: "Enter Text",
                                                border:
                                                    OutlineInputBorder())))),
                              )
                            ]),
                            TableRow(children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Description ",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 30,
                                    height: 25,
                                    child: Center(
                                        child: TextFormField(
                                            style: GoogleFonts.poppins(
                                                fontSize: 10),
                                            controller: _descriptioncontroller,
                                            validator: ((value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'This field is required';
                                              }
                                            }),
                                            decoration: InputDecoration(
                                                hintText: "Enter Text",
                                                border:
                                                    OutlineInputBorder())))),
                              )
                            ]),
                            TableRow(
                              children: <Widget>[
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: ElevatedButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.orangeAccent)),
                                            onPressed: () => Navigator.pop(
                                                  context,
                                                ),
                                            child: Container(
                                              child: const Text('cancel'),
                                            )))),
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      color: Colors.orangeAccent,
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.orangeAccent)),
                                          child: Container(
                                            child: Text(
                                              'Add',
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final String name =
                                                _namecontroller.text;
                                            final String photoURL =
                                                _photoURLcontroller.text;
                                            final String description =
                                                _descriptioncontroller.text;

                                            DateTime date = t.toDate();
                                            bool Isliked = false;
                                            if (_formkey.currentState!
                                                .validate()) {
                                              if (action == 'create') {
                                                await _collection.add({
                                                  "Photographername":
                                                      name.toUpperCase(),
                                                  "photoURL": photoURL,
                                                  "Description": description,
                                                  'CreatedTime': date,
                                                  "Isliked": Isliked,
                                                });
                                                _namecontroller.text = '';
                                                _photoURLcontroller.text = '';
                                                _descriptioncontroller.text =
                                                    '';
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
                                  ),
                                )
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  )));
        },
      )),
    );
  }

  @override
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    documentSnapshot!.reference
        .update({'Isliked': !documentSnapshot['Isliked']});
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Photo Gallery',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                )),
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort))
          ],
        ),
        body: StreamBuilder(
            stream: _collection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Container(
                    padding: EdgeInsets.all(25.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
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

                              return Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Card(
                                    elevation: 20,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Container(
                                            child: Image.network(
                                              documentSnapshot['photoURL'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                  bottom: 200),
                                              color: Colors.transparent
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              '-by ' +
                                                  documentSnapshot[
                                                      'Photographername'],
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
                                              child: Text(
                                                  documentSnapshot[
                                                      'Description'],
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
                                                onPressed: () => _deletephoto(
                                                    documentSnapshot.id),
                                                icon: const Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.redAccent,
                                                ),
                                              )),
                                          Container(
                                            alignment: Alignment.bottomLeft,
                                            padding: EdgeInsets.only(
                                                bottom: 5, left: 10),
                                            child: Text(
                                              '${date.day} ${_numbertomonthmap[date.month]} ${date.year}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: IconButton(
                                                onPressed: () =>
                                                    _update(documentSnapshot),
                                                icon: Icon(
                                                  documentSnapshot["Isliked"]
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            })));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => _create(),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
