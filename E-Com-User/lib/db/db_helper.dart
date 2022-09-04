
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/models/cart_model.dart';
import 'package:e_com_user/models/order_model.dart';
import 'package:e_com_user/models/user_model.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class DbHelper {
  static const String collectionUser = 'Users';
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionCart= 'Cart';
  static const String collectionOrder= 'Order';
  static const String collectionOrderDetails= 'OrderDetails';
  static const String collectionCities= 'Cities';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  //Add User
  static Future<void> addUser(UserModel userModel) =>
      _db.collection(collectionUser).doc(userModel.uid)
          .set(userModel.toMap());
  //Check User
  static Future<bool> doseUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser)
        .doc(uid).get();
    return snapshot.exists;
  }

  //Get User Data
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();


  //Update Profile
  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }




  //Get All Categories
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();


  //Get All Products
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct)
          .where(productAvailable, isEqualTo: true)
          .snapshots();


  //Get All ProductsById
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();


  //Add to Cart
  static Future<void> addToCart(CartModel cartModel, String uId) =>
      _db.collection(collectionUser).doc(uId)
          .collection(collectionCart)
          .doc(cartModel.productId)
          .set(cartModel.toMap());

  //Remove From Cart
  static Future<void> removeFromCart(String pId, String uId) =>
      _db.collection(collectionUser).doc(uId)
          .collection(collectionCart)
          .doc(pId)
          .delete();

  //Clear All Cart Items
  static Future<void> clearAllCartItems(String uId, List<CartModel> cartList) {
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUser).doc(uId);
    for(var cartM in cartList) {
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  //Update Cart Quantity
  static Future<void> updateCartQuantity(String uId, String pId, num quantity) =>
      _db.collection(collectionUser).doc(uId)
          .collection(collectionCart)
          .doc(pId)
          .update({cartProductQuantity :quantity});


  //Get All ProductsById
  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartByUser(String uId) =>
      _db.collection(collectionUser).doc(uId)
          .collection(collectionCart)
          .snapshots();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(String category) =>
      _db.collection(collectionProduct).where(productCategory, isEqualTo: category).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFeaturedProducts() =>
      _db.collection(collectionProduct).where(productFeatured, isEqualTo: true).snapshots();


  //Add Order
  static Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderModel.toMap());
    for(var cartM in cartList) {
      final detailsDoc = orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(detailsDoc, cartM.toMap());
      final productDoc = _db.collection(collectionProduct).doc(cartM.productId);
      wb.update(productDoc, {productStock : (cartM.stock - cartM.quantity)});
    }
    return wb.commit();

  }

  static Future<void> updateCategoryProductCount(List<CategoryModel> catList, List<CartModel> cartList) {
    final wb = _db.batch();
    for(var cartM in cartList) {
      final catModel = catList.firstWhere((element) => element.catName == cartM.category);
      final catDoc = _db.collection(collectionCategory).doc(catModel.catId);
      wb.update(catDoc, {categoryProductCount: (catModel.productCount - cartM.quantity)});
    }
    return wb.commit();
  }


  //Get Order Constant
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants2() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();


  //Get All Cities
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();


  //Update Cart Quantity
  static Future<void> updateAddress(String uId, Map<String, dynamic> map) =>
      _db.collection(collectionUser).doc(uId)
          .update({'address' : map});


}