import 'dart:math';
import 'package:photogalery/pages/address.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogalery/pages/button/button.dart';
import 'package:photogalery/pages/card.dart';
import 'package:photogalery/pages/formfield.dart';

import 'package:intl/intl.dart';
import '../Serivce/firebase_attach.dart';

import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photogalery/Serivce/firebase_attach.dart';
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
  final FirebaseFirestore _db = FirebaseFirestore.instance;
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
              child: Center(
                  child: AlertDialog(
            contentPadding: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            title: Center(
                child: Text("Confirm",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500))),
            content: Container(
              width: 300,
              margin: const EdgeInsets.all(14),
              child: Text("Sure you want to delete the selected photo?",
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(20),
                child: Table(columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                }, children: <TableRow>[
                  TableRow(children: <Widget>[
                    Container(
                        height: 36.43,
                        padding: EdgeInsets.only(top: 10, left: 15, right: 12),
                        child: CustomButton(
                          onpressed: () => Navigator.pop(context),
                          title: 'CANCEL',
                        )),
                    TableCell(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 15),
                        child: CustomButton(
                          title: 'DELETE',
                          onpressed: () async {
                            await _collection.doc(AppGalleryid).delete();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ])
                ]),
              ),
            ],
          )));
        });
  }

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
                            var formattedDate =
                                DateFormat('dd MMMM, yyyy').format(date);
                            final AppGallery photo =
                                AppGallery.fromDocumentSnapshot(documentSnapshot
                                    as DocumentSnapshot<Map<String, dynamic>>);

                            return IMAGEWidget(
                              photogallery: photo,
                              Ondeletepressed: () => _deletephoto,
                              Onlikepressed: () => _update,
                              imageheight: 200,
                              imagewidth: 200,
                              imagefit: StackFit.expand,
                              boxfit: BoxFit.cover,
                              formatetime: '$formattedDate',
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
