import 'package:bbusrd104/controllers/category_controller.dart';
import 'package:bbusrd104/services/category_service.dart';
import 'package:get/get.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryService>(() => CategoryService(), fenix : true);
    Get.lazyPut<CategoryController>
    (() => CategoryController(Get.find <CategoryService>()), fenix : true);
    
  }
   
 }