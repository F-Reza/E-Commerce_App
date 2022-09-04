import 'package:flutter/material.dart';


class ReportPage extends StatelessWidget {
  static const String routeName = '/reports';
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
      ),
    );
  }
}
