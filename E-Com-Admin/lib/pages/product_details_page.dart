import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/models/date_model.dart';
import 'package:e_com_admin/models/purchase_model.dart';
import 'package:e_com_admin/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        title: Text(pId),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              provider.getAllPurchaseByProduct(pId);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showRePurchaseForm(context, provider, product);
                        },
                        child: const Text('Re-Purchase'),
                      ),
                      TextButton(
                        onPressed: () {
                          _showPurchaseHistory(context, provider);
                        },
                        child: const Text('Purchase History'),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(product.name!),
                    trailing: IconButton(
                      onPressed: () {
                        showInputDialog(
                            context: context,
                            title: 'Product Name',
                            value: product.name,
                            onSaved: (value) async {
                              provider.updateProduct(pId, productName, value);
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text('$currencySymbol${product.salesPrice}'),
                    trailing: IconButton(
                      onPressed: () {
                        showInputDialog(
                            context: context,
                            title: 'Sales Price',
                            value: product.salesPrice.toString(),
                            onSaved: (value) async {
                              provider.updateProduct(
                                  pId, productSalesPrice, num.parse(value));
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: const Text('Description'),
                    subtitle: Text(product.description ?? 'Not Available'),
                    trailing: IconButton(
                      onPressed: () {
                        showInputDialog(
                            context: context,
                            title: 'Product Description',
                            value: product.description,
                            onSaved: (value) async {
                              provider.updateProduct(
                                  pId, productDescription, value);
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Available'),
                    value: product.available,
                    onChanged: (value) {
                      provider.updateProduct(pId, productAvailable, value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Featured'),
                    value: product.featured,
                    onChanged: (value) {
                      provider.updateProduct(pId, productFeatured, value);
                    },
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

  showInputDialog(
      {required String title,
      required context,
      String? value,
      required Function(String) onSaved}) {
    final textController = TextEditingController();
    textController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Enter $title'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    onSaved(textController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('UPDATE'),
                ),
              ],
            ));
  }

  void _showPurchaseHistory(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
              itemCount: provider.purchaseListOfSpecificProduct.length,
              itemBuilder: (context, index) {
                final purchase = provider.purchaseListOfSpecificProduct[index];
                final pPrice = purchase.price / purchase.quantity;
                return ListTile(
                  title: Text(getFormattedDateTime(
                      purchase.dateModel.timestamp.toDate(), 'dd/MM/yyyy')),
                  subtitle: Text('Quantity: ${purchase.quantity}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Unit: $currencySymbol$pPrice'),
                      Text('Total: $currencySymbol${purchase.price}'),
                    ],
                  ),
                );
              },
            ));
  }

  void _showRePurchaseForm(
      BuildContext context, ProductProvider provider, ProductModel product) {
    final qController = TextEditingController();
    final priceController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Re-Purchase-> ${product.name}'),
            ),
            SizedBox(
              height: 50,
              child: TextField(
                controller: qController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Quantity'),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 50,
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Price'),
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              color: Colors.white54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        final _purchaseDate = await _selectDate(context);
                        dateChangeNotifier.value = _purchaseDate;
                      },
                      child: const Text('Select purchase date: ')),
                  ValueListenableBuilder(
                    valueListenable: dateChangeNotifier,
                    builder: (context, value, child) => Text(getFormattedDateTime(
                        dateChangeNotifier.value, 'dd/MM/yyyy')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if(qController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'quantity must not be empty!',
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,);
                      return;
                    }
                    if(priceController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'price must not be empty!',
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,);
                      return;
                    }
                    if(priceController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      EasyLoading.show(status: 'please wait...', dismissOnTap: false);
                    }

                    final purchase =PurchaseModel(
                        dateModel: DateModel(
                          timestamp: Timestamp.fromDate(dateChangeNotifier.value),
                          day: dateChangeNotifier.value.day,
                          month: dateChangeNotifier.value.month,
                          year: dateChangeNotifier.value.year,
                        ),
                        price: num.parse(priceController.text),
                        quantity: num.parse(qController.text),
                      productId: product.id,
                    );
                    provider.addNewPurchase(purchase, product.category!).then((value) {
                      EasyLoading.dismiss(animation: true);
                      qController.clear();
                      priceController.clear();
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: 'Re-Purchase Successfully done!',
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,);
                    }).catchError((error) {
                      Navigator.pop(context);
                      EasyLoading.dismiss(animation: true);
                      Fluttertoast.showToast(
                        msg: 'Failed to perform...',
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,);
                    });
                  },
                  child: const Text('Re-Purchase')),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now()) ?? DateTime.now();
  }


}
