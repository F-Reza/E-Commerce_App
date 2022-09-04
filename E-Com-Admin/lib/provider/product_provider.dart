

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/models/purchase_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<CategoryModel> categoryList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) =>
          CategoryModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addCategory(String category) {
    final categoryModel = CategoryModel(
      catName: category,
    );
    return DbHelper.addCategory(categoryModel);
  }

  CategoryModel getCategoryByName(String name) {
    final model = categoryList.firstWhere((element) => element.catName == name);
    return model;
  }

  Future<void> updateCategory(String id, Map<String, dynamic> map) =>
      DbHelper.updateCategory(id, map);

  Future<void> deleteCategory(String id, Map<String, dynamic> map) =>
      DbHelper.deleteCategory(id, map);


  Future<String> updateImage(XFile xFile) async {
    final imageName = 'Image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final task = photoRef.putFile(File(xFile.path));
    final snapshot = await task.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }


  Future<void> addProduct(
      ProductModel productModel,
      PurchaseModel purchaseModel,
      CategoryModel categoryModel) {
    final count = categoryModel.productCount + purchaseModel.quantity;
    return DbHelper.addProduct(productModel, purchaseModel, categoryModel.catId!, count);

  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> updateProduct(String id, String field, dynamic value) {
    return DbHelper.updateProduct(id, {field :value});
  }

  Future<void> deleteProduct(String id, Map<String, dynamic> map) =>
      DbHelper.deleteProduct(id, map);


  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      DbHelper.getProductById(id);


  getAllPurchaseByProduct(String id) {
    DbHelper.getAllPurchaseByProduct(id).listen((snapshot) {
      purchaseListOfSpecificProduct = List.generate(snapshot.docs.length, (index) =>
          PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }


  Future<void> addNewPurchase(PurchaseModel purchaseModel, String category) {
    final catModel = getCategoryByName(category);
    catModel.productCount +=  purchaseModel.quantity;
    return DbHelper.addNewPurchase(purchaseModel, catModel);
  }




}