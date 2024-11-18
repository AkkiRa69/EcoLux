import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework_api_simple_state_getx/controllers/product_controller.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';
import 'package:homework_api_simple_state_getx/theme/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final shoes = [
  'assets/images/shoes1.png',
  'assets/images/shoes2.png',
  'assets/images/shoes4.png',
  'assets/images/shoes5.png',
  'assets/images/shoes6.png',
  'assets/images/shoes7.png',
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: GetBuilder<ProductController>(
        init: ProductController(),
        builder: (controller) {
          final categories = controller.allProducts
              .map((product) => product.category)
              .toSet()
              .toList();
          if (controller.isLoading) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: primary,
                size: 30,
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                print("Refresh");
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 15),
                    sliver: SliverAppBar(
                      backgroundColor: white,
                      titleSpacing: 0,
                      title: _buildTitle(),
                      actions: [
                        _buildNotification(),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildBanner(context),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _CategoryHeaderDelegate(
                      minExtentHeight: 75, // Collapsed height
                      maxExtentHeight: 75, // Expanded height
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.only(
                            top: 20, bottom: 17, left: 17),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              bool isSelected =
                                  controller.selectedIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _buildAllButton(
                                    controller, index, isSelected),
                              );
                            }
                            final item = categories[index - 1];
                            bool isSelected = controller.selectedIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildCateButton(
                                  controller, index, isSelected, item),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  _buildTextBar(),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 17),
                    sliver: SliverGrid.builder(
                      itemCount: controller.filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 280,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.filteredProducts[index];
                        bool isFav = controller.isFavorited(index);
                        // Get favorite status
                        return _buildProduct(item, controller, index, isFav);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  SliverToBoxAdapter _buildTextBar() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "POPULAR PRODUCTS",
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "View All",
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct(
      Product item, ProductController controller, int index, bool isFav) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/detail',
          arguments: {
            'item': item,
            'index': index,
            'tag': 'product-hero-${item.id}',
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: primary,
                    ),
                  ),
                  child: Hero(
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) {
                      switch (flightDirection) {
                        case HeroFlightDirection.push:
                          return ScaleTransition(
                            scale: animation.drive(
                              Tween<double>(
                                begin: 0.0,
                                end: 1.0,
                              ).chain(
                                CurveTween(curve: Curves.fastOutSlowIn),
                              ),
                            ),
                            child: toHeroContext.widget,
                          );
                        case HeroFlightDirection.pop:
                          return fromHeroContext.widget;
                      }
                    },
                    tag:
                        'product-hero-${item.id}', // Use unique identifier for each product
                    child: Image.network(
                      item.image.toString(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleFavorite(index, item);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        isFav
                            ? Icons.favorite
                            : Icons.favorite_border, // Update icon
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.title.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Oswald',
              fontSize: 16,
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "\$${item.price}",
            style: const TextStyle(
              fontFamily: 'Oswald',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _buildAllButton(
      ProductController controller, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        controller.searchProducts(null); // Reset to all products
      },
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? primary : white,
          border: Border.all(color: primary),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          "ALL",
          style: TextStyle(
            fontFamily: 'Oswald',
            color: isSelected ? white : primary,
          ),
        ),
      ),
    );
  }

  GestureDetector _buildCateButton(
      ProductController controller, int index, bool isSelected, String? item) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        controller.searchProducts(item); // Search by category
      },
      child: Container(
        height: 36,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? primary : white,
          border: Border.all(color: primary),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          item!.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Oswald',
            color: isSelected ? white : primary,
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 17),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GET YOUR SPECIAL SALE",
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20,
                      color: white,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "UP TO",
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 28,
                            color: white,
                          ),
                        ),
                        TextSpan(
                          text: " 50%",
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 36,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Text(
                      "SHOP NOW",
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -110,
          right: -8,
          child: SizedBox(
            height:
                310, // Ensure a fixed height for the container holding the PageView
            width: MediaQuery.sizeOf(context)
                .width, // Ensure a fixed width for the container holding the PageView
            child: PageView.builder(
              itemCount: shoes.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(-20 / 360),
                    child: Image.asset(
                      shoes[index],
                      fit: BoxFit
                          .contain, // Ensures the image fits within the available space
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Container _buildNotification() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: const Icon(Icons.notifications_none_rounded),
    );
  }

  Row _buildTitle() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
              'https://preview.redd.it/cute-girl-drawing-reference-is-from-pinterest-also-my-v0-h95tudnrceaa1.jpg?width=640&crop=smart&auto=webp&s=1046fecf206ba2dfd4f958bf337d2d38bcaa5413'),
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'AKKHARA',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double maxExtentHeight;
  final Widget child;

  _CategoryHeaderDelegate({
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Background color of the header
      child: child,
    );
  }

  @override
  double get minExtent => minExtentHeight; // Minimum height of the header

  @override
  double get maxExtent => maxExtentHeight; // Maximum height of the header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Return true to rebuild when necessary
  }
}
