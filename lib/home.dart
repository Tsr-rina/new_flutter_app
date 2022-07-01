import 'package:new_flutter_app/browsing.dart';
import 'package:new_flutter_app/goodsave.dart';
// import 'package:new_flutter_app/nickname.dart';

import 'main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';
import 'profile.dart';
import 'repository.dart';
import 'post.dart';
import 'browsing_2.dart';
import 'goodsave.dart';


class HomePage extends StatefulWidget {
  const HomePage(this.user);
  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
    

  final menu_list = ["Star","Post", "Repository", "Browsing"];


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
              itemCount: menu_list.length,
              itemBuilder: (BuildContext, int index){

                return Card(
                  child: ListTile(
                    title: Text(menu_list[index]),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){

                          if (index==0){
                            return GoodSave(widget.user);
                          }
                          else if (index==1){
                            return AddPostPage(widget.user);
                          }
                          else if (index==2){
                            return RepositoryPage(widget.user);
                          }
                          else{
                            return Browsing(widget.user);
                          }

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