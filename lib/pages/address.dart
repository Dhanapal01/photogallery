import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AppGallery {
  final String Photgraphername;
  final String PhotoURL;
  final String Description;
  final Timestamp CreatedTime;
  final bool Isliked;
  AppGallery({
    required this.Photgraphername,
    required this.PhotoURL,
    required this.Description,
    required this.CreatedTime,
    required this.Isliked,
  });
  Map<String, dynamic> toMap() {
    return {
      'Photographername': Photgraphername,
      'PhotoURL': PhotoURL,
      'Description': Description,
      'CreatedTime': CreatedTime,
      'Isliked': Isliked
    };
  }

  AppGallery.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : Photgraphername = doc.data()!['Photographername'],
        PhotoURL = doc.data()!['photoURL'],
        Description = doc.data()!['Description'],
        CreatedTime = doc.data()!['CreatedTime'],
        Isliked = doc.data()!['Isliked'];
}
