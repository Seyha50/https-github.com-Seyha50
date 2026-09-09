import 'package:bbusrd104/bindings/category_binding.dart';
import 'package:bbusrd104/routes/app_routes.dart';
import 'package:bbusrd104/screens/cards/categories/add_category.dart';
import 'package:bbusrd104/screens/cards/categories/category_screen.dart';
import 'package:bbusrd104/screens/login_screen.dart';
import 'package:get/get.dart';

class AppScreens {
  AppScreens._();

  static const home = AppRoutes.login;
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoryScreen(),
      binding : CategoryBinding(), 
    ), 
    GetPage(
      name: AppRoutes.categoryAdd,
      page: () => const AddCategory(),
    ),
    
  ];
}