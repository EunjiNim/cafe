import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafe/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
final auth = FirebaseAuth.instance;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  late UserloginState loginState;

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
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PassWord',
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
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
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  elevation: 1,
                  alignment: Alignment.center,
                  minimumSize: Size(350, 40),
                  padding: EdgeInsets.all(8.0),
                ),
                child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18),))
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
        onPressed: (){},
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
