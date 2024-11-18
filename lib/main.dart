import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework_api_simple_state_getx/bindings/home_bindings.dart';
import 'package:homework_api_simple_state_getx/views/cart_page.dart';
import 'package:homework_api_simple_state_getx/views/detail_page.dart';
import 'package:homework_api_simple_state_getx/views/home_page.dart';
import 'package:homework_api_simple_state_getx/views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
      home: const MainPage(),
      defaultTransition: Transition.downToUp,
      getPages: [
        GetPage(
          name: '/detail',
          page: () => DetailPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/cart',
          page: () => const CartPage(),
        ),
      ],
    );
  }
}
