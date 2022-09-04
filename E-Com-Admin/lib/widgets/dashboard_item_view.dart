import 'package:flutter/material.dart';

import '../models/dashboard_item.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardItem item;
  final Function(String) onPressed;
  const DashboardItemView({Key? key, required this.item, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onPressed(item.title);
      },
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon,size: 40, color: Colors.blue,),
            const SizedBox(height: 5,),
            Text(item.title,style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
