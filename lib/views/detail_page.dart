import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';
import 'package:homework_api_simple_state_getx/theme/app_color.dart';

class DetailPage extends GetView<ProductController> {
  DetailPage({super.key});
  final sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    Product product = arguments['item'];
    int index = arguments['index'];
    String tag = arguments['tag'];
    final discount = product.price! * (85 / 100);
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product, index, context, tag),
              _buildProductTitle(product),
              _buildProductReview(product),
              _buildProductPrice(discount, product),
              _buildProductDes(product),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: background,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.decreaseQty(index);
                                },
                                icon: const Icon(
                                  CupertinoIcons.minus,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              SizedBox(
                                width: 35,
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      "${controller.productQty(index)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.increaseQty(index);
                                },
                                icon: const Icon(
                                  CupertinoIcons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            onPressed: () {
                              controller.addToCart(product);
                            },
                            child: const Text(
                              "ADD TO CART",
                              style: TextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text _buildProductDes(Product product) {
    return Text(
      "${product.description}",
    );
  }

  Padding _buildProductPrice(double discount, Product product) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "\$${discount.toStringAsFixed(2)}",
            style: GoogleFonts.oswald(
              fontSize: 22,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "\$${product.price}",
              style: GoogleFonts.oswald(
                fontSize: 18,
                decoration: TextDecoration.lineThrough,
                height: 1,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              "15%",
              style: TextStyle(
                height: 1.5,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildProductTitle(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        "${product.title}",
        style: GoogleFonts.oswald(
          fontSize: 24,
          // height: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Stack _buildProductImage(
      Product product, int index, BuildContext context, String tag) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.5,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            border: Border.all(color: primary),
            borderRadius: BorderRadius.circular(17),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: tag.isEmpty
                ? Image.network(
                    product.image.toString(),
                  )
                : Hero(
                    tag:
                        'product-hero-${product.id}', // Match the same unique tag from the SavedPage
                    child: Image.network(
                      product.image.toString(),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              GetBuilder<ProductController>(
                init: ProductController(),
                builder: (controller) => GestureDetector(
                  onTap: () {
                    controller.toggleFavorite(index, product);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    child: Icon(
                      controller.isFavorited(index)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Row _buildProductReview(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    "${product.rating!.rate}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "Ratings",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                "•",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 0,
                ),
              ),
            ),
            Text(
              "${product.rating!.count}K • Review",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                "•",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 0,
                ),
              ),
            ),
            Text(
              "${product.rating!.count}K • Sold",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
