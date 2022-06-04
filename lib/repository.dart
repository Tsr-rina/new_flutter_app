import 'package:flutter/material.dart';
import 'profile.dart';
import 'browsing.dart';

// リポジトリ用画面
class RepositoryPage extends StatefulWidget {
  const RepositoryPage({Key? key}): super(key: key);
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
    );
  }
}