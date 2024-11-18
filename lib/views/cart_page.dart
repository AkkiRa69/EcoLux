import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework_api_simple_state_getx/controllers/page_controller.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';

class CartPage extends GetView<ProductController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PageNavigatorController>(); // Initialize the controller
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      c.changeTabIndex(0); // Properly update index
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xfff5f5f5),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Text(
                    "My Cart ",
                    style: GoogleFonts.oswald(fontSize: 24),
                  ),
                ],
              ),
            ),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) {
                    final product = controller.cart[index];
                    return _buildProductTile(product, index);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(17),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 17),
                        hintStyle: GoogleFonts.oswald(
                          color: Colors.grey,
                        ),
                        hintText: "Enter Discount Code",
                        border: InputBorder.none,
                        suffix: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Apply",
                            style: GoogleFonts.oswald(
                              color: const Color(0xffff660e),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "\$${controller.sumTotal().toStringAsFixed(2)}",
                            style: GoogleFonts.oswald(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "\$${controller.sumTotal().toStringAsFixed(2)}",
                            style: GoogleFonts.oswald(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildProductTile(Product product, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 17, left: 17, right: 17),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(17),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  product.image.toString(),
                  height: 75,
                  width: 75,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${product.title}",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.deleteProduct(index);
                        },
                        child: Image.asset(
                          "assets/images/delete.png",
                          height: 20,
                          color: const Color(0xffff660e),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${product.category}",
                    style: GoogleFonts.oswald(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "\$${product.price}",
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.decreaseQty(index);
                              },
                              child: const Icon(
                                CupertinoIcons.minus,
                                size: 18,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                              child: Obx(
                                () => Text(
                                  "${controller.productQty(index)}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.increaseQty(index);
                              },
                              child: const Icon(
                                CupertinoIcons.add,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
