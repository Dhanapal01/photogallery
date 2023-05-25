import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:photogalery/pages/login_register_page.dart';
import 'package:file_picker/file_picker.dart';
import 'auth_page.dart';
import 'model_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/button/button_widget.dart';
import 'card_page.dart';
import '../pages/form_field.dart';
import '../pages/sort_list.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  double _progress = 0.0;
  String? _urlDownload;
  Uint8List? _pickedFile;
  String? _fileName;

  Future<void> _showImagePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'PDF',
        'pdf',
      ],
    );

    _pickedFile = result!.files.first.bytes;
    return;
  }

  Query q = FirebaseFirestore.instance.collection("AppGallery");
  final User? user = Auth().currentUser;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  bool _isLoading = false;
  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });
    await Auth().signOut();
    setState(() {
      _isLoading = false;
    });
  }

  Widget _title() {
    return const Text("LogOut Page");
  }

  Widget _userUid() {
    return Text(user?.email ?? "User email");
  }

  Widget _signOutButton() {
    return CustomButton(
        onPressed: () {
          _signOut();

          Navigator.pop(context);
        },
        title: "SignOut");
  }

  final List<AppGallery> _photoList = [];

  final Function _unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
  late Stream<QuerySnapshot<Object?>> _collection;
  final List<String> _items = <String>[
    UserInput.photographerName,
    UserInput.createdTime,
    UserInput.isLiked,
  ];
  final List<String> _item1 = [SelectedList.liked, SelectedList.unLiked];
  final List<String> _filterList = [];
  final String _query = '';
  late List<AppGallery> _images = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Timestamp t = Timestamp.now();
  bool _isLiked = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _collection =
        FirebaseFirestore.instance.collection('AppGallery').snapshots();
    q = q.where('AddedBy', isEqualTo: uid);
    _collection = q.snapshots();
    _listPhoto();
    _images = _photoList;
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['Photographername'];
      _descriptionController.text = documentSnapshot['Description'];
      _isLiked = documentSnapshot["Isliked"];
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
                              "Image Picker ",
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                          TableCell(
                              child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              top: 14,
                            ),
                            child: IconButton(
                                alignment: Alignment.center,
                                tooltip: "image Upload",
                                color: Colors.black87,
                                icon: const Icon(Icons.photo_album),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            content: Text(
                                                'Please select the image',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.black87,
                                                          offset: Offset
                                                              .fromDirection(3))
                                                    ])),
                                            actions: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: CustomButton(
                                                  onPressed: _showImagePicker,
                                                  title: "Select Photo",
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: CustomButton(
                                                    title: 'Upload',
                                                    onPressed: () async {
                                                      final path =
                                                          'files/$_fileName';
                                                      final ref =
                                                          FirebaseStorage
                                                              .instance
                                                              .ref()
                                                              .child(path);

                                                      UploadTask uploadTask =
                                                          ref.putData(
                                                              _pickedFile!);
                                                      uploadTask.snapshotEvents
                                                          .listen(
                                                              (taskSnapshot) {
                                                        setState(() {
                                                          _progress = ((taskSnapshot
                                                                          .bytesTransferred
                                                                          .toDouble() /
                                                                      taskSnapshot
                                                                          .totalBytes
                                                                          .toDouble()) *
                                                                  100.0)
                                                              .roundToDouble();
                                                        });
                                                      });

                                                      final snapshot =
                                                          await uploadTask
                                                              .whenComplete(
                                                                  () {});
                                                      _urlDownload =
                                                          await snapshot.ref
                                                              .getDownloadURL();

                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "Successfully Uploaded",
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      )));
                                                      return const CircularProgressIndicator();
                                                    }),
                                              ),
                                              Container(
                                                child: _progress > 0
                                                    ? Text("$_progress%")
                                                    : null,
                                              ),
                                              Stack(children: [
                                                Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment: Alignment.center,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: _progress / 100,
                                                      minHeight: 10,
                                                      color: Colors.green,
                                                      semanticsLabel:
                                                          '$_progress%',
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          );
                                        });
                                      }));
                                }),
                          ))
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
                                        top: 35, left: 30, right: 10),
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
                                        final String? photoURL = _urlDownload;
                                        final String description =
                                            _descriptionController.text;
                                        var uid = user!.uid;

                                        DateTime date = t.toDate();
                                        bool isLiked = false;
                                        if (formkey.currentState!.validate()) {
                                          if (action == 'create') {
                                            await FirebaseFirestore.instance
                                                .collection('AppGallery')
                                                .add({
                                              "AddedBy": uid,
                                              "Photographername":
                                                  name.toUpperCase(),
                                              "photoURL": photoURL,
                                              "Description": description,
                                              'CreatedTime': date,
                                              "Isliked": isLiked,
                                            });
                                            _nameController.text = '';
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

  Future<void> _authSignOut() async {
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
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _userUid()),
                    Container(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : _signOutButton(),
                    )
                  ]),
            ),
          )));
        });
    return;
  }

  void _searchPhoto(String query) {
    final photosList = _photoList.where((AppGallery) {
      final photographername = AppGallery.photgrapherName.toLowerCase();
      final input = query.toLowerCase();
      return photographername.contains(input);
    }).toList();

    setState(() => _images = photosList);
    return;
  }

  void _listPhoto() {
    _collection.listen((snapshots) {
      _photoList.clear();
      snapshots.docs.forEach((document) {
        AppGallery photo = AppGallery.fromDocumentSnapshot(
            document as DocumentSnapshot<Map<String, dynamic>>);

        _photoList.add(photo);
      });
      setState(() {
        _searchPhoto(_query);
      });
    });
    return;
  }

//filter list
  void _filterFun() {
    Query q = FirebaseFirestore.instance.collection("AppGallery");

    if (_unOrdDeepEq(_filterList, _item1)) {
      if (_unOrdDeepEq(_filterList, _item1)) {
        q = q.where(
          "Isliked",
        );
      } else {
        q = q.where(
          "Isliked",
        );
      }
    } else {
      if (_filterList.contains(SelectedList.liked)) {
        q = q.where("Isliked", isEqualTo: true);
      }
      if (_filterList.contains(SelectedList.unLiked)) {
        q = q.where('Isliked', isEqualTo: false);
      }
    }

    setState(() {});
    q = q.where('AddedBy', isEqualTo: uid);
    _collection = q.snapshots();
    _listPhoto();
    return;
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
                        height: 38,
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 12),
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
    return;
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
                    onChanged: _searchPhoto,
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
                            _searchPhoto(_query);

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
                  return _items
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
                  q = q.where('AddedBy', isEqualTo: uid);
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
                      for (var i = 0; i < _item1.length; i++) {
                        if (_filterList.contains(_item1[i])) {
                          _filterList.remove(_item1[i]);
                        } else {
                          _filterList.add(_item1[i]);
                        }
                      }
                    } else {
                      if (_filterList.contains(value)) {
                        _filterList.remove(value);
                      } else {
                        _filterList.add(value);
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
                        checked: unOrdDeepEq(_filterList, _item1),
                        value: SelectedList.all,
                        child: Text(SelectedList.all),
                      ),
                      ..._item1
                          .map((e) => CheckedPopupMenuItem(
                                checked: _filterList.contains(e),
                                value: e,
                                child: Text(e),
                              ))
                          .toList()
                    ];
                  })),
              IconButton(
                  onPressed: () {
                    _authSignOut();
                  },
                  icon: const Icon(Icons.logout_outlined))
            ],
          ),
          body: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.all(25),
                    child: Wrap(
                      runSpacing: 20,
                      spacing: 20,
                      children: _images.map((photos) {
                        DateTime date = photos.createdTime;
                        //
                        var formatedDate =
                            DateFormat('dd MMMM, yyyy').format(date);

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
                    )));
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
