import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'browsing.dart';
import 'repository.dart';
import 'home.dart';
import 'post.dart';

class NickName extends StatefulWidget {
  NickName(this.user);
  final User user;
  @override
  _NickNameState createState() => _NickNameState();
}

class _NickNameState extends State<NickName>{

  String nickname = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NickNameRegister"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: const Text("ユーザ登録が完了しました"),                
              ),
              Container(
                width: double.infinity,
                child: const Text("ニックネームを登録してください"),                
              ),
              // ニックネーム入力
              TextFormField(
                decoration: const InputDecoration(labelText: "ニックネーム"),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                onChanged: (value){
                  setState(() {
                    nickname = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("登録"),
                  onPressed: () async {
                    // AddPostPageのデータを参照
                    // ニックネーム
                    final email = widget.user.email;
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                    .collection('users') //コレクションID指定
                    .doc(email) //ドキュメントはメールアドレス
                    .set({
                      'nickname': nickname,
                    });
                    // 1つ前の画面に戻る
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context){
                        // return ChatPage(result.user!);
                        final User nickname;
                        return HomePage(nickname);
                      }),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}