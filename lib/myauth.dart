import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_app/nickname.dart';
import 'config/config.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'browsing.dart';
import 'repository.dart';
import 'home.dart';
import 'post.dart';

class MyAuthPage extends StatefulWidget{
  const MyAuthPage({Key? key}): super(key: key);
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

// ユーザ登録画面
class _MyAuthPageState extends State<MyAuthPage>{
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                // テキストのラベルを設定
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value){
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード(6文字以上)"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value){
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザ登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result = 
                        await auth.createUserWithEmailAndPassword(                        
                          email: newUserEmail,
                          password: newUserPassword,
                        );
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context){
                        // return ChatPage(result.user!);
                        return NickName(result.user!);
                      }),
                    );
                    
                    // 登録したユーザ情報
                    final User user = result.user!;
                    setState(() {
                      infoText = "登録OK:${user.email}";
                    });
                  } catch (e){
                    // 登録に失敗した場合
                    setState(() {
                      infoText = "登録NG:${e.toString()}";
                    });
                  }
                },
                child: const Text("ユーザ登録"),
                ),
              ),
              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}