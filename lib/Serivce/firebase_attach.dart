import '../model/Response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _collection =
    FirebaseFirestore.instance.collection('AppGallery');

class firebase {
  static Future<Response> addAppGallery({
    required String name,
    required String photoURL,
    required String description,
  }) async {
    Response response = Response();
    DocumentReference documentReference = _collection.doc();
    Map<String, dynamic> data = <String, dynamic>{
      "Photographername": name,
      "photoURL": photoURL,
      "Description": description,
    };
    var result = await documentReference.set(data).whenComplete(() {
      response.code = 200;
      response.message = "successfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }
}
