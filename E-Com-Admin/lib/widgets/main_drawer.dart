

import 'package:flutter/material.dart';

import '../auth/firebase_auth.dart';
import '../pages/category_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/launcher_page.dart';
import '../pages/order_page.dart';
import '../pages/product_page.dart';
import '../pages/report_page.dart';
import '../pages/settings_page.dart';
import '../pages/user_page.dart';

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
                  child: Image.asset('images/admin.png',
                      height: 100, width: 100, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10,),
                Text(AuthService.user!.email!,
                  style: const TextStyle(fontSize: 16,color: Colors.white),),
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, DashboardPage.routeName),
            leading: const Icon(Icons.dashboard,size: 30,),
            title: const Text('Dashboard'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushNamed(context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout,size: 30,),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
