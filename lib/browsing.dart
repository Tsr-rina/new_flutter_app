import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'browsing.dart';
import 'repository.dart';



// チャット画面用Widget
// class ChatPage extends StatelessWidget {
//   // 引数からユーザ情報を受け取れるようにする
//   ChatPage(this.user);
//   // ユーザ情報
//   final User user;
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Browsing"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               // ログアウト処理
//               // 内部で保持しているログイン情報等が初期化される
//               await FirebaseAuth.instance.signOut();
//               // ログイン画面に遷移してチャット画面を破棄
//               await Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context){
//                   return const LoginPage();
//                 }),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children:[
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: Text("ログイン情報:${user.email}"),
//           ),
//           Expanded(
//             // StreamBuilder
//             // 非同期処理の結果をもとにWidget
//             child: StreamBuilder<QuerySnapshot>(
//               // 投稿メッセージ一覧を取得(非同期処理)
//               // 投稿日時でソート
//               stream: FirebaseFirestore.instance
//               .collection('posts')
//               .orderBy('date')
//               .snapshots(),
//               builder: (context, snapshot) {
//                 // データが取得できた場合
//                 if (snapshot.hasData) {
//                   final List<DocumentSnapshot> documents = snapshot.data!.docs;
//                   // 取得した投稿メッセージ一覧を元にリスト表示
//                   return ListView(
//                     children: documents.map((document) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(document['text']),
//                           subtitle: Text(document['email']),
//                           // 自分の投稿メッセージの場合は削除ボタンを表示
//                           trailing: document['email'] == user.email?
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () async {
//                               // 投稿メッセージのドキュメントを削除
//                               await FirebaseFirestore.instance
//                               .collection('posts')
//                               .doc(document.id)
//                               .delete();
//                             },
//                           )
//                           :null,
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 }
//                 // データが読み込み中の場合
//                 return const Center(
//                   child: Text("読み込み中..."),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       // body: Center(
//       //   // ユーザ情報を表示
//       //   child: Text("ログイン情報${user.email}"),
//       // ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           // 投稿画面に遷移
//           await Navigator.of(context).push(
//             MaterialPageRoute(builder: (context){
//               // 引数からユーザ情報を渡す
//               return AddPostPage(user);
//             }),
//           );
//         },
//       ),
//     );
//   }
// }


class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) :super(key: key);
  @override
  _SelectPageState createState() => _SelectPageState();
}
class _SelectPageState extends State<SelectPage>{
  static const _screens = [
    RepositoryPage(),
    ProfilePage(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.album), label: "repository"),
          BottomNavigationBarItem(icon: Icon(Icons.private_connectivity_sharp), label: "profile"),
          BottomNavigationBarItem(icon: Icon(Icons.picture_in_picture), label: "browsing"),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}