import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppGallery with ChangeNotifier {
  String? name;
  String? photoURL;
  String? description;
  Timestamp? CreatedTime;
  bool? Isliked;
  AppGallery({
    this.name,
    this.photoURL,
    this.description,
    this.CreatedTime,
    this.Isliked = false,
  });
  void toggleviewfav() {
    Isliked = !Isliked!;
    notifyListeners();
  }
}
