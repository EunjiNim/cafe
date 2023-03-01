import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafe/main.dart';
import 'package:cafe/order.dart';

import 'package:firebase_auth/firebase_auth.dart';
final auth = FirebaseAuth.instance;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late UserloginState loginState;
  final myIDController = TextEditingController();
  final myPWController = TextEditingController();

  // 아이디 체크
  loginCheck() async{
    try{
      await auth.signInWithEmailAndPassword(
          email: myIDController.text,
          password: myPWController.text,
      );
      // 주문하기 페이지로 이동함
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/order');
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        wrongIDDialog(context);
      }
    }
  }

  // 로그아웃
  logOut() async{
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<UserloginState>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
         ),
          title: Text('Login', style: TextStyle(color:Colors.white, fontSize: 20),),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: myIDController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID (guest@test.com)',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: myPWController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PassWord (test1234)',
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 8.0),
                child: Text('SNS 로그인 및 회원가입 서비스는 현재 이용이 불가합니다.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),),
              ),
              Column(
                children: [
                  // 중복 사용하는 버튼들은 커스텀 위젯으로 따로 빼서 사용
                  Snsbutton(
                    backgroundColor : Colors.white,
                    image : 'assets/glogo.png',
                    text: 'Login with Google',
                    textColor: Colors.black87,
                  ),
                  Snsbutton(
                    backgroundColor : Color(0xFF334D92),
                    image : 'assets/flogo.png',
                    text: 'Login with Facebook',
                    textColor: Colors.white,
                  ),
                  Snsbutton(
                    backgroundColor : Color(0xFF03C75A),
                    image : 'assets/nlogo.png',
                    text: 'Login with Naver',
                    textColor: Colors.white,
                  ),
                  Snsbutton(
                    backgroundColor : Color(0xFFFFEB00),
                    image : 'assets/clogo.png',
                    text: 'Login with Cacao',
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('처음 오셨나요?', style: TextStyle(color: Colors.grey)),
                  TextButton(
                      onPressed: (){ popupDialog(context); },
                      child: Text('회원가입')),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton (
                onPressed: (){
                  loginCheck();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  elevation: 1,
                  alignment: Alignment.center,
                  minimumSize: Size(350, 40),
                  padding: EdgeInsets.all(8.0),
                ),
                child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18),)),
          ],
        ),
      ),
    );
  }
}

// sns 버튼 커스텀 위젯
class Snsbutton extends StatelessWidget {
  const Snsbutton({Key? key, this.backgroundColor, this.image, this.text, this.textColor}) : super(key: key);
  final backgroundColor;
  final image;
  final text;
  final textColor;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: (){ popupDialog(context); },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image),
            Text(text, style: TextStyle(color: textColor, fontSize: 15.0),),
            Opacity(
              opacity: 0.0,
              child: Image.asset(image),)
          ],
        ),
      ),
    );
  }
}

// 구현되지 않은 항목 버튼 클릭 시 팝업 출력
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
              new Text('현재 이용이 불가능한 서비스입니다.'),
            ],
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: Text('확인'))
          ],
        );
      }
  );
}

// 로그인 실패 시 출력
void wrongIDDialog(context){
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
              new Text('아이디 혹은 비밀번호를 다시 확인해주세요'),
            ],
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            },
                child: Text('확인'))
          ],
        );
      }
  );
}

