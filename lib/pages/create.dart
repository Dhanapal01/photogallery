import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:photogalery/pages/button/button.dart';
import 'package:photogalery/pages/formfield.dart';

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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.only(bottom: 267),
      child: Center(
          child: await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: Container(
                  child: Center(
                      child: Text(
                'Add Photo',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ))),
              content: Form(
                key: _formkey,
                child: Container(
                  width: 326,
                  margin: EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child:
                            Table(columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                          3: FlexColumnWidth(),
                        }, children: <TableRow>[
                          TableRow(children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 1),
                              padding: EdgeInsets.only(right: 1),
                              child: Text(
                                "Photographer name ",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                            TableCell(
                                child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    width: 148,
                                    height: 31,
                                    child: formfield(
                                        controller: _namecontroller,
                                        hinttext: 'Enter Text')))
                          ]),
                          TableRow(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 12.5),
                              margin: const EdgeInsets.only(top: 30),
                              child: Text(
                                "Image Url ",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  width: 148,
                                  height: 31,
                                  child: Center(
                                      child: formfield(
                                          controller: _photoURLcontroller,
                                          hinttext: 'Enter Text'))),
                            )
                          ]),
                          TableRow(children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 5, right: 12.5),
                              margin: const EdgeInsets.only(top: 28),
                              child: Text(
                                "Description ",
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                  margin: const EdgeInsets.only(top: 21),
                                  height: 31,
                                  width: 148,
                                  child: Center(
                                      child: formfield(
                                          controller: _descriptioncontroller,
                                          hinttext: 'Enter Text'))),
                            )
                          ]),
                          TableRow(
                            children: <Widget>[
                              Center(
                                  child: Container(
                                      width: 119.83,
                                      height: 36.43,
                                      margin: const EdgeInsets.only(
                                          top: 35, left: 38, right: 10),
                                      child: CustomButton(
                                          title: "CANCEL",
                                          onpressed: () async {
                                            Navigator.pop(context);
                                          }))),
                              TableCell(
                                child: Center(
                                  child: Container(
                                    width: 119.83,
                                    height: 36.43,
                                    margin: EdgeInsets.only(
                                      top: 35,
                                      right: 38.45,
                                    ),
                                    child: CustomButton(
                                        title: "ADD",
                                        onpressed: () async {
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
                                ),
                              )
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ));
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
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: AlertDialog(
                    title: const Center(
                        child: Text(
                      "Confirm",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    content: Container(
                      margin: const EdgeInsets.all(20),
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
          scrolledUnderElevation: 2,
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
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.all(25),
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children:
                              streamSnapshot.data!.docs.map((documentSnapshot) {
                            Timestamp t =
                                documentSnapshot['CreatedTime'] as Timestamp;
                            DateTime date = t.toDate();

                            return Container(
                              height: 200,
                              width: 200,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Image.network(
                                      documentSnapshot['photoURL'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 52,
                                          padding: const EdgeInsets.only(
                                              bottom: 200),
                                          color: Colors.transparent
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 9.09, bottom: 8),
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "-by " +
                                          documentSnapshot["Photographername"],
                                      // ignore: prefer_const_constructors
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 28.85, left: 9),
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        documentSnapshot['Description'],
                                        // ignore: prefer_const_constructors
                                        style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                            color: Colors.white),
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 16, right: 12),
                                      constraints: BoxConstraints(
                                        minHeight: 36,
                                      ),
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () =>
                                            _deletephoto(documentSnapshot.id),
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.redAccent,
                                          size: 40,
                                        ),
                                      )),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.only(
                                        bottom: 11, left: 9),
                                    child: Text(
                                      '${date.day} ${_numbertomonthmap[date.month]} ${date.year}',
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(
                                        top: 16.44, left: 14.44),
                                    child: IconButton(
                                        constraints:
                                            BoxConstraints(minHeight: 36.67),
                                        onPressed: () =>
                                            _update(documentSnapshot),
                                        icon: Icon(
                                          documentSnapshot["Isliked"]
                                              ? Icons.favorite
                                              : Icons.favorite,
                                          color: documentSnapshot['Isliked']
                                              ? Colors.redAccent
                                              : Colors.white,
                                          size: 40,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )));
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
