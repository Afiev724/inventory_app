import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  final CollectionReference items =
      FirebaseFirestore.instance.collection('items');

  // CREATE
  Future<void> addItem(Item item) async {
    await items.add(item.toMap());
  }

  // READ (REAL-TIME STREAM)
  Stream<List<Item>> getItems() {
    return items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateItem(Item item) async {
    await items.doc(item.id).update(item.toMap());
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    await items.doc(id).delete();
  }
}