import 'package:flutter/material.dart';
import 'browsing.dart';
import 'repository.dart';

// ProfileWidget
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  // ProfilePage(this.user);
  // // ユーザ情報
  // final User user;  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // child: Text("ログイン情報:${user.email}"),
            child: const Text("ここにログイン情報"),
          ),
        ],
      ),
    );
  }
  
}