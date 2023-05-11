import 'dart:html';

import '../pages/address_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/button/button_widget.dart';
import 'card_page.dart';
import '../pages/form_field.dart';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreatePage();
  }
}

class _CreatePage extends State<CreatePage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _collection;
  List<String> items = <String>['CreatedTime', 'PhotographerName', 'Isliked'];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoURLController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Timestamp t = Timestamp.now();
  late bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _collection =
        FirebaseFirestore.instance.collection('AppGallery').snapshots();
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['Photographername'];
      _photoURLController.text = documentSnapshot['photoURL'];
      _descriptionController.text = documentSnapshot['Description'];
      isLiked = documentSnapshot["Isliked"];
    }
    final formkey = GlobalKey<FormState>();
    Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.only(bottom: 267),
      child: Center(
          child: await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(12),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: Center(
                  child: Text(
                'Add Photo',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              )),
              content: Form(
                key: formkey,
                child: Container(
                  width: 326,
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Table(columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FlexColumnWidth(),
                      }, children: <TableRow>[
                        TableRow(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 20, left: 1),
                            padding: const EdgeInsets.only(right: 1),
                            child: Text(
                              "Photographer name ",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
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
                                  child: FormfieldPage(
                                      controller: _nameController,
                                      hinttext: 'Enter Text')))
                        ]),
                        TableRow(children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.only(left: 5, right: 12.5),
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
                                    child: FormfieldPage(
                                        controller: _photoURLController,
                                        hinttext: 'Enter Text'))),
                          )
                        ]),
                        TableRow(children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.only(left: 5, right: 12.5),
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
                                    child: FormfieldPage(
                                        controller: _descriptionController,
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
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        }))),
                            TableCell(
                              child: Center(
                                child: Container(
                                  width: 119.83,
                                  height: 36.43,
                                  margin: const EdgeInsets.only(
                                    top: 35,
                                    right: 38.45,
                                  ),
                                  child: CustomButton(
                                      title: "ADD",
                                      onPressed: () async {
                                        final String name =
                                            _nameController.text;
                                        final String photoURL =
                                            _photoURLController.text;
                                        final String description =
                                            _descriptionController.text;

                                        DateTime date = t.toDate();
                                        bool isLiked = false;
                                        if (formkey.currentState!.validate()) {
                                          if (action == 'create') {
                                            await FirebaseFirestore.instance
                                                .collection('AppGallery')
                                                .add({
                                              "Photographername":
                                                  name.toUpperCase(),
                                              "photoURL": photoURL,
                                              "Description": description,
                                              'CreatedTime': date,
                                              "Isliked": isLiked,
                                            });
                                            _nameController.text = '';
                                            _photoURLController.text = '';
                                            _descriptionController.text = '';
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
                      ])
                    ],
                  ),
                ),
              ));
        },
      )),
    );
  }

  Future<void> _update(AppGallery appGallery) async {
    appGallery.ref.update({'Isliked': !appGallery.isLiked});
  }

  Future<void> _deletePhoto(AppGallery appGallery) async {
    showDialog(
        useRootNavigator: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Center(
              child: Center(
                  child: AlertDialog(
            contentPadding: const EdgeInsets.all(8),
            shape: const RoundedRectangleBorder(
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
                margin: const EdgeInsets.all(20),
                child: Table(columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                }, children: <TableRow>[
                  TableRow(children: <Widget>[
                    Container(
                        height: 36.43,
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 12),
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context),
                          title: 'CANCEL',
                        )),
                    TableCell(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, right: 15),
                        child: CustomButton(
                          title: 'DELETE',
                          onPressed: () async {
                            appGallery.ref.delete();
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String? _dropdownValue = 'CreatedTime';
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
            Container(
                child: PopupMenuButton(
              itemBuilder: (context) {
                return items
                    .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                    .toList();
              },
              onSelected: (value) {
                if (value == 'CreatedTime') {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.sort),
            ))
          ],
        ),
        body: StreamBuilder(
            stream: _collection,
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.all(25),
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children:
                              streamSnapshot.data!.docs.map((documentSnapshot) {
                            Timestamp t =
                                documentSnapshot['CreatedTime'] as Timestamp;
                            DateTime date = t.toDate();
                            var Formateddate =
                                DateFormat('dd MMMM, yyyy').format(date);
                            final AppGallery photo =
                                AppGallery.fromDocumentSnapshot(documentSnapshot
                                    as DocumentSnapshot<Map<String, dynamic>>);

                            return CardWidget(
                              photoGallery: photo,
                              onDeletePressed: _deletePhoto,
                              onLikePressed: _update,
                              imageHeight: 200,
                              imageWidth: 200,
                              imageFit: StackFit.expand,
                              boxFit: BoxFit.cover,
                              formatTime: Formateddate,
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
