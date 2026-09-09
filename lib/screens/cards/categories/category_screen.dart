import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class CategoryScreen extends StatelessWidget {
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
      body: ListView(),
    );
  }
}