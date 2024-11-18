import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';

class ProductTile2 extends StatelessWidget {
  final Product product;
  final void Function()? onTap;
  const ProductTile2({super.key, required this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return _buildProductTile2(context);
  }

  GestureDetector _buildProductTile2(BuildContext context) {
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
          child: Hero(
            tag: 'product2',
            child: Image.network(
              product.image.toString(),
              width: MediaQuery.sizeOf(context).width * 0.40,
              height: 150,
            ),
          ),
        ),
      ],
    ),
  );
  }
}
