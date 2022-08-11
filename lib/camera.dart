import 'dart:async';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:new_flutter_app/cameraview.dart';
import 'cameraview.dart';


class Camera extends StatefulWidget {
  const Camera(this.user);
  final User user;
  @override
  _Camera createState() => _Camera(); 
}

class _Camera extends State<Camera>{

  @override
  Widget build(BuildContext context){


    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移してRepository画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context){
                  return const LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("カメラを使う"),
              onPressed: () async {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context){
                    return CameraView(widget.user);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
}