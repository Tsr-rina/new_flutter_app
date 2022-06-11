import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'repository.dart';


class HomePage extends StatefulWidget {

  const HomePage(this.user);
  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  final menu_list = ["Profile", "Post", "Repository", "Browsing"];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext, int index){

                return Card(
                  child: ListTile(
                    title: Text(menu_list[0]),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          // 引数からユーザ情報を渡す
                          // if (index==0){
                          return const ProfilePage();
                          // }
                        }),
                      );
                    },
                  ),
                );
                // Card(
                //   child: ListTile(
                //     title: Text(menu_list[1]),
                //   ),
                // );
                // Card(
                //   child: ListTile(
                //     title: Text(menu_list[2]),
                //   ),
                // );
                // Card(
                //   child: ListTile(
                //     title: Text(menu_list[3]),
                //   ),
                // );
              },

            ),
          ),
        ],
      ),
    );
  }
}