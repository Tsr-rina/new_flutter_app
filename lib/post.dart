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


// 投稿画面用Widget
class AddPostPage extends StatefulWidget {
  AddPostPage(this.user);
  final User user;
  
  @override
  _AddPostPageState createState() => _AddPostPageState();

}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';
  // 作品名入力
  String m_name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("投稿する"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 作品名入力
              TextFormField(
                decoration: const InputDecoration(labelText: "作品名"),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                onChanged: (String value){
                  setState(() {
                    m_name = value;
                  });
                },
              ),
              
              // 投稿メッセージ入力
              TextFormField(
                decoration:  const InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 20,
                onChanged: (String value){
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("投稿"),
                  onPressed: () async {
                    // 現在の日時
                    final date = DateTime.now().toLocal().toIso8601String();
                    // AddPostPageのデータを参照
                    // ニックネーム
                    final email = widget.user.email;
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                    .collection('posts') //コレクションID指定
                    .doc() //ドキュメントID自動生成
                    .set({
                      'user':'',
                      'date': date,
                      'm_name': m_name,
                      'text': messageText,
                      'email': email,
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
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