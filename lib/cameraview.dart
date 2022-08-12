import 'dart:ffi';
import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class CameraView extends StatefulWidget {
  const CameraView(this.user);
  final User user;
  @override
  _CameraView createState() => _CameraView(); 
}

class _CameraView extends State<CameraView>{

  // File _image = File("");

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        // _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text("CameraView"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text("ここはカメラを使うページです"),
          ),
          Container(
          width: double.infinity,
          child: ElevatedButton(
            child: const Text("戻る"),
            onPressed: () async {
              Navigator.of(context).pop();
            }
          ),
        ),
    
        ],
      ),
    );
  }
}