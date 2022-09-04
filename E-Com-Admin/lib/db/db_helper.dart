


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/models/category_model.dart';
import 'package:e_com_admin/models/product_model.dart';
import 'package:e_com_admin/models/purchase_model.dart';
import 'package:e_com_admin/pages/category_page.dart';

import '../models/order_constants_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchases';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get All Admins
  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  //Get All Categories
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  //Add Category
  static Future<void> addCategory(CategoryModel categoryModel) {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.catId = doc.id;
    return doc.set(categoryModel.toMap());
  }

  //Update Category
  static Future<void> updateCategory(String id, Map<String, dynamic> map) {
    return _db.collection(collectionCategory).doc(id).update(map);
  }

  //Delete Category
  static Future<void> deleteCategory(String id, Map<String, dynamic> map) {
    return _db.collection(collectionCategory).doc(id).delete();
  }

  //Add Product
  static Future<void> addProduct(
      ProductModel productModel,
      PurchaseModel purchaseModel,
      String catId, num count) {
    final wb = _db.batch();
    final proDoc = _db.collection(collectionProduct).doc();
    final purDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(catId);
    productModel.id = proDoc.id;
    purchaseModel.id = purDoc.id;
    purchaseModel.productId = proDoc.id;
    wb.set(proDoc, productModel.toMap());
    wb.set(purDoc, purchaseModel.toMap());
    wb.update(catDoc, {'productCount' :count});
    return wb.commit();
  }

  //Get All Products
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  //Update Product
  static Future<void> updateProduct(String id, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(id).update(map);
  }

  //Delete Category
  static Future<void> deleteProduct(String id, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(id).delete();
  }

  //Get All ProductsById
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();


  //Get All Purchase History By Specific Product
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProduct(String id) =>
      _db.collection(collectionPurchase)
      .where(purchaseProductId, isEqualTo: id).snapshots();

  //Add Re-Purchase
  static Future<void> addNewPurchase(PurchaseModel purchaseModel, CategoryModel catModel) {
    final wb = _db.batch();
    final doc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(catModel.catId);
    purchaseModel.id = doc.id;
    wb.set(doc, purchaseModel.toMap());
    wb.update(catDoc, {categoryProductCount :catModel.productCount});
    return wb.commit();
  }


  //Add Order Constant
  static Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel) {
    return _db.collection(collectionOrderSettings)
        .doc(documentOrderConstant).set(orderConstantsModel.toMap());
  }

  //Get Order Constant
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants2() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();




}