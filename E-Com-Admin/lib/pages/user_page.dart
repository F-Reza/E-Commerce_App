import 'package:flutter/material.dart';


class UserPage extends StatelessWidget {
  static const String routeName = '/users';
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
    );
  }
}
