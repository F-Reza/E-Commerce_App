

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/models/date_model.dart';
import 'package:e_com_admin/models/product_model.dart';
import 'package:e_com_admin/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/purchase_model.dart';
import '../provider/product_provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/add_new_product';
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final salePriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final quantityController = TextEditingController();

  DateTime? _purchaseDate;
  String? _imageUrl;
  String? _category;
  bool isUploading = false, isSaving = false;
  ImageSource _imageSource = ImageSource.camera;
  final formKey = GlobalKey <FormState>();


  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    salePriceController.dispose();
    purchasePriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: isUploading ? null : _saveProductInfo, //_saveProductInfo,
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20,),
              Card(
                color: Colors.white54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 10,
                      child: _imageUrl == null ?
                        isUploading? const SizedBox(
                            child: CircularProgressIndicator(),
                          ) :
                      Image.asset('images/placeholder.jpg',height: 200, width: double.maxFinite,fit: BoxFit.cover,) :
                      Image.network(_imageUrl!,height: 200, width: double.maxFinite,fit: BoxFit.cover,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            onPressed: (){
                              _imageSource = ImageSource.camera;
                              _getImage();
                            },
                            icon: const Icon(Icons.camera),
                            label: const Text('Camera')),
                        TextButton.icon(
                            onPressed: (){
                              _imageSource = ImageSource.gallery;
                              _getImage();
                            },
                            icon: const Icon(Icons.photo),
                            label: const Text('Gallery')),
                      ],
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product name',
                  prefixIcon: Icon(Icons.production_quantity_limits),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty!';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty!';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: purchasePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Purchase price',
                  prefixIcon: Icon(Icons.price_change_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty!';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: salePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sale price',
                  prefixIcon: Icon(Icons.price_change_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty!';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.poll_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty!';
                  } /*if (value <= 4) {
                    return 'quantity can\'t be negative value';
                  }*/
                  else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10,),
              Card(
                color: Colors.white54,
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<String>(
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Can\'t be empty!';
                            } else {
                              return null;
                            }
                          },
                          hint: Text('Select Category'),
                          value: _category,
                          items: provider.categoryList.map((model) =>
                              DropdownMenuItem<String>(
                                value: model.catName,
                                child: Text(model.catName!),
                              )).toList(),
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 10,),
              Card(
                color: Colors.white54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: _selectDate,
                        child: const Text('Select purchase date: ')),
                    Text(_purchaseDate == null ? 'No Date Selected' : getFormattedDateTime(_purchaseDate!, 'dd/MM/yyyy')),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProductInfo() async {
    if(_imageUrl == null) {
      showMessage(context, 'Please select Image');
      return;
    }
    if(_purchaseDate == null) {
      showMessage(context, 'Please select purchase date');
      return;
    }
    //
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'please wait...', dismissOnTap: false);
      final productModel = ProductModel(
        name: nameController.text,
        description: descriptionController.text,
        category: _category,
        salesPrice: num.parse(salePriceController.text),
        imageUrl: _imageUrl,
      );
      final purchaseModel = PurchaseModel(
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(_purchaseDate!),
          day: _purchaseDate!.day,
          month: _purchaseDate!.month,
          year: _purchaseDate!.year,
        ),
        price: num.parse(purchasePriceController.text),
        quantity: num.parse(quantityController.text),
      );
      final catModel = context.read<ProductProvider>().getCategoryByName(_category!);
      context.read<ProductProvider>()
          .addProduct(productModel, purchaseModel, catModel).then((value) {
            EasyLoading.dismiss(animation: true);
            setState(() {
              nameController.clear();
              descriptionController.clear();
              purchasePriceController.clear();
              salePriceController.clear();
              quantityController.clear();
              _purchaseDate = null;
              _imageUrl = null;
              _category = null;

              Fluttertoast.showToast(
                msg: 'Login Successfully!',
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,);

            });
      });
    }

  }




  void _selectDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        _purchaseDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final selectedImage = await ImagePicker()
        .pickImage(source: _imageSource);
    if(selectedImage!=null){
      setState(() {
        isUploading = true;
      });
      try {
        final url = await context.read<ProductProvider>().updateImage(selectedImage);
        setState(() {
          _imageUrl = url;
          isUploading = false;
        });
      } catch(e) {
        return null;
      }

    }
  }



}
