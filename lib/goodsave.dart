import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'config/config.dart';
// import 'firebase_options.dart';
// import 'profile.dart';
import 'browsing.dart';
// import 'repository.dart';
// import 'home.dart';


class GoodSave extends StatefulWidget {
  const GoodSave(this.user);
  final User user;
  
  @override
  _GoodSave createState() => _GoodSave();

}

// お気に入り登録・表示Widget
// 保存リストにあるかどうかを確認するWidget
// あればYes
// なければNo
class _GoodSave extends State <GoodSave> {
  @override
  Widget build(BuildContext context){
      return Scaffold(
      appBar: AppBar(
        title: const Text("スター済み"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // child: Text("ログイン情報:${user.email}"),
            child: const Text("ここにログイン情報"),
          ),
        ],
      ),
    );
  }
}