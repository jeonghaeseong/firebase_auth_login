import 'file:///E:/study/flutter/firebase_auth_login/lib/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

// Splash 앱 구동시 아이콘 보이는 화면을 가리키는 단어
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.data == null) {
          return ChangeNotifierProvider<JoinOrLogin>.value(
            value: JoinOrLogin(),
            child: AuthPage(),
          );
        }
        else {
          return MainPage(email: snapshot.data.email,);
        }
      },
    );
  }
}

