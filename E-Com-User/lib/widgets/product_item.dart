import 'package:e_com_user/models/cart_model.dart';
import 'package:e_com_user/models/product_model.dart';
import 'package:e_com_user/pages/product_details_page.dart';
import 'package:e_com_user/provider/cart_provider.dart';
import 'package:e_com_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: => Navigator.pushNamed(context, ProductDetailsPage.routeName),
      child: Card(
        //elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/placeholder.jpg',
                      image: widget.productModel.imageUrl!,
                      fadeInDuration: const Duration(seconds: 2),
                      fadeInCurve: Curves.bounceInOut,
                      width: double.maxFinite,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.productModel.name!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text('$currencySymbol${widget.productModel.salesPrice}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Consumer<CartProvider>(
                  builder:  (context, provider, child) {
                    final isInCart = provider.isInCart(widget.productModel.id!);
                    return ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(isInCart ? Colors.redAccent: Colors.blue),
                      ),
                      onPressed: () {
                        if(isInCart) {
                          provider.removeFromCart(widget.productModel.id!);
                        } else {
                          final cartModel = CartModel(
                            productId: widget.productModel.id!,
                            productName: widget.productModel.name,
                            imageUrl: widget.productModel.imageUrl,
                            salePrice: widget.productModel.salesPrice,
                            stock: widget.productModel.stock,
                            category: widget.productModel.category,
                          );
                          provider.addToCart(cartModel);
                        }
                      },
                      icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.shopping_cart),
                      label: Text(isInCart ? 'Remove' : 'ADD'),
                    );
                  },
                ),
              ],
            ),
            if(widget.productModel.stock == 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  color: Colors.black54,
                  child: const Text('OUT OF STOCK', style: TextStyle(color: Colors.white),),
                )
              ),
          ],
        ),
      ),
    );
  }
}
