
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/models/address_model.dart';
import 'package:e_com_user/models/date_model.dart';
import 'package:e_com_user/models/order_model.dart';
import 'package:e_com_user/pages/product_page.dart';
import 'package:e_com_user/provider/product_provider.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../provider/user_provider.dart';
import '../utils/constants.dart';
import 'order_successful_page.dart';
import 'user_address_page.dart';


class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  String paymentMethodGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    orderProvider.getOrderConstants();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text('Product Info', style: Theme.of(context).textTheme.headline6,),
                const SizedBox(height: 10,),
                Card(
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: cartProvider.cartList.map((cartM) =>
                        ListTile(
                          title: Text(cartM.productName!),
                          trailing: Text('${cartM.quantity} x $currencySymbol${cartM.salePrice}'),
                        )).toList(),
                  ),
                ),
                const SizedBox(height: 10,),
                Text('Payment Info', style: Theme.of(context).textTheme.headline6,),
                const SizedBox(height: 10,),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('$currencySymbol${cartProvider.getCartSubTotal()}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Charge'),
                            Text('$currencySymbol${orderProvider.orderConstantsModel.deliveryCharge}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount(${orderProvider.orderConstantsModel.discount}%)'),
                            Text('-$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('VAT(${orderProvider.orderConstantsModel.vat}%)'),
                            Text('$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}'),
                          ],
                        ),
                        const Divider(height: 1.5, color: Colors.black,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total'),
                            Text('$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}',
                              style: const TextStyle(fontWeight: FontWeight.w800),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text('Delivery Address', style: Theme.of(context).textTheme.headline6,),
                const SizedBox(height: 10,),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userProvider.getUserById(AuthService.user!.uid),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      final userM = UserModel.fromMap(snapshot.data!.data()!);
                      userProvider.userModel = userM;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(userM.address == null ? 'No address set yet' :
                              '${userM.address!.streetAddress} \n'
                                  '${userM.address!.area}, ${userM.address!.city}\n'
                                  '${userM.address!.zipCode}'),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, UserAddressPage.routeName),
                                child: Text(userM.address == null ? 'Set Address' : 'Change'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if(snapshot.hasError) {
                      return const Text('Failed to fetch user data');
                    }
                    return const Text('Fetching user data...');
                  },
                ),
                const SizedBox(height: 10,),
                Text('Payment Method', style: Theme.of(context).textTheme.headline6,),
                const SizedBox(height: 10,),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Radio<String>(
                            value: PaymentMethod.cod,
                            groupValue: paymentMethodGroupValue,
                            onChanged: (value) {
                              setState(() {
                                paymentMethodGroupValue = value!;
                              });
                            },
                        ),
                        const Text(PaymentMethod.cod),
                        const SizedBox(width: 10,),
                        Radio<String>(
                          value: PaymentMethod.online,
                          groupValue: paymentMethodGroupValue,
                          onChanged: (value) {
                            setState(() {
                              paymentMethodGroupValue = value!;
                            });
                          },
                        ),
                        const Text(PaymentMethod.online),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: _saveOrder,
              child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }

  void _saveOrder() {
    if(userProvider.userModel?.address == null) {
      showMessage(context, 'Please provide a delivery address');
      return;
    }
    EasyLoading.show(status: 'Please Wait....', dismissOnTap: false);
    final orderModel = OrderModel(
        userId: AuthService.user!.uid,
        orderStatus: OrderStatus.pending,
        paymentMethod: paymentMethodGroupValue,
        deliveryAddress: AddressModel(
            streetAddress: userProvider.userModel!.address!.streetAddress,
            area: userProvider.userModel!.address!.area,
            city: userProvider.userModel!.address!.city,
            zipCode: userProvider.userModel!.address!.zipCode,
        ),
        deliveryCharge: orderProvider.orderConstantsModel.deliveryCharge,
        discount: orderProvider.orderConstantsModel.discount,
        vat: orderProvider.orderConstantsModel.vat,
        grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
        orderDate: DateModel(
            timestamp: Timestamp.fromDate(DateTime.now()),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year
        ),
    );
    orderProvider.addOrder(orderModel, cartProvider.cartList)
        .then((_) async {
          await Provider.of<ProductProvider>(context, listen: false)
              .updateCategoryProductCount(cartProvider.cartList);
          await cartProvider.clearAllCartItems();
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(context, OrderSuccessfulPage.routeName, ModalRoute.withName(ProductPage.routeName));
    }).catchError((error) {
      EasyLoading.dismiss();
    });
  }

}
