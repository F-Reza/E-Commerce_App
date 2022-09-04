import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';
  ValueNotifier<DateTime> dateChangeNotifier = ValueNotifier(DateTime.now());

  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dateChangeNotifier.value = DateTime.now();
    final pId = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  Card(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/placeholder.jpg',
                      image: product.imageUrl!,
                      fadeInDuration: const Duration(seconds: 2),
                      fadeInCurve: Curves.bounceInOut,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              return const Center(child: Text('Failed to get data'));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }



}
