import 'package:e_com_admin/pages/category_page.dart';
import 'package:e_com_admin/pages/dashboard_page.dart';
import 'package:e_com_admin/pages/launcher_page.dart';
import 'package:e_com_admin/pages/login_page.dart';
import 'package:e_com_admin/pages/new_product_page.dart';
import 'package:e_com_admin/pages/order_page.dart';
import 'package:e_com_admin/pages/product_details_page.dart';
import 'package:e_com_admin/pages/product_page.dart';
import 'package:e_com_admin/pages/report_page.dart';
import 'package:e_com_admin/pages/settings_page.dart';
import 'package:e_com_admin/pages/user_page.dart';
import 'package:e_com_admin/provider/order_provider.dart';
import 'package:e_com_admin/provider/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

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
    ],
    child: const MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-com-Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName : (_) => const LauncherPage(),
        LoginPage.routeName : (_) => const LoginPage(),
        DashboardPage.routeName : (_) => const DashboardPage(),
        ProductPage.routeName : (_) => const ProductPage(),
        ProductDetailsPage.routeName : (_) => ProductDetailsPage(),
        NewProductPage.routeName : (_) => const NewProductPage(),
        CategoryPage.routeName : (_) => const CategoryPage(),
        OrderPage.routeName : (_) => const OrderPage(),
        UserPage.routeName : (_) => const UserPage(),
        SettingsPage.routeName : (_) => const SettingsPage(),
        ReportPage.routeName : (_) => const ReportPage(),
      },
    );
  }
}
