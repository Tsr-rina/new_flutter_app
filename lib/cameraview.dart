import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraView extends StatefulWidget {
  const CameraView(this.user);
  final User user;
  @override
  _CameraView createState() => _CameraView(); 
}

class _CameraView extends State<CameraView>{

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


class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({Key? key, this.camera}):super(key:key);

  final CameraDescription = camera;

  @override
  _TakePictureScreen createState() => _TakePictureScreen();

}

class _TakePictureScreen extends State<TakePictureScreen>{
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  Void initState(){
    super.initState();

    _controller = CameraController(
      widget.camera, 
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context){
    return SizedBox();
  }

}