import 'package:blogapp/app_screens/authentic_screen.dart';
import 'package:blogapp/app_screens/upload_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   Widget _cardUI(Post post){
    return Card(
      margin: EdgeInsets.only(top: 20.0),
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  post.date,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic
                  ),
                ),
                 Text(
                                    textAlign: TextAlign.center,

                  post.time,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Image.network(post.imageUrl, width:200, height: 300, fit: BoxFit.cover, ),
            SizedBox(height: 10.0,),
            Text(
              post.description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0
              ),
            )

          ],
        ),
      ),

    )
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UploadScreen()));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance
                    .signOut()
                    .whenComplete(() => {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => AuthenticScreen())),
                        })
                    .catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
     
    );
  }
}
