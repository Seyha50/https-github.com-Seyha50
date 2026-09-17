import 'package:cloud_firestore/cloud_firestore.dart';

// class ContactModel {
//   // Fields
//   final String id;
//   final String firstName;
//   final String lastName;
//   final String gender;
//   final String phone;
//   final String? company;
//   final DateTime? createAt;

//   // Constructor
//   ContactModel({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.gender,
//     required this.phone,
//     this.company,
//     this.createAt,
//   });

//   // Convert Model to Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'firstName': firstName.trim(),
//       'lastName': lastName.trim(),
//       'gender': gender,
//       'phone': phone.trim(),
//       'company': company?.trim(),
//     };
//   }

//   // Convert Firestore Document to Model
//   factory ContactModel.fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data() ?? {};

//     DateTime? parsedDate;
//     if (data['createAt'] != null && data['createAt'] is Timestamp) {
//       parsedDate = (data['createAt'] as Timestamp).toDate();
//     }

//     return ContactModel(
//       id: document.id,
//       firstName: data['firstName'] ?? '',
//       lastName: data['lastName'] ?? '',
//       gender: data['gender'] ?? '',
//       phone: data['phone'] ?? '',
//       company: data['company'],
//       createAt: parsedDate,
//     );
//   }
// }
class ContactModel {
  // Fields
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String phone;
  final String? company;
  final DateTime? createAt;
  final bool isFavourite;

  // Constructor
  ContactModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    this.company,
    this.createAt,
    this.isFavourite = false,
  });

  // Convert Model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'gender': gender,
      'phone': phone.trim(),
      'company': company?.trim(),
      'isFavourite': isFavourite,
    };
  }

  // Convert Firestore Document to Model
  factory ContactModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};

    DateTime? parsedDate;
    if (data['createAt'] != null && data['createAt'] is Timestamp) {
      parsedDate = (data['createAt'] as Timestamp).toDate();
    }

    return ContactModel(
      id: document.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      company: data['company'],
      createAt: parsedDate,
      isFavourite: data['isFavourite'] ?? false,
    );
  }
}
