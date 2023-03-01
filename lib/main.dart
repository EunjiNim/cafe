import 'package:flutter/material.dart';
import 'package:badges/badges.dart'as badges;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'shoppingcart.dart';
import 'login.dart';
import 'order.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ChangeNotifierProvider(
        create: (c) => UserloginState(),
        child: MaterialApp(
          // css라고 생각하면 편함
          // ThemeData 특징 - 위젯은 나랑 가까운 스타일을 가장 먼저 적용함
          // 복잡한 위젯의 경우 Theme()안에서 스타일을 주어야 함
          // import 시 변수 중복문제 피하기 - as 작명
          // 변수를 다른 파일에서 쓰기 싫으면 _변수명, _함수명, _클래스명 으로 사용하면 된다.
          // 레이아웃 중간에 ThemeData() 생성 가능
          // (원칙) 나랑 조금 더 가까운 스타일 먼저 적용하려고 함
          // Theme.of() - MaterialApp 안에 있는 theme의 내용을 찾아 스타일을 적용시켜 줌
          // Navigator, Router, tab으로 페이지 나누기 구현 가능
          // page가 많으면 routes를 사용 - Home 사용하면 에러가 남
          initialRoute: '/',
          routes: {
            '/' : (c) => MyApp(),
            '/shoppingcart': (c) => shoppingcart(),
            '/login': (c) => login(),
            '/order': (c) => order(),
          },
          //home: MyApp()
        ),
      )
  );
}

class MyApp extends StatefulWidget {
 const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState() ;
}

class _MyAppState extends State<MyApp> {
  late bool _showCartBadge;

  List<dynamic> data = [];

  var selectProduct = [];
  var selectCount = 0;
  var saveCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  getData() async{
    var result = await firestore.collection('product').get();

    for(var doc in result.docs){
      data.add(doc.data());
    }
    data.sort((a,b)=>a['Index'].compareTo(b['Index']));

    getSelectCountData();
  }

  // 각 상품별로 선택한 수량을 저장하기 위해 미리 생성
  getSelectCountData(){
    var count = data.length;
    for(var i = 0; i < count; i++){
      selectProduct.add([i, selectCount]);
    }
  }

  logOut() async{
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    _showCartBadge = saveCount > 0;
    return MaterialApp(
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      home: Scaffold(
        floatingActionButton: badges.Badge(
          showBadge: _showCartBadge,
            position: badges.BadgePosition.topEnd(top: -15, end: 0),
            badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(10)),
            badgeContent: Text(saveCount.toString(), style: TextStyle(color: Colors.white, fontSize: 17),),
            child: Container(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                child:
                  Icon(Icons.shopping_cart, size: 40),
                  backgroundColor: Colors.lightGreen,
                onPressed:() async{
                 final result = await Navigator.push(context,
                     CupertinoPageRoute (builder: (c) => shoppingcart(selectProduct: selectProduct, data:data)));
                 setState(() {
                   // 취소 버튼을 눌렀을 경우 선택한 아이템에 관한 정보를 초기화해줌
                   if(result == 'select_cancle'){
                       selectProduct.clear();
                       saveCount = 0;
                       selectCount = 0;

                       getSelectCountData();
                   }
                 });
                },
              ),
            )
        ),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications), onPressed: (){},
              visualDensity: VisualDensity(horizontal: 3.0, vertical: 3.0),
              padding: EdgeInsets.zero,),
            IconButton(
              icon: Icon(Icons.density_medium_outlined), onPressed:(){ logOut(); },),
           ],
          //leading: Icon(Icons.list),
          title: Text('Urbansky'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          itemCount: data.length,
          itemBuilder: (context, i){
            return Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity(vertical: 4),
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
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        maxRadius: 35,
                        child: Image.network(data[i]['url'].toString(),)),
                  ),
                  title: Container(
                      padding: EdgeInsets.only(top:10, bottom: 2),
                      child: Text(data[i]['name'].toString(),style: TextStyle(fontSize: 18,))
                  ),
                  subtitle: Container(
                      padding: EdgeInsets.only(top:2, bottom: 10),
                      child: Text(data[i]['subname'].toString(),style: TextStyle(fontSize: 12,))
                  ),
                  trailing: IconButton(
                    icon:Icon(Icons.add), onPressed: (){
                      // 더하기 버튼 클릭 시 bottomsheet 출력되도록 함
                      showModalBottomSheet<void>(
                          isDismissible: false,
                          context: context,
                          builder: (BuildContext context){
                            return Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                )
                              ),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 25,
                                        child: ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context, 'OK');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              foregroundColor: Colors.grey,
                                              elevation: 0,
                                              ),
                                            child: Icon(Icons.expand_more, color: Colors.grey, size: 30,),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 40,
                                        padding: EdgeInsets.fromLTRB(20, 15, 10, 0),
                                        margin: EdgeInsets.fromLTRB(20, 15, 10, 0),
                                        child: Text('수량을 선택해 주세요.', style: TextStyle(fontSize: 17),),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                        margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            OutlinedButton(
                                              onPressed: (){
                                                setState(() {
                                                  selectCount = selectProduct[i][1];
                                                  selectCount--;

                                                  if(selectCount <= 0){ selectCount = 0;}

                                                  selectProduct[i][1] = selectCount.toInt();
                                                });
                                              },
                                              child: Icon(Icons.remove, color: Colors.grey),),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Text(selectProduct[i][1].toString())
                                            ),
                                            OutlinedButton(
                                              onPressed: (){
                                                setState(() {
                                                  selectCount = selectProduct[i][1];
                                                  selectCount++;

                                                  if(selectCount >= 10){
                                                    selectCount = 10;
                                                    popupDialog(context);
                                                  }

                                                  selectProduct[i][1] = selectCount.toInt();
                                                });
                                              },
                                              child: Icon(Icons.add, color: Colors.grey),),
                                            ]
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        height: 30,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 40,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: (){
                                                  setState(() {
                                                    saveCount = 0;
                                                    for(var i = 0; i < data.length; i++){
                                                      if(selectProduct[i][1] > 0){
                                                        var count = 0;
                                                        count = selectProduct[i][1].toInt();
                                                        saveCount += count;
                                                      }
                                                    }
                                                    Navigator.pop(context, 'OK');
                                                  });
                                                },
                                                child: Text('장바구니', style: TextStyle(fontSize: 17),),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.deepOrangeAccent,
                                                  fixedSize: Size(150, 150),
                                                  textStyle: TextStyle(color: Colors.white),
                                                ),
                                            ),
                                            ElevatedButton(
                                                onPressed: (){},
                                                child: Text('주문하기', style: TextStyle(fontSize: 17),),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.deepOrangeAccent,
                                                  fixedSize: Size(150, 150),
                                                  textStyle: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            );
                          });
                  },),
                ),
                Container(
                  height: 7,
                )
              ],
            );
          },
         ),

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.teal,
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
                label: 'Other',
            ),
          ],
        ),
      )
    );
  }
}

// 10개 이상 주문 시도 시 팝업 출력
void popupDialog(context){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          title: Column(
            children: [
              new Text('알림', style: TextStyle(color: Colors.teal, fontSize: 18,),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text('최대 구매 가능 수량은 10개입니다.'),
            ],
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context, 'OK');
            },
                child: Text('확인'))
          ],
        );
      }
  );
}

// 로그인 상태를 판별 및 갱신하기 위해 사용
class UserloginState extends ChangeNotifier{
  bool loginState = false;

  changeState(bool state){
    loginState = state;
    //재랜더링 요청
    notifyListeners();
  }
}