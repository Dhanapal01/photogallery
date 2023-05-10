import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogalery/pages/address.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

addAppGallery(AppGallery appGalleryData) async {
  await _db.collection('AppGallery').add(appGalleryData.toMap());
}
