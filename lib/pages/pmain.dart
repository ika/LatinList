//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutterapplatinlist/database/dbhelper.dart';
//import 'package:flutterapplatinlist/models/model.dart';
//import 'package:provider/provider.dart';
//import '../search_page.dart';
//
//import 'pdetail.dart';
//import '../main.dart';
//
//class MyAppState extends State<MyApp> {
//  final scaffoldKey = GlobalKey<ScaffoldState>();
//  final DatabaseHelper db = DatabaseHelper();
//
////  List<Repo> repoList = [
////    Repo(1, 'Barron', 'Brown'),
////    Repo(2, 'Todd', 'Black'),
////    Repo(3, 'Ahmad', 'Edwards'),
////    Repo(4, 'Anthony', 'Johnson'),
////    Repo(5, 'Annette', 'Brooks'),
////    Repo(6, 'Ian', 'Armstrong'),
////  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      // bottom back button
//      onWillPop: onBackPressed,
//      child: Scaffold(
//        key: scaffoldKey,
//        appBar: AppBar(
//          title: Text("Latin list"),
//          actions: [
//            IconButton(
//                tooltip: 'Search',
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  showSearch(
//                    context: context,
//                    delegate: SearchPage<Repo>(
//                      items: Provider.of<Repo>(context, listen: false).repoList,
//                      searchLabel: 'Search',
//                      itemStartsWith: true,
//                      suggestion: Center(
//                        child: Text('Filter by word'),
//                      ),
//                      failure: Center(
//                        child: Text('No search results'),
//                      ),
//                      filter: (repo) => [repo.word],
//                      builder: (repo) => ListTile(
//                          title: Text(repo.word),
//                          subtitle: Text(repo.trans),
//                          trailing: GestureDetector(
//                            child: Icon(Icons.delete, color: Colors.blueGrey),
//                            onTap: () {
//                              //FocusScope.of(context).unfocus();
//                              showDeleteDialog(repo,2);
//                            },
//                          ),
//                          onTap: () {
//                            //FocusScope.of(context).unfocus();
//                            navigateToDetail(repo);
//                          }),
//                    ),
//                  );
//                }),
//          ],
//        ),
//        body: Consumer<Repo>(builder: (context, repo, child) {
//          return FutureBuilder(
//            future: db.getModelList(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                case ConnectionState.waiting:
//                  return Center(child: CircularProgressIndicator());
//                default:
//                  return (snapshot.hasError)
//                      ? Text('Error: ${snapshot.error}')
//                      : createListView(snapshot);
//              }
//            },
//          );
//        }),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            navigateToDetail(Repo(null, '', ''));
//          },
//          child: Icon(Icons.add),
//        ),
//      ),
//    );
//  }
//
//  Widget createListView(AsyncSnapshot snapshot) {
//    List<Repo> repo = snapshot.data;
//    return ListView.builder(
//      itemCount: repo.length,
//      itemBuilder: (BuildContext context, int index) {
//        return Column(
//          children: <Widget>[
//            ListTile(
//                title: Text(repo[index].word),
//                subtitle: Text(repo[index].trans),
//                trailing: GestureDetector(
//                  child: Icon(Icons.delete, color: Colors.blueGrey),
//                  onTap: () {
//                    showDeleteDialog(repo[index], 1);
//                  },
//                ),
//                onTap: () {
//                  //debugPrint("Tapped list tile");
//                  navigateToDetail(repo[index]);
//                }),
//            Divider(
//              height: 2.0,
//              indent: 15.0,
//              endIndent: 20.0,
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//  void navigateToDetail(Repo repo) async {
//    String status =
//        await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return DetailPage(repo);
//    }));
//
//    statusUpdate(status);
//  }
//
//  Future<Null> showDeleteDialog(Repo repo, int p) async {
//    return showDialog(
//        context: context,
//        builder: (context) => AlertDialog(
//              title: Text(
//                'Delete?',
//                style: TextStyle(color: Colors.red),
//              ),
//              content: Text(repo.word + '\n\n' + repo.trans),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text('NO'),
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                ),
//                FlatButton(
//                  child: Text('YES'),
//                  onPressed: () async {
//                    int count = 0;
//                    Navigator.of(context).popUntil((_) => count++ >= p);// remove Dialog
//                    var result = Provider.of<Repo>(context, listen: false)
//                        .deleteItem(repo.id);
//                    result.then((value) {
//                      String s = (value != 0) ? 'delete' : 'deleteError';
//                      statusUpdate(s);
//                    });
//                  },
//                ),
//              ],
//            ));
//  }
//
//  Future<bool> onBackPressed() {
//    return showDialog(
//            context: context,
//            builder: (context) => AlertDialog(
//                  title: Text('Exit'),
//                  content: Text('Are you sure you want to exit?'),
//                  actions: <Widget>[
//                    FlatButton(
//                      child: Text('No'),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                    FlatButton(
//                      child: Text('Yes'),
//                      onPressed: () {
//                        SystemChannels.platform
//                            .invokeMethod('SystemNavigator.pop');
//                      },
//                    ),
//                  ],
//                )) ??
//        false;
//  }
//
//  void statusUpdate(String status) async {
//    int count = await db.getCount();
//    String txt = '';
//    switch (status) {
//      case 'save':
//        txt = 'Saved Successfully';
//        break;
//      case 'saveError':
//        txt = 'Save error!';
//        break;
//      case 'delete':
//        txt = 'Deleted Successfully';
//        break;
//      case 'deleteError':
//        txt = 'Delete error!';
//        break;
//      case 'back':
//        txt = 'Nothing was saved';
//        break;
//    }
//    showSnackBar(txt, count);
//  }
//
//  void showSnackBar(String t, int c) {
//    final snackBar = SnackBar(
//        duration: const Duration(seconds: 1),
//        content: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [Text(t), Text(c.toString())],
//        ));
//    scaffoldKey.currentState.showSnackBar(snackBar);
//  }
//}
