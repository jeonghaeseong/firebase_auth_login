import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/helper/login_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Consumer<JoinOrLogin>(
                builder: (context, joinOrLogin, child) => CustomPaint(
                  size: size,
                  painter: LoginBackground(isJoin: joinOrLogin.isJoin),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _logoImage,
                  Stack(
                    children: <Widget>[
                      _inputForm(size),
                      _authButton(size),
                    ],
                  ),
                  Container(
                    height: size.height * 0.1,
                  ),
                  Consumer<JoinOrLogin>(
                    builder: (context, joinOrLogin, child) => GestureDetector(
                        onTap: () {
                          joinOrLogin.toggle();
                        },
                        child: Text(
                          joinOrLogin.isJoin ? "Alreday Have an Account? Sign in" : "Dont't Have an Account? Create One",
                          style: TextStyle(color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
                        )
                    ),
                  ),
                  Container(height: size.height * 0.05,)
                ],
              )
            ],
          )
      ),
    );
  }

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snacBar = SnackBar(content: Text('Please try again later.'),);
      Scaffold.of(context).showSnackBar(snacBar);
    }

//    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(user.email)));
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null) {
      final snacBar = SnackBar(content: Text('Please try again later.'),);
      Scaffold.of(context).showSnackBar(snacBar);
    }

//    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(user.email)));
  }

  Widget get _logoImage => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
      child: FittedBox(
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/7pv.gif'),
        ),
      ),
    ),
  );

  Widget _authButton(Size size) => Positioned(
    left: size.width * 0.15,
    right: size.width * 0.15,
    bottom: 0,
    child: SizedBox(
      height: 50,
      child: Consumer<JoinOrLogin>(
        builder: (context, joinOrLogin, child) => RaisedButton(
          child: Text(
            joinOrLogin.isJoin ? 'Join' : 'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
          onPressed: () {
            if(_globalKey.currentState.validate()) {
              joinOrLogin.isJoin ? _register(context) : _login(context);
            }
          },
        ),
      )
    ),
  );

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 32.0),
          child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(icon: Icon(Icons.account_circle), labelText: "Email"),
                  validator: (String value) {
                    if(value.isEmpty) {
                      return "Please input correct Email.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(icon: Icon(Icons.vpn_key), labelText: "Password"),
                  validator: (String value) {
                    if(value.isEmpty) {
                      return "Please input correct Password.";
                    }
                    return null;
                  },
                ),
                Container(height: 8,),
                Consumer<JoinOrLogin>(
                  builder: (context, joinOrLogin, child) => Opacity(
                    opacity: joinOrLogin.isJoin ? 0 : 1,
                    child: Text('Forget Password')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
