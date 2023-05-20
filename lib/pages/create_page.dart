import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photogalery/pages/login_page.dart';
import 'package:photogalery/pages/login_register_page.dart';

import 'auth_page.dart';
import 'modal_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/button/button_widget.dart';
import 'card_page.dart';
import '../pages/form_field.dart';
import '../pages/sort_list.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePage extends StatefulWidget {
  CreatePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreatePage();
  }
}

class _CreatePage extends State<CreatePage> {
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Login Page");
  }

  Widget _userUid() {
    return Text(user?.email ?? "User email");
  }

  Widget _signOutButton() {
    return CustomButton(
        onPressed: () {
          signOut();
          Navigator.pop(context);
        },
        title: "SignOut");
  }

  List<AppGallery> photoList = [];

  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
  late Stream<QuerySnapshot<Object?>> _collection;
  List<String> items = <String>[
    UserInput.photographerName,
    UserInput.createdTime,
    UserInput.isLiked,
  ];
  List<String> item1 = [SelectedList.liked, SelectedList.unLiked];
  List<String> filterList = [];
  String query = '';
  late List<AppGallery> photos = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoURLController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Timestamp t = Timestamp.now();
  late bool isLiked = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collection =
        FirebaseFirestore.instance.collection('AppGallery').snapshots();
    _listPhoto();
    photos = photoList;
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
                                            _controller.text = '';

                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            // ignore: use_build_context_synchronously
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

  Future<void> authSignOut() async {
    await showDialog(
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
            title: Center(child: _title()),
            content: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: _userUid()),
                    _signOutButton(),
                  ]),
            ),
          )));
        });
  }

  searchPhoto(String query) {
    final photosList = photoList.where((AppGallery) {
      final photographername = AppGallery.photgrapherName.toLowerCase();
      final input = query.toLowerCase();
      return photographername.contains(input);
    }).toList();
    setState(() => photos = photosList);
  }

  _listPhoto() {
    _collection.listen((snapshots) {
      photoList.clear();
      snapshots.docs.forEach((document) {
        AppGallery photo = AppGallery.fromDocumentSnapshot(
            document as DocumentSnapshot<Map<String, dynamic>>);

        photoList.add(photo);
      });
      setState(() {
        searchPhoto(query);
      });
    });
  }

//filter list
  _filterFun() {
    Query q = FirebaseFirestore.instance.collection("AppGallery");

    if (unOrdDeepEq(filterList, item1)) {
      q = q.where(
        "Isliked",
      );
    } else {
      if (filterList.contains(SelectedList.liked)) {
        q = q.where("Isliked", isEqualTo: true);
      }
      if (filterList.contains(SelectedList.unLiked)) {
        q = q.where('Isliked', isEqualTo: false);
      }
    }
    setState(() {});
    _collection = q.snapshots();
    _listPhoto();
  }

  Future<void> _update(AppGallery appGallery) async {
    appGallery.ref.update({'Isliked': !appGallery.isLiked});
    _listPhoto();
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
                            _listPhoto();
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
    String? dropDownValue = UserInput.photographerName;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Photo Gallery',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            actions: [
              Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 30,
                  width: 150,
                  child: TextField(
                    onChanged: searchPhoto,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          iconSize: 15,
                          icon: const Icon(Icons.cancel_sharp),
                          onPressed: () {
                            _controller.clear();
                            searchPhoto(query);

                            FocusScope.of(context).requestFocus();
                          },
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        iconColor: Colors.white),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )),
              PopupMenuButton(
                itemBuilder: (context) {
                  return items
                      .map((e) =>
                          PopupMenuItem<String>(value: e, child: Text(e)))
                      .toList();
                },
                initialValue: dropDownValue,
                onSelected: (value) {
                  Query q = FirebaseFirestore.instance.collection("AppGallery");
                  if (value == dropDownValue) {
                    q = q.orderBy(
                      "Photographername",
                    );
                  }
                  if (value == UserInput.createdTime) {
                    q = q.orderBy("CreatedTime");
                  }
                  if (value == UserInput.isLiked) {
                    q = q.orderBy("Isliked", descending: true);
                  }
                  _collection = q.snapshots();
                  setState(() {
                    _listPhoto();
                  });
                },
                icon: const Icon(Icons.sort),
              ),
              PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == SelectedList.all) {
                      for (var i = 0; i < item1.length; i++) {
                        if (filterList.contains(item1[i])) {
                          filterList.remove(item1[i]);
                        } else {
                          filterList.add(item1[i]);
                        }
                      }
                    } else {
                      if (filterList.contains(value)) {
                        filterList.remove(value);
                      } else {
                        filterList.add(value);
                      }
                    }
                    _filterFun();
                  },
                  icon: const Icon(Icons.filter_list),
                  itemBuilder: ((context) {
                    Function unOrdDeepEq =
                        const DeepCollectionEquality.unordered().equals;
                    return <PopupMenuEntry<String>>[
                      CheckedPopupMenuItem(
                        checked: unOrdDeepEq(filterList, item1),
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
              IconButton(
                  onPressed: () {
                    authSignOut();
                  },
                  icon: Icon(Icons.logout_outlined))
            ],
          ),
          body: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
            return Container(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.all(25),
                      child: Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: photos.map((photos) {
                          DateTime date = photos.createdTime;
                          //
                          var formatedDate =
                              DateFormat('dd MMMM, yyyy').format(date);
                          if (constraints.maxWidth > 500) {
                            double width = 200;
                          } else {
                            constraints.maxWidth;
                          }

                          return CardWidget(
                            photoGallery: photos,
                            onDeletePressed: _deletePhoto,
                            onLikePressed: _update,
                            imageHeight: 200,
                            imageWidth: constraints.maxWidth > 500
                                ? 200
                                : constraints.maxWidth,
                            imageFit: StackFit.expand,
                            boxFit: BoxFit.cover,
                            formatTime: formatedDate,
                          );
                        }).toList(),
                      ))),
            );
          }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () => _create(),
            child: const Icon(
              Icons.add,
            ),
          )),
    );
  }
}
