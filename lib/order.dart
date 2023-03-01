import 'package:flutter/material.dart';
import 'package:cafe/main.dart';

class order extends StatefulWidget {
  const order({Key? key}) : super(key: key);

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications), onPressed: (){
          },
            visualDensity: VisualDensity(horizontal: 3.0, vertical: 3.0),
            padding: EdgeInsets.zero,),
          IconButton(
            icon: Icon(Icons.density_medium_outlined), onPressed:(){},),
        ],
        title: Text('Order', style: TextStyle(color:Colors.white, fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Text('hi'),

    );
  }
}
