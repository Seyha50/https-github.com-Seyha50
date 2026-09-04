import 'package:bbusrd104/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CategoryService {
  final FirebaseFirestore _firestore ;

  CategoryService({FirebaseFirestore? firestore}) : _firestore = firestore ?? 
  FirebaseFirestore.instance; 

  CollectionReference <Map<String, dynamic>> get _categoryCollect {
    return _firestore.collection('categories');
  }

  Future <void> addCategory(CategoryModel category) async {
    await _categoryCollect.add({
      ...category.toMap(),
      'createdAt' : FieldValue.serverTimestamp(),

    });
  }

  Stream <List <CategoryModel>> getCategories(){
    return _categoryCollect.snapshots().map((category){
      return category.docs.map((doc){
        return CategoryModel.fromMap(doc.id, doc.data());
      }).toList();
    });
      
    
  }

  Future <void> updateCategory (CategoryModel category) async {
    await _categoryCollect.doc(category.id).update({
      ...category.toMap(),
      'updatedAt' : FieldValue.serverTimestamp(),

    });
  }

  Future <void> deleteCategory(String id ) async {
    await _categoryCollect.doc(id).delete();
  }
}