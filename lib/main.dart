import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'config/config.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'browsing.dart';
import 'repository.dart';
import 'home.dart';


// 一番最初に実行しますよ
final configurations = Configurations();
Future<void> main() async{
  // Firebaseを初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: FirebaseOptions(
    //   apiKey: configurations.apikey, 
    //   appId: configurations.appId, 
    //   messagingSenderId: configurations.messagingSenderId, 
    //   projectId: configurations.projectId
    // )
  );
  runApp(const MyApp());
}

// 状態を管理
class MyApp extends StatelessWidget {
  // StatelessWidget親クラスをMyAppに継承している
  // コンストラクタ→インスタンス生成時に実行される初期化のメソッド
  const MyApp({Key? key}) : super(key: key);
  // コンストラクタにkeyを渡している
  @override
  Widget build(BuildContext context){
    // アプリ全体の管理
    return MaterialApp(
      title: 'ClothHub',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      // home: const MyAuthPage(),
      home: const LoginPage(),
      // home: const MyFirestorePage(),
    );
  }


  // @override
  // StatelessWidgetの性質を引き継いでいる
  // @overrideでその性質を持ったまま上書きをしている
  // メソッドの上書き
  // Widget build(BuildContext context){
  //   // 自身のUIの構成情報
  //   return  MaterialApp(
  //     title: 'Startup Name Generator',
  //     // アプリのテーマの変更(色)
  //     theme: ThemeData(
  //       appBarTheme: const AppBarTheme(
  //         backgroundColor: Colors.lightGreen,
  //         foregroundColor: Colors.white
  //       ),
  //     ),
  //     home: const RandomWords(),
  //     // home: Scaffold(
  //     //   // bodyの設定
  //     //   appBar:  AppBar(
  //     //     // header part
  //     //     title: const Text('Startup Name Generator'),
  //     //   ),
  //     //   body: const Center(
  //     //     // like a <p>
  //     //     child: RandomWords(),
  //     //   ),
  //     // ),
  //   );
  // }
}

// class _RandomWordsState extends State<RandomWords>{
//   final _suggestions = <WordPair>[];
//   final _saved = <WordPair>{};
//   final _biggerFont = const TextStyle(fontSize: 18);
//   @override
//   // widgetの設定
//   Widget build(BuildContext context){
//     // Scaffold→bodyの設定
//     return Scaffold(
//       // 画面上に常に表示されるツールバーのこと
//       appBar: AppBar(
//         title: const Text('Startup Name Generator'),
//         // 右に表示される
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list),
//             onPressed: _pushSaved,
//             tooltip: 'Saved Suggestions',
//           ),
//         ],
//       ),
//       // リスト化したいWidgetの数が多い・決まっていないときに使われる
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         // リストを作成する
//         // i→行番号
//         itemBuilder: /*1*/(context, i){
//           // isOdd→奇数のとき
//           if (i.isOdd) return const Divider(); /*2*/

//           final index = i ~/ 2; /*3*/
//           if (index >= _suggestions.length){
//             _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//           }
//           final alreadySaved = _saved.contains(_suggestions[index]);
//           return ListTile(
//             title: Text(
//               _suggestions[index].asPascalCase,
//               style: _biggerFont,
//             ),
//             trailing: Icon(
//               alreadySaved ? Icons.favorite : Icons.favorite_border,
//               color: alreadySaved ? Colors.red :null,
//               semanticLabel: alreadySaved ? 'Remove from saved':'Save',
//             ),
//             onTap: (){
//               setState(() {
//                 if (alreadySaved){
//                   _saved.remove(_suggestions[index]);
//                 }else{
//                   _saved.add(_suggestions[index]);
//                 }
//               });
//             },
//           );
//         },        
//       ),
//     );
//     // ListView→スクロールできるようにするやつ
//     // 枠の全ての方向に同じ余白を作る
//   }
//   void _pushSaved(){
//     // ページ繊維を実装する
//     // pushメソッド→進む遷移
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (context) {
//           final tiles = _saved.map(
//             (pair){
//               return ListTile(
//                 title: Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final divided = tiles.isNotEmpty
//               ? ListTile.divideTiles(
//                 context: context,
//                 tiles: tiles,
//               ).toList()
//               : <Widget>[];
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Saved Suggestions'),
//             ),
//             body: ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }
// }

class MyAuthPage extends StatefulWidget{
  const MyAuthPage({Key? key}): super(key: key);
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

// ユーザ登録画面
class _MyAuthPageState extends State<MyAuthPage>{
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキストのラベルを設定
                decoration: const InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value){
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: "パスワード(6文字以上)"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value){
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザ登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result = 
                        await auth.createUserWithEmailAndPassword(                        
                          email: newUserEmail,
                          password: newUserPassword,
                        );
                    
                    // 登録したユーザ情報
                    final User user = result.user!;
                    setState(() {
                      infoText = "登録OK:${user.email}";
                    });
                  } catch (e){
                    // 登録に失敗した場合
                    setState(() {
                      infoText = "登録NG:${e.toString()}";
                    });
                  }
                },
                child: const Text("ユーザ登録"),
              ),
              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}

// ログイン
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  // メッセージ表示
  String infoText = "";
  // 入力したメールアドレス・パスワード
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value){
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value){
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザ登録ボタン
                child: ElevatedButton(
                  child: const Text("ユーザ登録"),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザ登録に成功したとき
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          // return ChatPage(result.user!);
                          return HomePage(result.user!);
                        }),
                      );
                    } catch (e) {
                      // 登録失敗時
                      setState(() {
                        infoText = "登録に失敗しました:${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  child: const Text("ログイン"),
                  onPressed: () async {
                    try {
                      // メールとパスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context){
                          // return ChatPage(result.user!);
                          return HomePage(result.user!);
                        }),
                      );
                    } catch (e){
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました${e.toString()}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 投稿画面用Widget
class AddPostPage extends StatefulWidget {
  AddPostPage(this.user);
  final User user;
  
  @override
  _AddPostPageState createState() => _AddPostPageState();

}

class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("チャット投稿"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration:  const InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value){
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("投稿"),
                  onPressed: () async {
                    // 現在の日時
                    final date = DateTime.now().toLocal().toIso8601String();
                    // AddPostPageのデータを参照
                    final email = widget.user.email;
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                    .collection('posts') //コレクションID指定
                    .doc() //ドキュメントID自動生成
                    .set({
                      'text': messageText,
                      'email': email,
                      'date': date
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// StatefullWidget→動的
// クラスが2つ必要
// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}): super(key: key);

//   // RandomWordsでcreateStateをoverride
//   @override
//   _RandomWordsState createState() => _RandomWordsState();

// }

class SelectPage extends StatefulWidget {
  SelectPage(this.user);
  final User user;
  @override
  _SelectPageState createState() => _SelectPageState();
}
class _SelectPageState extends State<SelectPage>{

  static const  _screens=[
    // home(),
    ProfilePage(),
    // Browsing(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "profile"),
          BottomNavigationBarItem(icon: Icon(Icons.picture_in_picture), label: "browsing"),
        ],
        type: BottomNavigationBarType.fixed,
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





class MyFirestorePage extends StatefulWidget {
  const MyFirestorePage({Key? key}): super(key: key);
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  // 作成したドキュメント一覧
  List<DocumentSnapshot> documentList = [];
  // 指定したドキュメントの情報
  String  orderDocumentInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text("コレクション+ドキュメント作成"),
              onPressed: () async {
                // ドキュメント作成
                await FirebaseFirestore.instance
                .collection('users') //コレクションID
                .doc('id_abc') //ドキュメントID
                .set({'name':'鈴木','age':40});
              },
            ),
            ElevatedButton(
              child: const Text("サブコレクション+ドキュメント作成"),
              onPressed: () async {
                // サブコレクション内にドキュメント作成
                await FirebaseFirestore.instance
                .collection('users') //コレクションID
                .doc('id_abc') // ドキュメントID >>usersコレクション内のドキュメント
                .collection('orders') // サブコレクションID
                .doc('id_123') // ドキュメントID >> サブコレクション内のドキュメント
                .set({'price':600, 'date':'9/13'}); //データ
              },
            ),
            ElevatedButton(
              child: const Text("ドキュメント一覧取得"),
              onPressed: () async {
                // コレクション内のドキュメント一覧を取得
                final snapshot = await FirebaseFirestore.instance.collection('users').get();
                // 取得したドキュメント一覧をUIに反映
                setState(() {
                  documentList = snapshot.docs;
                });
              },
            ),
            // コレクション内のドキュメント一覧を表示
            Column(
              children: documentList.map((document){
                return ListTile(
                  title: Text('${document['name']}さん'),
                  subtitle: Text('${document['age']}歳'),
                );
              }).toList(),
            ),
            ElevatedButton(
              child: const Text("ドキュメントを指定して取得"),
              onPressed: () async {
                // コレクションIDをドキュメントIDを指定して取得
                final document = await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .collection('orders')
                .doc('id_123')
                .get();
                setState(() {
                  orderDocumentInfo = '${document['date']} ${document['price']}円';
                });
              },
            ),
            // ドキュメントの情報を表示
            ListTile(title: Text(orderDocumentInfo)),
            ElevatedButton(
              child: const Text('ドキュメント更新'),
              onPressed: () async {
                // ドキュメント更新
                await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .update({'age': 41});
              },
            ),
            ElevatedButton(
              child: const Text("ドキュメント削除"),
              onPressed: () async {
                await FirebaseFirestore.instance
                .collection('users')
                .doc('id_abc')
                .collection('orders')
                .doc('id_123')
                .delete();
              },
            ),
          ],
        ),
      ),
    );
  }
}