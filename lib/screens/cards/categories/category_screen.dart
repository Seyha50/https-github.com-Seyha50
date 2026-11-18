import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/controllers/category_controller.dart';
import 'package:bbusrd104/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bgColor,
        onPressed: () {
          Get.toNamed(AppRoutes.categoryAdd);
        },
        child: const Icon(Icons.add),
      ), 
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Categories',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              controller.searchCategory(value);
            },
          ),
        ),
        Expanded (child : Obx ((){
          if (controller.filterCategories.isEmpty) {
            return Center(child: Text('No categories found', style: TextStyle(fontSize:20,color: Colors.grey)));
          }
          final categories = controller.filterCategories;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.bgColor,
                  child: Text(category.categoryName.isNotEmpty ? category.categoryName[0].toUpperCase() : '?',
                  style: TextStyle(color: AppColors.white),
                  ),
                  
                ), 
                title: Text(category.categoryName),
                subtitle: Text(category.description!),
                trailing : PopupMenuButton(itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.bgColor),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.red),
                          SizedBox(width: 12),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.toNamed(AppRoutes.categoryEdit, arguments: category);
                    } 
                    // else {
                    //   controller.deleteCategory(category.id!);
                    // }
                  },
                  
                // onTap: () {
                //   // Handle category tap if needed
                // },
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: categories.length, // Replace with the actual number of categories
          );
        }))
      ],),
    );
  }
}
