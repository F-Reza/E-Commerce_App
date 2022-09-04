import 'package:e_com_user/pages/cart_page.dart';
import 'package:e_com_user/pages/launcher_page.dart';
import 'package:e_com_user/pages/login_page.dart';
import 'package:e_com_user/pages/order_page.dart';
import 'package:e_com_user/pages/order_successful_page.dart';
import 'package:e_com_user/pages/phone_verification_page.dart';
import 'package:e_com_user/pages/product_details_page.dart';
import 'package:e_com_user/pages/product_page.dart';
import 'package:e_com_user/pages/profile_page.dart';
import 'package:e_com_user/pages/registration_page.dart';
import 'package:e_com_user/pages/user_address_page.dart';
import 'package:e_com_user/provider/order_provider.dart';
import 'package:e_com_user/provider/product_provider.dart';
import 'package:e_com_user/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'pages/checkout_page.dart';
import 'provider/cart_provider.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const MyApp()));
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDgQk4LwcmjRWu02LdHA1ncA_W0SUaTFXg",
            authDomain: "e_com_admin.firebaseapp.com",
            projectId: "e-com-34f37",
            storageBucket: "e_com_admin.appspot.com",
            messagingSenderId: "87881805797",
            appId: "1:111504962865:android:bd51cba626c3339f376c10",
            measurementId: "G-JMXWE37BPX")
    );
  }else {
    await Firebase.initializeApp();
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Com-User',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName : (_) => const LauncherPage(),
        LoginPage.routeName : (_) => const LoginPage(),
        RegistrationPage.routeName : (_) => const RegistrationPage(),
        ProfilePage.routeName : (_) => const ProfilePage(),
        UserAddressPage.routeName : (_) => const UserAddressPage(),
        PhoneVerificationPage.routeName : (_) => const PhoneVerificationPage(),
        ProductPage.routeName : (_) => const ProductPage(),
        ProductDetailsPage.routeName : (_) => ProductDetailsPage(),
        CartPage.routeName : (_) => const CartPage(),
        OrderPage.routeName : (_) => const OrderPage(),
        CheckoutPage.routeName : (_) => const CheckoutPage(),
        OrderSuccessfulPage.routeName : (_) => const OrderSuccessfulPage(),
      },
    );
  }
}

