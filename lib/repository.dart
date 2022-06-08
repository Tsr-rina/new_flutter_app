import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'browsing.dart';
import 'main.dart';

// リポジトリ用画面
class RepositoryPage extends StatefulWidget {
  const RepositoryPage(this.user);
  final User user;
  @override
  _RepositoryPageState createState() => _RepositoryPageState(); 
}

class _RepositoryPageState extends State<RepositoryPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repository"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text("ここに作品を並べる"),
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