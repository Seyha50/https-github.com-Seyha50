import 'package:bbusrd104/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategory extends GetView <CategoryController> {
  const AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: ListView(),
       
    );
  }
}