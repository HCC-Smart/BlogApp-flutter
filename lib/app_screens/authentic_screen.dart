import 'package:blogapp/app_screens/Home_screen.dart';
import 'package:blogapp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticScreen extends StatefulWidget {
  const AuthenticScreen({super.key});

  @override
  State<AuthenticScreen> createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String _buttontext = 'Login';
  String _switchText = 'Don\'t have any account? register';

  bool _loading = false;

  void _validateFields() {
    if (_emailController.text.isEmpty && _passController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please enter email and password');
    } else if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please enter email');
    } else if (_passController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please enter password');
    } else {
       setState(() {
            _loading = true;
          });
      if (_buttontext == "Login")
        _login();
      else
        _register();
    }
  }

  void _moveToHomeScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _login() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passController.text)
        .then((UserCredential userCredential) {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: 'login successfully');
      _moveToHomeScreen();
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  void _register() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passController.text)
        .then((UserCredential userCredential) {
           setState(() {
            _loading = false;
          });
      Fluttertoast.showToast(msg: 'Registered successfully');
      _moveToHomeScreen();
    }).catchError((error) {
       setState(() {
            _loading = false;
          });
      Fluttertoast.showToast(msg: error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blog App')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Image.network(
                  'https://thumbs.dreamstime.com/b/pizza-rustic-italian-mozzarella-cheese-basil-leaves-35669930.jpg',
                  width: 200.0,
                  height: 200.0,
                ),
                SizedBox(height: 30.0),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'password'),
                ),
                SizedBox(height: 40),
                _loading ? circularProgress() : GestureDetector(
                  onTap: _validateFields,
                  child: Container(
                    color: Colors.pink,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                        child: Text(
                      _buttontext,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        if (_buttontext == 'Login') {
                          _buttontext = 'Register';
                          _switchText = 'Already have an account? Login';
                        } else {
                          _buttontext = 'Login';
                          _switchText = 'Don\'t have an account? Login';
                        }
                      });
                    },
                    child: Text(
                      _switchText,
                      style: TextStyle(fontSize: 18.0),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
