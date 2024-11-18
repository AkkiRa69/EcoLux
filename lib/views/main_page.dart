import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homework_api_simple_state_getx/controllers/page_controller.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';
import 'package:homework_api_simple_state_getx/theme/app_color.dart';
import 'package:homework_api_simple_state_getx/views/cart_page.dart';
import 'package:homework_api_simple_state_getx/views/home_page.dart';
import 'package:homework_api_simple_state_getx/views/saved_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PageNavigatorController());
    return Scaffold(
      body: GetBuilder<ProductController>(
        init: ProductController(),
        builder: (controller) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => IndexedStack(
                index: c.selectedIndex.value,
                children: const [
                  HomePage(), // First screen is HomePage
                  SavedPage(),
                  CartPage(),
                  Scaffold(), // Fourth screen (e.g., Profile, Notifications)
                ],
              ),
            ),
            controller.isLoading
                ? const SizedBox()
                : Obx(
                    () => Visibility(
                      visible: c.isVisible.value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 17),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: GNav(
                            selectedIndex: c.selectedIndex.value,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            onTabChange: (value) {
                              c.changeTabIndex(value);
                            },
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.elasticInOut,
                            color: Colors.white,
                            activeColor: Colors.black,
                            tabActiveBorder: Border.all(color: Colors.white),
                            tabBackgroundColor: Colors.white,
                            tabMargin: const EdgeInsets.all(6),
                            backgroundColor: primary,
                            tabs: const [
                              GButton(
                                icon: Icons.home_filled,
                              ),
                              GButton(
                                icon: CupertinoIcons.heart,
                              ),
                              GButton(icon: Icons.shopping_cart_outlined),
                              GButton(icon: Icons.person_2_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  log(String s) {}
}
