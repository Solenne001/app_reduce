import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getProductsStream() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  Future<void> addProduct(String name, String price, String description) async {
    await _firestore.collection('products').add({
      'name': name,
      'price': double.tryParse(price) ?? 0.0,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
