import 'package:flutter/material.dart';
import 'package:cafe/main.dart';


class shoppingcart extends StatefulWidget {
  const shoppingcart({Key? key, this.selectProduct}) : super(key: key);
  final selectProduct;

  @override
  State<shoppingcart> createState() => _shoppingcartState();
}

class _shoppingcartState extends State<shoppingcart> {
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
            //print(selectProduct);
          },
            visualDensity: VisualDensity(horizontal: 3.0, vertical: 3.0),
            padding: EdgeInsets.zero,),
          IconButton(
            icon: Icon(Icons.density_medium_outlined), onPressed:(){},),
        ],
        //leading: Icon(Icons.list),
        title: Text('Shopping Cart', style: TextStyle(color:Colors.white, fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('daTA'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_drink_outlined, size: 30),
              label: 'Order'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_dining_outlined, size: 30),
              label: 'Order Status'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz, size: 30),
              label: 'Other'
          ),
        ],
      ),
    );
  }
}
