import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'config/config.dart';
// import 'firebase_options.dart';
// import 'profile.dart';
import 'browsing.dart';
import 'repository.dart';
import 'browsing_2.dart';
// import 'home.dart';
import 'main.dart';
import 'post.dart';

final _saved = {};

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
  String m_name = "";
  String texts = "";
  String mail = "";
  @override
  Widget build(BuildContext context){
      return Scaffold(
      appBar: AppBar(
        title: const Text("Star"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移してチャット画面を破棄
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
        children:[
          Expanded(
            // StreamBuilder
            // 非同期処理の結果をもとにWidget
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得(非同期処理)
              // 投稿日時でソート
              stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.email)
              .collection('favorite')
              .snapshots(),
              builder: (context, snapshot) {

                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                        _saved[document["user"]]=_saved[document["m_name"]];

                        // ここに↓いれるとDetailPageに意図した値が届かない
                        // m_name = document['m_name'];
                        // texts = document['text'];
                        // print(_saved[document["m_name"]]);
                        // int fig = _saved[document['m_name']];
                        // _saved[document["m_name"]] = 0;
                        
                        // if (_saved[document["m_name"]] %2 == 0){
                        //   star = false;
                        // }else{
                        //   star = true;
                        // }
                        // final already = _saved.containsKey(document["m_name"]);
                        final already = _saved.containsKey(document["user"]);
                        return Card(
                          child: ListTile(
                            title: Text(document['m_name']),
                            subtitle: Text(document['user']),
                            trailing: IconButton(
                              icon: Icon(

                                already ? Icons.star : Icons.star_border,
                                color: already ? Colors.yellow[600]: Colors.black45,
                                // judge ? Icons.star : Icons.star_border,
                                // color: judge ? Colors.yellow[600]: null,
                                semanticLabel: already ? 'Remove from saved': 'save',
                                ),
                              onPressed: () async{
                                // GoodSave(widget.user);
                                // _saved[document['m_name']] += 1;
                                setState(() {
                                  if (already){
                                    FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.user.email)
                                    .collection('favorite')
                                    .doc(document["m_name"])
                                    .delete();
                                    _saved.remove(document["user"]);
                                  } else {
                                    FirebaseFirestore.instance
                                    .collection('users') //コレクションID指定
                                    .doc(widget.user.email) //ドキュメントIDを指定
                                    .collection('favorite')
                                    .doc(document["m_name"])
                                    .set({
                                      'm_name': document['m_name'],
                                      'user': document['user'],
                                      'text': document['text'],
                                    });
                                    _saved[document["user"]]=document["m_name"];
                                    // _saved.addAll(document["m_name"]);
                                  }
                                });
                              },
                            ),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context){
                                  m_name = document["m_name"];
                                  texts = document["text"];
                                  final email = widget.user.email;
                                  return DetailPage(email, m_name,texts);
                                }),
                              );
                            },
                          ),
                        );
                    }).toList(),
                  );                  
                }
                // データが読み込み中の場合
                return const Center(
                  child: Text("読み込み中..."),
                );
              },
            ),
          ),
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
