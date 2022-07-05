import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';
import 'post.dart';

// リポジトリ用画面
class RepositoryPage extends StatefulWidget {
  const RepositoryPage(this.user);
  final User user;
  @override
  _RepositoryPageState createState() => _RepositoryPageState(); 
}

class _RepositoryPageState extends State<RepositoryPage>{
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
                      if(document.id == widget.user.email){
                        m_name = document['m_name'];
                        texts = document['text'];  
                        return Card(
                          child: ListTile(
                            title: Text(document['m_name']),
                            subtitle: Text(document['user']),
                            // 自分の投稿メッセージの場合は削除ボタンを表示
                            trailing: document['email'] == widget.user.email?
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // 投稿メッセージのドキュメントを削除
                                await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(document.id)
                                .delete();
                              },
                            )
                            : null,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (context){
                                  return DetailPage(widget.user ,m_name, texts);
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
  DetailPage(this.user, this.m_name, this.texts);
  final User user;
  final String m_name;
  final String texts;
  // DetailPage(this.m_name, this.texts);
  // final String m_name;
  // final String texts;
  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage>{

  Image _image;

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
              Container(

                child: Row(
                  
                ),
              ),
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
  Future _downloadFile(email, m_name) async {
    final FirebaseStorage storage = FirebaseStorage.instance;  
    Reference ref = storage.ref().child("${email}_${m_name}.png");
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      _image = Image.network(imageUrl);
    });
  }
}