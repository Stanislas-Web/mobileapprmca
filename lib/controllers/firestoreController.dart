import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreController {
  final _db = Firestore.instance;

  //CHECK IS DOCUMENT EXIST
  Future<bool> checkIfDocumentExist({collection, userId}) async {
    var fireStoreUser =
        await this.getDocument(collection: collection, doc: userId);
    return fireStoreUser[0] == null ? false : true;
  }

  // GET DOCUMENTS SNAPSHOT
  Future<List<DocumentSnapshot>> getDocuments(collection) async {
    QuerySnapshot snapshot = await _db.collection(collection).getDocuments();
    return snapshot.documents;
  }

  //GET DOCUEMNTS SNAPSHOTS BY ORDER
  Future<List<DocumentSnapshot>> getDocumentByOrder(
      {collection, order, desc}) async {
    QuerySnapshot snapshot = await _db
        .collection(collection)
        .orderBy(order, descending: desc)
        .getDocuments();
    return snapshot.documents;
  }

  //GET SPECIFIC DOCUMENTS
  Future<List> getDocument({collection, doc}) async {
    List _dataDoc = [];
    await _db
        .collection(collection)
        .document(doc)
        .get()
        .then((DocumentSnapshot snapshot) {
      _dataDoc.add(snapshot.data);
    });

    return _dataDoc;
  }

  //DELETE DOCUMENTS
  Future<bool> removeDocument({collection, doc}) async {
    try {
      await _db.collection(collection).document(doc).delete();
      return true;
    } catch (e) {
      print("REMOVE DOCUMENT ERR ${e.toString()}");
      return false;
    }
  }

//GET SPECIFIC DOCUMENTS WITH QUERY WHERE IS EQUAL
  Future<List> queryDocumenWhere(
      {collection, order, desc, where, condition}) async {
    List _dataDoc = [];
    _db
        .collection('comments')
        .orderBy(order, descending: desc)
        .where(where, isEqualTo: condition)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => {
              _dataDoc.add(doc.data),
            }));

    return _dataDoc;
  }

  //POST DOCUMENTS
  Future<bool> insertDocument({collection, doc: '', data}) async {
    try {
      doc == ''
          ? await _db.collection(collection).document().setData(data)
          : await _db.collection(collection).document(doc).setData(data);
      return true;
    } catch (e) {
      print("ERROR INSERTION ${e.toString()}");
      return false;
    }
  }

  //UPDATE DOCUMENTS
  Future<bool> updateDocument({collection, doc, data}) async {
    try {
      await _db.collection(collection).document(doc).updateData(data);
      return true;
    } catch (e) {
      print("ERROR UPDATE ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateDocumentWhere(
      {collection, where, condition, updatedata}) async {
    try {
      _db
          .collection(collection)
          .where(where, isEqualTo: condition)
          .snapshots()
          .listen((getdata) => getdata.documents.forEach(
                (document) async => await _db
                    .collection(collection)
                    .document(document.documentID)
                    .updateData(updatedata),
              ));
      return true;
    } catch (e) {
      return false;
    }
  }

  void auth() {}
}
