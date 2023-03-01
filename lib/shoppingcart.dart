import 'package:cafe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class shoppingcart extends StatefulWidget {
  const shoppingcart({Key? key, this.selectProduct, this.data}) : super(key: key);
  final selectProduct;
  final data;

  @override
  State<shoppingcart> createState() => _shoppingcartState();
}

class _shoppingcartState extends State<shoppingcart> {
  late UserloginState loginState;

  var itemcount = 0;
  var selectList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setList();
  }

  // 장바구니에 등록한 아이템이 있을 경우에만 출력해 주기 위해 리스트 생성
  setList(){
    itemcount = widget.data.length;

    // firebase에서 받아온 데이터에 내가 선택한 상품 개수 정보를 합쳐 넣어줌
    for(var i = 0; i < itemcount; i++){
      if(widget.selectProduct[i][1] > 0){
        Map<String, dynamic> tempData = widget.data[i];
        tempData.addAll({'count' : widget.selectProduct[i][1]});
        selectList.add(tempData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<UserloginState>(context);
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
        title: Text('Shopping Cart', style: TextStyle(color:Colors.white, fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: selectList.isEmpty ? Center(child: Text('장바구니가 비어있습니다.', style: TextStyle(fontSize: 23, color: Colors.grey),))
          : ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          itemCount: selectList.length,
          itemBuilder: (context, i){
            return Column(
              children: [
                Container(
                  child: ListTile(
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
                          child: Image.network(selectList[i]['url'].toString(),)),
                    ),
                    title: Container(
                        padding: EdgeInsets.only(top:10, bottom: 2),
                        child: Text(selectList[i]['name'].toString(),style: TextStyle(fontSize: 18,))
                    ),
                    subtitle: Container(
                        padding: EdgeInsets.only(top:2, bottom: 10),
                        child: Text(selectList[i]['subname'].toString(),style: TextStyle(fontSize: 12,))
                    ),
                    trailing: Text(selectList[i]['count'].toString(), style: TextStyle(fontSize: 17),),
                  ),
                ),
                Container(
                  height: 7,
                )
              ],
            );          }
        ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 선택한 아이템이 있을때만 버튼 클릭 가능
            selectList.isEmpty ? Text('주문하기', style: TextStyle(color: Colors.grey, fontSize: 17)) :
            ElevatedButton(
                onPressed: (){
                  //로그인 상태가 아니라면 로그인 페이지로 이동하고, 로그인 상태라면 주문 진행
                  if(loginState.loginState == false){
                    Navigator.pushNamed(context, '/login');
                  }else{

                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.white,
                    foregroundColor: Colors.teal,
                    elevation: 0,
                    ),
                child: Text('주문하기', style: TextStyle(color: Colors.teal, fontSize: 17),)),
            ElevatedButton(
                onPressed: (){
                  Navigator.pop(context, 'select_cancle');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.white,
                  foregroundColor: Colors.teal,
                  elevation: 0,
                ),
                child: Text('취소', style: TextStyle(color: Colors.teal, fontSize: 17),)),
          ],
        ),
      ),
    );
  }
}
