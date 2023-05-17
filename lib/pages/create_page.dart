import 'dart:js_util';
import 'dart:math';
import 'package:collection/collection.dart';
import '../pages/address_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/button/button_widget.dart';
import 'card_page.dart';
import '../pages/form_field.dart';
import '../pages/sort_list.dart';
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
  final CollectionReference _collect =
      FirebaseFirestore.instance.collection("AppGallery");

  late Stream<QuerySnapshot<Map<String, dynamic>>> _collection;
  List<String> items = <String>[
    UserInput.Photographername,
    UserInput.CreatedTime,
    UserInput.Isliked,
  ];
  List<String> item1 = (<String>[SelectedList.liked, SelectedList.unLiked]);
  List<String> filterList = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoURLController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Timestamp t = Timestamp.now();
  late bool isLiked = false;
  final TextEditingController _searchController = TextEditingController();

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
      print(_nameController);
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

  List name = [];
  void sortFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('AppGallery')
        .orderBy('Photographername', descending: true)
        .get();
    setState(() {
      name = result.docs.map((e) => e.data()).toList();
    });
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
    const all = true;

    List<String> lists = [];

    String? dropDownValue = UserInput.Photographername;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 2,
          title: Text(
            'Photo Gallery',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            Wrap(
              children: [
                Container(),
                SizedBox(
                  child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 30,
                      width: 300,
                      child: TextField(
                        onChanged: (values) {},
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            icon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.all(10),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid),
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            iconColor: Colors.white),
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ],
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return items
                    .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                    .toList();
              },
              initialValue: dropDownValue,
              onSelected: (value) {
                if (value == dropDownValue) {
                  _collection = FirebaseFirestore.instance
                      .collection("AppGallery")
                      .orderBy(
                        "Photographername",
                      )
                      .snapshots();
                  setState(() {});
                }
                if (value == UserInput.CreatedTime) {
                  _collection = FirebaseFirestore.instance
                      .collection("AppGallery")
                      .orderBy("CreatedTime")
                      .snapshots();
                  setState(() {});
                }
                if (value == UserInput.Isliked) {
                  _collection = FirebaseFirestore.instance
                      .collection("AppGallery")
                      .orderBy("Isliked", descending: true)
                      .snapshots();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.sort),
            ),
            PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == SelectedList.all) {
                    for (var i = 0; i < item1.length; i++) {
                      if (filterList.contains(item1[i])) {
                        filterList.remove(item1[i]);
                        _collection = FirebaseFirestore.instance
                            .collection("AppGallery")
                            .where(
                              "Isliked",
                            )
                            .snapshots();
                        setState(() {});
                        print("remove");
                      } else {
                        filterList.add(item1[i]);
                        _collection = FirebaseFirestore.instance
                            .collection("AppGallery")
                            .where(
                              "Isliked",
                            )
                            .snapshots();
                        setState(() {});
                        print("add");
                      }
                    }
                  } else {
                    if (filterList.contains(value)) {
                      filterList.remove(value);
                      _collection = FirebaseFirestore.instance
                          .collection("AppGallery")
                          .where("Isliked", isEqualTo: value)
                          .snapshots();
                      print("remove $value");
                    } else {
                      filterList.add(value);
                      print("add $value");
                      _collection = FirebaseFirestore.instance
                          .collection("AppGallery")
                          .where(
                            "Isliked",
                            isEqualTo: true,
                          )
                          .snapshots();
                      setState(() {});
                      print("add");
                    }
                  }
                },
                icon: Icon(Icons.filter_list),
                itemBuilder: ((context) {
                  Function deepEq = const DeepCollectionEquality().equals;
                  return <PopupMenuEntry<String>>[
                    CheckedPopupMenuItem(
                      checked: deepEq(filterList, item1),
                      value: SelectedList.all,
                      child: Text(SelectedList.all),
                    ),
                    ...item1
                        .map((e) => CheckedPopupMenuItem(
                              checked: filterList.contains(e),
                              value: e,
                              child: Text(e),
                            ))
                        .toList()
                  ];
                })),
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
