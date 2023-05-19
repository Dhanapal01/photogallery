import 'package:cloud_firestore/cloud_firestore.dart';

class AppGallery {
  final String photgrapherName;
  final String photoURL;
  final String description;
  final DateTime createdTime;
  final bool isLiked;
  final DocumentReference ref;
  AppGallery({
    required this.ref,
    required this.photgrapherName,
    required this.photoURL,
    required this.description,
    required this.createdTime,
    required this.isLiked,
  });
  Map<String, dynamic> toMap() {
    return {
      'Photographername': photgrapherName,
      'PhotoURL': photoURL,
      'Description': description,
      'CreatedTime': createdTime,
      'Isliked': isLiked
    };
  }

  AppGallery.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : photgrapherName = doc.data()!['Photographername'],
        photoURL = doc.data()!['photoURL'],
        description = doc.data()!['Description'],
        createdTime = doc.data()!['CreatedTime'].toDate(),
        isLiked = doc.data()!['Isliked'],
        ref = doc.reference;
}
