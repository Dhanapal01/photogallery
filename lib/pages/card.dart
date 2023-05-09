import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IMAGEWidget extends StatefulWidget {
  final String text;
  final double radius;

  final Function onPressed;
  final Function onPressed1;

  IMAGEWidget({
    super.key,
    required this.text,
    required this.radius,
    required this.onPressed,
    required this.onPressed1,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
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
State<IMAGEWidget> createState() => _IMAGEWidgetState();

class _IMAGEWidgetState extends State<IMAGEWidget> {
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
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('AppGallery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                        padding:
                                            const EdgeInsets.only(bottom: 200),
                                        color:
                                            Colors.transparent.withOpacity(0.5),
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
                                      onPressed:
                                          widget.onPressed(documentSnapshot.id),
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
                                          widget.onPressed1(documentSnapshot),
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
    );
  }
}
