import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main.dart';
import 'post.dart';




// リポジトリ用画面
class Image_Reader extends StatefulWidget {
  const Image_Reader(this.user);
  final User user;
  @override
  _Image_ReaderState createState() => _Image_ReaderState(); 
}

class _Image_ReaderState extends State<Image_Reader>{
  String m_name = "";
  String texts = "";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repository"),
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
          Center(
            child: Text("画像を扱うページです"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context){
              // 引数からユーザ情報を渡す
              return AddPostPage(widget.user);
            }),
          );
        },
      ),
    );
  }
}


class DetailPage extends StatefulWidget {
  DetailPage(this.email, this.m_name, this.texts);
  final  email;
  final String m_name;
  final String texts;
  // DetailPage(this.m_name, this.texts);
  // final String m_name;
  // final String texts;
  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage>{
  

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              // 作品名
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.m_name,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
              ),
              // テキスト
              Container(
                margin: const EdgeInsets.only(top:20),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.texts,
                  style: const TextStyle(
                    fontSize: 18
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top:20),
              //   child: DownloadFile(widget.email, widget.m_name),
              // ),
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
        ),
      )
    );
  }
  // DownloadFile(email, m_name){
  // final FirebaseStorage storage = FirebaseStorage.instance;  
  // Reference ref = storage.ref().child("${email}_${m_name}.png");
  // String imageUrl = ref.getDownloadURL().toString();
  // setState(() {
  //   final _image = Image.network(imageUrl);
  // });
  // }
}