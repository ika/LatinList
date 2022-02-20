import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapplatinlist/search.dart';
//import 'package:flutterapplatinlist/search.dart';
//import 'package:flutterapplatinlist/detail.dart';
//import 'package:flutterapplatinlist/search.dart';

import 'dialogs.dart';
import 'model.dart';
import 'cu_queries.dart';
import 'detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latin Word list',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(title: 'Latin Word list'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CustomDBQueries _customDBQueries = CustomDBQueries();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<CustomModel> modelList = [];

  String listCount = "0";

  @override
  void initState() {
    super.initState();
    //getCustomCount();
  }

  // Future<void> getCustomCount() async {
  //   _customDBQueries.getCount().then((value) {
  //     setState(() {
  //       //customListCount = value.toString();
  //     });
  //   });
  // }

  void navigateToSearch(String text, String title) async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => SearchPage(text: text, title: title)),
        ).then(
          (value) {
            setState(() {});
            //getCustomCount();
          },
        );
      },
    );
  }

  void navigateToDetail(CustomModel model, String title) async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DetailPage(model: model, title: title)),
        ).then(
          (value) {
            setState(() {});
            //getCustomCount();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Custom list"),
        actions: [
          // IconButton(
          //   tooltip: 'Sort',
          //   icon: Icon(Icons.arrow_downward_outlined),
          //   onPressed: () {},
          // ),
          IconButton(
            tooltip: 'Search',
            icon: Icon(Icons.search),
            onPressed: () {
              InputDialog().showInputDialog(context).then(
                (value) {
                  //print(searchInput);
                  if (value == ConfirmAction.accept) {
                    navigateToSearch(searchInput, 'Search');
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<CustomModel>>(
                future: _customDBQueries.getModelList(),
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<CustomModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length < 1) {
                      var data = "No custom entries found";
                      return Center(
                        child: Text(
                          data,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    modelList = snapshot.data;
                    return ListView.builder(
                      itemCount: modelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  modelList[index].id.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              title: Text(modelList[index].word),
                              subtitle: Text(modelList[index].trans),
                              onTap: () {
                                navigateToDetail(
                                    CustomModel(
                                        id: modelList[index].id,
                                        word: modelList[index].word,
                                        trans: modelList[index].trans),
                                    'Edit');
                              },
                              // onLongPress: () {
                              //   _deleteDialogWrapper(modelList[index]);
                              // },
                            ),
                            Divider(
                                // height: 2.0,
                                indent: 15.0,
                                endIndent: 20.0,
                                color: Colors.black54)
                          ],
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(CustomModel(id: null, word: '', trans: ''), 'Add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
