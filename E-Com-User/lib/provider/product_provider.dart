

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> featuredProductList = [];
  List<CategoryModel> categoryList = [];
  List<String> categoryNameList = [];

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) =>
          CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryNameList = List.generate(categoryList.length, (index) => categoryList[index].catName!);
      categoryNameList.insert(0, 'All');
      notifyListeners();
    });
  }


  getAllFeaturedProducts() {
    DbHelper.getAllFeaturedProducts().listen((snapshot) {
      featuredProductList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String category) {
    DbHelper.getAllProductsByCategory(category).listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }



  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      DbHelper.getProductById(id);


  Future<void> updateCategoryProductCount(List<CartModel> cartList) =>
      DbHelper.updateCategoryProductCount(categoryList, cartList);


}