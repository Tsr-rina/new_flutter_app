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

final _saved = {};

class Browsing extends StatefulWidget {
  const Browsing(this.user);
  final User user;
  
  @override
  _Browsing createState() => _Browsing();

}

// 他の人のリポジトリ閲覧画面用Widget
class _Browsing extends State <Browsing> {
  List <DocumentSnapshot> documentLists = [];
  String m_name = "";
  String texts = "";
  String mail = "";
  // bool judge = true;
  bool star=false;
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
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      if(document["email"]!= widget.user.email){

                        final f_document = FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.user.email)
                        .collection('favorite')
                        .snapshots().listen((QuerySnapshot snapshot) {
                          snapshot.docs.forEach((doc) {
                            _saved[doc.get("user")]=doc.get("m_name");
                          });
                        });
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
              // return AddPostPage(widget.user);
              // return ShowStar(_saved);
              return GoodSave(widget.user);

            }),
          );
        },
      ),
    );
  }
  // void _pushSaved(){
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(
  //       builder: (context) {
  //         final tiles = _saved.map((key, value){
  //           return ListTile(
  //           );
  //         });
  //         final divided = tiles.isNotEmpty ? ListTile.divideTiles(
  //           context: context,
  //           tiles: tiles,

  //         ).toList()
  //         : <Widget>[];

  //         return Scaffold(
  //           appBar: AppBar(
  //             title: const Text("お気に入り"),
  //           ),
  //           body: ListView(children:divided),
  //         );
  //       }
  //     ),
      
  //   );
  // }
}
Widget ShowStar(_saved){
  return Scaffold(
    appBar: AppBar(
      title: Text("お気に入り"),
    ),
    body: ListView.builder(
      itemCount: _saved.length,
      itemBuilder: (BuildContext context, int index){
        final key = _saved.keys.elementAt(index);
        final already = _saved.containsKey(key);
        return Card(
          child: ListTile(
            title: Text(_saved[key]),
            subtitle: Text(key),
            trailing: IconButton(
              icon: Icon(
                already ? Icons.star : Icons.star_border,
                color: already ? Colors.yellow[600]: Colors.black45,
                // judge ? Icons.star : Icons.star_border,
                // color: judge ? Colors.yellow[600]: null,
                semanticLabel: already ? 'Remove from saved': 'save',
                ),
              onPressed: (){

                  if (already){
                    _saved.remove(key);
                  } else {
                    // print(_saved[key])
                  }
              },
            ),

          ),
        );
      },
    ),
  );
}
