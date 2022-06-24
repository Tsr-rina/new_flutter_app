import 'dart:html';

import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';
// import 'profile.dart';
import 'repository.dart';
import 'post.dart';
import 'goodsave.dart';


class Browsing extends StatefulWidget {
  const Browsing(this.user);
  final User user;
  
  @override
  _Browsing createState() => _Browsing();

}

// 他の人のリポジトリ閲覧画面用Widget
class _Browsing extends State <Browsing> {
  final _saved = {};
  final _biggerFont = const TextStyle(fontSize: 18);
  String m_name = "";
  String texts = "";
  String mail = "";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browsing"),
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
              .collection('posts')
              .snapshots(),
              builder: (context, snapshot) {

                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  final favorite = FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.email)
                  .collection('favorite')
                  .doc();

                  for (int i=0; i<documents.length; i++){
                    _saved[favorite[i]['m_name']] = 0;
                  }
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      if(document.id!= widget.user.email){
                        // ここに↓いれるとDetailPageに意図した値が届かない
                        // m_name = document['m_name'];
                        // texts = document['text'];

                        
                        return Card(
                          child: ListTile(
                            title: Text(document['m_name']),
                            subtitle: Text(document['user']),
                            trailing: IconButton(
                              icon: const Icon(
                                _saved ? Icons.star : Icons.star_border,
                                color: _saved ? Colors.yellow[600]: null,
                                semanticLabel: _saved ? 'Remove from saved': 'save',
                                ),
                              onPressed: (){
                                // GoodSave(widget.user);
                              },
                            ),
                            onTap: () async {

                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context){
                                  m_name = document["m_name"];
                                  texts = document["text"];
                                  return DetailPage(m_name,texts);
                                }),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return const Text("");
                      }
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
      // body: Center(
      //   // ユーザ情報を表示
      //   child: Text("ログイン情報${widget.user.email}"),
      // ),
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
