
import 'package:e_com_user/pages/checkout_page.dart';
import 'package:e_com_user/provider/cart_provider.dart';
import 'package:e_com_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount:  provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartM = provider.cartList[index];
                  return Card(
                    color: Colors.indigo[50],
                    elevation: 5,
                    child: ListTile(
                      leading: FadeInImage.assetNetwork(
                        placeholder: 'images/placeholder.jpg',
                        image: cartM.imageUrl!,
                        fadeInDuration: const Duration(seconds: 2),
                        fadeInCurve: Curves.bounceInOut,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                      title: Text(cartM.productName!),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('$currencySymbol${cartM.salePrice} X ${cartM.quantity} '
                                '= $currencySymbol${provider.unitPriceWithQuantity(cartM)}'),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  provider.decreaseQuantity(cartM);
                                },
                                icon: const Icon(Icons.remove_circle_outline,color: Colors.red),
                              ),
                              Text('${cartM.quantity}',
                                style: const TextStyle(fontSize: 18, color: Colors.black),),
                              IconButton(
                                onPressed: () {
                                  provider.increaseQuantity(cartM);
                                },
                                icon: const Icon(Icons.add_circle_outline,color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            provider.removeFromCart(cartM.productId!);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red,),
                      ),
                    ),
                  );
                  },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal: $currencySymbol${provider.getCartSubTotal()}'),
                      TextButton(
                        onPressed: provider.totalItemsInCart == 0 ? null 
                            : () => Navigator.pushNamed(context, CheckoutPage.routeName),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('CHECKOUT'),
                            SizedBox(width: 5,),
                            Icon(Icons.send),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
