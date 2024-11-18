import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';
import 'package:homework_api_simple_state_getx/theme/app_color.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: white,
            title: Text(
              "My Favorites",
              style: GoogleFonts.oswald(fontSize: 24),
            ),
          ),
          GetBuilder<ProductController>(
            init: ProductController(),
            builder: (controller) {
              return SliverList.builder(
                itemCount: controller.favCart.length,
                itemBuilder: (context, index) {
                  final item = controller.favCart[index];
                  if (index % 2 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 17, right: 17, bottom: 10),
                      child: _buildProductTile1(
                        context,
                        onTap: () {
                          Get.toNamed(
                            '/detail',
                            arguments: {
                              'item': item,
                              'index': index,
                              'tag': '',
                            },
                          );
                        },
                        product: item,
                      ),
                    );
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 17, right: 17, bottom: 10),
                    child: _buildProductTile2(
                      context,
                      onTap: () {
                        Get.toNamed(
                          '/detail',
                          arguments: {
                            'item': item,
                            'index': index,
                            'tag': '',
                          },
                        );
                      },
                      product: item,
                    ),
                  );
                },
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.all(50)),
        ],
      ),
    );
  }

  GestureDetector _buildProductTile1(
    BuildContext context, {
    required VoidCallback onTap,
    required Product product,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 170,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "https://logos-world.net/wp-content/uploads/2023/05/Chanel-Logo.png",
                        height: 15,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        product.title.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: StarRating(
                          mainAxisAlignment: MainAxisAlignment.start,
                          color: Colors.black,
                          size: 15,
                          rating:
                              double.parse((product.rating!.rate).toString()),
                        ),
                      ),
                      Text(
                        "${product.price} USD",
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: Image.network(
              product.image.toString(),
              height: 150,
              width: MediaQuery.sizeOf(context).width * 0.40,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildProductTile2(
    BuildContext context, {
    required VoidCallback onTap,
    required Product product,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 170,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "https://logos-world.net/wp-content/uploads/2023/05/Chanel-Logo.png",
                        height: 15,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        product.title.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: StarRating(
                          mainAxisAlignment: MainAxisAlignment.start,
                          color: Colors.black,
                          size: 15,
                          rating: product.rating!.rate != null
                              ? double.parse(product.rating!.rate.toString())
                              : 0.0, // Provide a default value if rating is null
                        ),
                      ),
                      Text(
                        "${product.price} USD",
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 15,
            bottom: 15,
            child: Image.network(
              product.image.toString(),
              width: MediaQuery.sizeOf(context).width * 0.40,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
