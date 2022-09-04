import 'package:e_com_admin/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/product_provider.dart';
import 'new_product_page.dart';


class ProductPage extends StatelessWidget {
  static const String routeName = '/product';
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
            icon: const Icon(Icons.add_box_rounded,size: 30,),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) =>
        provider.productList.isEmpty ?
        const Center(child: Text('No item found!', style: TextStyle(fontSize: 18),),) :
        ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
            final product = provider.productList[index];
            return Card(
              elevation: 5,
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product.id),
                title: Text('${index+1}. ${product.name}'),
                subtitle: const Text('Stock: 10'),
                leading: FadeInImage.assetNetwork(
                  placeholder: 'images/placeholder.jpg',
                  image: product.imageUrl!,
                  fadeInDuration: const Duration(seconds: 2),
                  fadeInCurve: Curves.bounceInOut,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                trailing: IconButton(onPressed: () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text('Are you sure delete this product ?',
                      style: TextStyle(color: Colors.redAccent),),
                    content: Text('${product.name}',
                      style: const TextStyle(fontSize: 16, color: Colors.blueAccent),),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context),
                        child: const Text('NO'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Provider.of<ProductProvider>(context, listen: false)
                              .deleteProduct(product.id!, {'id' : productId});
                          Navigator.pop(context);
                        },
                        child: const Text('YES'),
                      ),
                    ],
                  ));
                }, icon: const Icon(Icons.delete)),
              ),
            );
          },
        ),
      ),
    );
  }
}
