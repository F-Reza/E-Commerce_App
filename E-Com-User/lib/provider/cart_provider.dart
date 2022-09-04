import 'package:e_com_user/auth/firebase_auth.dart';
import 'package:e_com_user/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  int get totalItemsInCart => cartList.length;

  num unitPriceWithQuantity(CartModel cartModel) =>
    cartModel.salePrice * cartModel.quantity;

  Future<void> addToCart(CartModel cartModel) =>
      DbHelper.addToCart(cartModel, AuthService.user!.uid);

  Future<void> removeFromCart(String pId) =>
      DbHelper.removeFromCart(pId, AuthService.user!.uid);

  Future<void> clearAllCartItems() =>
  DbHelper.clearAllCartItems(AuthService.user!.uid, cartList);


  Future<void> _updateCartQuantity(String pId, num quantity) =>
    DbHelper.updateCartQuantity(AuthService.user!.uid, pId, quantity);

  increaseQuantity(CartModel cartModel) async {
    await _updateCartQuantity(cartModel.productId!, cartModel.quantity + 1);
  }

  decreaseQuantity(CartModel cartModel) async {
    if(cartModel.quantity > 1) {
      await _updateCartQuantity(cartModel.productId!, cartModel.quantity - 1);
    }
  }

  getCartByUser() {
    DbHelper.getCartByUser(AuthService.user!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) =>
          CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }


  bool isInCart(String pId) {
    bool tag =false;
    for(var cartM in cartList) {
      if(cartM.productId == pId) {
        tag = true;
        break;
      }
    }
    return tag;
  }


  num getCartSubTotal() {
    num total = 0;
    for(var cartM in cartList) {
      total += cartM.salePrice * cartM.quantity;
    }
    return total;
  }


}