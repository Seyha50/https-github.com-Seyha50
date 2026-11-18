import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/controllers/category_controller.dart';
import 'package:bbusrd104/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UpdateCategory extends GetView <CategoryController> {
  const UpdateCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = Get.arguments as CategoryModel;
    final keyform = GlobalKey<FormState>();
    final txtname = TextEditingController(text: category.categoryName);
    final txtdesc = TextEditingController(text: category.description);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Category')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form (
          key: keyform,
          child: Column(children: [
          const SizedBox(height: 16),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            }, 
            controller: txtname,
            decoration: InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: txtdesc,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: 
            Obx((){
              return 
              FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
              controller.isLoading.value ? null : () async {
                if (keyform.currentState!.validate()) {
                  EasyLoading.show();
                  final success = await controller.updateCategory(
                    categoryId: category.id,
                    categoryName: txtname.text,
                    description: txtdesc.text, 
                  );
                  EasyLoading.dismiss();

                  if (success == true) {
                    Get.back();
                    Get.snackbar('Success', 'Category updated successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 5)
                    );
                  }
                }
              },
              child:
              controller.isLoading.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.bgColor,
                      ),
                    )
                  : const Text('Save Changes'),
            );
            }),          
          ),
          
        ],),)
          
      ),
    );
  }
}
