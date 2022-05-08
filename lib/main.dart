
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';


// 一番最初に実行しますよ
Future<void> main() async{
  // Firebaseを初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyAuthPage(),
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

class _RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  // widgetの設定
  Widget build(BuildContext context){
    // Scaffold→bodyの設定
    return Scaffold(
      // 画面上に常に表示されるツールバーのこと
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        // 右に表示される
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      // リスト化したいWidgetの数が多い・決まっていないときに使われる
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // リストを作成する
        // i→行番号
        itemBuilder: /*1*/(context, i){
          // isOdd→奇数のとき
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length){
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red :null,
              semanticLabel: alreadySaved ? 'Remove from saved':'Save',
            ),
            onTap: (){
              setState(() {
                if (alreadySaved){
                  _saved.remove(_suggestions[index]);
                }else{
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },        
      ),
    );
    // ListView→スクロールできるようにするやつ
    // 枠の全ての方向に同じ余白を作る
  }
  void _pushSaved(){
    // ページ繊維を実装する
    // pushメソッド→進む遷移
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair){
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

// 
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

// StatefullWidget→動的
// クラスが2つ必要
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}): super(key: key);

  // RandomWordsでcreateStateをoverride
  @override
  _RandomWordsState createState() => _RandomWordsState();

}

class MyAuthPage extends StatefulWidget{
  const MyAuthPage({Key? key}): super(key: key);
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}