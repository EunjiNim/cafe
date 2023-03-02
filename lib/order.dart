import 'package:flutter/material.dart';
import 'package:cafe/main.dart';
import 'package:provider/provider.dart';

class order extends StatefulWidget {
  const order({Key? key}) : super(key: key);

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  late ItemList itemList;

  @override
  Widget build(BuildContext context) {
    itemList = Provider.of<ItemList>(context);
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
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: ExpansionTile(
                title: Text('주문 정보',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),),
                initiallyExpanded: true,
                clipBehavior: Clip.antiAlias,
                children: [
                    Divider(
                      color: Colors.teal,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.finalList.length,
                      itemBuilder: (context, i){
                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    Color(0xff4dabf7),
                                    Color(0xffda77f2),
                                    Color(0xfff783ac),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white70,
                                maxRadius: 20,
                                child: Image.network(itemList.finalList[i]['url'].toString(),)),
                              ),
                            title: Text(itemList.finalList[i]['name'].toString(),style: TextStyle(fontSize: 14,)),
                            subtitle: Text(itemList.finalList[i]['subname'].toString(),style: TextStyle(fontSize: 12,)),
                            trailing: Text(itemList.finalList[i]['count'].toString(), style: TextStyle(fontSize: 17),),
                            ),
                        ],
                      );
                  }),
                ],
            ),
          ),
        ],
      ),

    );
  }
}
