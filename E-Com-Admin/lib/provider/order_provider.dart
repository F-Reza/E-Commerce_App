
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();


  Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel) =>
      DbHelper.addOrderConstants(orderConstantsModel);

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((event) {
      if(event.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> getOrderConstants2() async {
    final snapshot = await DbHelper.getOrderConstants2();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }


}