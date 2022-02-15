import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import 'db_queries.dart';
import 'detail.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.text, this.title}) : super(key: key);

  final String title;
  final String text;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ListDBQueries _listDBQueries = ListDBQueries();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<CustomModel> modelList = [];

  @override
  void initState() {
    super.initState();
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
          },
        );
      },
    );
  }

  //   //_mainBloc.getModelList(); // reload list
  // }

  // Future<void> _deleteItem(int id) async {
  //   if (id != null) {
  //     // _mainBloc.deleteSink.add(id);
  //     // _mainBloc.getModelList();
  //   }
  // }

  // _deleteDialogWrapper(modelList) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text(
  //               'Delete this entry?',
  //               style: TextStyle(color: Colors.red),
  //             ),
  //             content: Text(modelList.word),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('NO'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               TextButton(
  //                 child: Text('YES'),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   _deleteItem(modelList.id);
  //                 },
  //               ),
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<CustomModel>>(
                future: _listDBQueries.getSearchList(widget.text),
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<CustomModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length < 1) {
                      return Center(
                        child: Text(
                          'No items found',
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
                              title: Text(modelList[index].word),
                              subtitle: Text(modelList[index].trans),
                              onTap: () {
                                navigateToDetail(
                                    CustomModel(
                                        id: null,
                                        word: modelList[index].word,
                                        trans: modelList[index].trans),
                                    'Add');
                              },
                              // onLongPress: () {
                              //   _deleteDialogWrapper(modelList[index]);
                              // },
                            ),
                            Divider(
                                //height: 2.0,
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
    );
  }
}
