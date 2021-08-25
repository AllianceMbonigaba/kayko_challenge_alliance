import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference createRef(colectionPath) {
    return _firestore.collection(colectionPath);
  }

  //setdoc filed with merge option
  Future setDocFieldMerge(String colection,id, data) async {
    return await this.createRef(colection).doc(id).set(data, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> get orders {
    return createRef('orders').snapshots();
  }

}
