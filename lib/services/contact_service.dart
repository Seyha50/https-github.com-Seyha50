import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbusrd104/models/contact_model.dart';

class ContactService {
  // Field
  final FirebaseFirestore _firestore;

  // Constructor
  ContactService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _contacts {
    return _firestore.collection('contacts');
  }

  // Create contact
  Future<void> adContact(ContactModel contact) async {
    await _contacts.add({
      ...contact.toMap(),
      'createAt': FieldValue.serverTimestamp(),
    });
  }

  // Read / Get contacts
  Stream<List<ContactModel>> getContacts() {
    return _contacts.orderBy('createAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map(ContactModel.fromFirestore).toList(),
        );
  }

  // Update contact
  Future<bool> updateContact(ContactModel contact) async {
    try {
      await _contacts.doc(contact.id).update({
        ...contact.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (ex) {
      return false;
    }
  }

  // Delete contact
  Future<bool> deleteContact(String id) async {
    try {
      await _contacts.doc(id).delete();
      return true;
    } catch (ex) {
      return false;
    }
  }
}
