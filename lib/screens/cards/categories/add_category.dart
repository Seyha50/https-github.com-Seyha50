import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategory extends GetView <CategoryController> {
  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final keyform = GlobalKey<FormState>();
    final txtname = TextEditingController();
    final txtdesc = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
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
          const SizedBox(height: 16),
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
                // Handle save action
                if (keyform.currentState!.validate()) {
                  final success = await controller.addCategory(
                    categoryName: txtname.text,
                    description: txtdesc.text
                  );

                  if (success == true) {
                    Get.back();
                  } else {
                    Get.snackbar('Success', 'Category added successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                    );
                    
                  }
                }
              },
              child:
              controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.bgColor,
                      ),
                    )
                  :
              const Text('Save'),
            );
            }),          
          ),
          
        ],),)
          
      ),
    );
  }
}