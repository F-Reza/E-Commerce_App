
import 'package:flutter/material.dart';
import '../auth/firebase_auth.dart';
import '../pages/cart_page.dart';
import '../pages/launcher_page.dart';
import '../pages/order_page.dart';
import '../pages/product_page.dart';
import '../pages/profile_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue.shade700,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: AuthService.user!.photoURL == null ? Image.asset('images/male.png',
                      height: 100, width: 100, fit: BoxFit.cover)
              :Image.network(AuthService.user!.photoURL!,
                      height: 100, width: 100, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10,),
                Text(AuthService.user!.email!,
                  style: const TextStyle(fontSize: 16,color: Colors.white),),
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, ProductPage.routeName),
            leading: const Icon(Icons.dashboard,),
            title: const Text('Home'),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, ProfilePage.routeName),
            leading: const Icon(Icons.person,),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            leading: const Icon(Icons.shopping_cart,),
            title: const Text('My Cart'),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, OrderPage.routeName),
            leading: const Icon(Icons.shop,),
            title: const Text('My Order'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushNamed(context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout,),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
