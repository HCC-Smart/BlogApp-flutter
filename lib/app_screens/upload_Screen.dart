import 'package:blogapp/app_screens/Home_screen.dart';
import 'package:blogapp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  late File _imageFile;
  bool     _laoding   = false;
  ImagePicker imagePicker = ImagePicker();
  Future<void> _chooseImage() async {
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void _validatte() {
    if (_imageFile == null && _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please add image and enter descrption');
    } else if (_imageFile == null) {
      Fluttertoast.showToast(msg: 'please add an image');
    } else if (_descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please enter description');
    } else {
      uploadImage();
    }
  }

  void uploadImage() {
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("asetts").child(imageFileName);
    UploadTask.then((TaskSnapshot, taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        _saveData(imageUrl);
      });
    }).catchError((error) {
      Fluttertoast.showToast(msg: error);
    });
  }

  void _saveData(String imageUrl) {
       var dateformat =   DateFormat('MMM d , yyyy');      
              var timeFormat =   DateFormat('EEEE,     hh:mm a');
            String date dateFormat(DateTime.now()).toString();   
                        String time timeFormat(DateTime.now()).toString();   

 
      
    FirebaseFirestore.instance.collection('posts').add({
   
      'imageUrl': imageUrl,
      'descrption': _descriptionController.text,
      "date": date,
      "time": time ,
    })  .whenComplete(() {
       setState(() {
        _laoding = false;
      });
                Fluttertoast.showToast(msg: 'post added succesfully');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                  return HomeScreen()
                }));

      }).catchError((error){
   setState(() {
        _laoding = false;
      });
            Fluttertoast.showToast(msg: error);

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload')),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            _imageFile == null
                ? Container(
                    width: double.infinity,
                    height: 250.0,
                    color: Colors.grey,
                    child: Center(
                        child: ElevatedButton(
                      onPressed: () {
                        _chooseImage();
                      },
                      child: Text(
                        "Choose Image",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    )),
                  )
                : GestureDetector(
                    onTap: () {
                      _chooseImage();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 250.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_imageFile),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 40.0,
            ),
           _laoding? circularProgress() : GestureDetector(
                onTap: _validatte,
                child: Container(
                  color: Colors.pink,
                  width: double.infinity,
                  height: 50.0,
                  child: Center(
                    child: Text(
                      "Add new post",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
