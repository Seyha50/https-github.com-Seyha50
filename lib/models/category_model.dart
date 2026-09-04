class CategoryModel {
  //feilds
  final String id;
  final String categoryName;
  final String? description;

  //constructors
  CategoryModel({
    required this.id,
    required this.categoryName,
    this.description,
  });
  //methods
  
  
  Map<String, dynamic> toMap() {
    return {
      //key value 
      'category_name': categoryName.trim(),
      'description': description,
    };
  }
  factory CategoryModel.fromMap(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      categoryName: data['category_name'] ?? '',
      description: data['description'] ??'',
    );
  }
}