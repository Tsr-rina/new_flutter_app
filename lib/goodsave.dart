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
        title: const Text("スター済み"),
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
        children: [
          Expanded(
            // StreamBuilder
            // 非同期処理の結果をもとにWidget
            child: StreamBuilder<QuerySnapshot>(
              // 投稿メッセージ一覧を取得(非同期処理)
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
                      if(document.id!= widget.user.email){
                        // ここに↓いれるとDetailPageに意図した値が届かない
                        // m_name = document['m_name'];
                        // texts = document['text']; 
                        return Card(
                          child: ListTile(
                            title: Text(document['m_name']),
                            subtitle: Text(document['user']),
                            // trailing: IconButton(
                            //   icon: const Icon(Icons.star),
                            //   onPressed: (){
                            //     // GoodSave(widget.user);
                            //     Colors.yellow;
                            //   },
                            // ),
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
    );
  }
}