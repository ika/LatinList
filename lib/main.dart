import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapplatinlist/blocs/bdetail.dart';
import 'package:flutterapplatinlist/blocs/provider.dart';
import 'package:flutterapplatinlist/blocs/bmain.dart';
import 'package:flutterapplatinlist/pages/detail.dart';
import 'package:flutterapplatinlist/pages/search.dart';

import 'models/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latin list',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        bloc: MainBloc(),
        child: MainPage(title: 'Latin list'),
      ),
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MainBloc _mainBloc;
  List<Model> modelList = [];

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Exit'),
              content: Text('Are you sure you want to exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            )) ??
        false;
  }

  void navigateToDetail(Model model, String title) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider(
              bloc: DetailBloc(),
              child: DetailPage(model, title),
            ),
      ),
    );

    _mainBloc.getModelList();  // reload list
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                tooltip: 'Search',
                icon: Icon(Icons.search),
                onPressed: () =>
                    showSearch(
                        context: context,
                        delegate: SearchPage<Model>(
                          items: modelList,
                          itemStartsWith: true,
                          searchLabel: 'Search',
                          suggestion: Center(
                            child: Text('Filter by word'),
                          ),
                          failure: Center(
                            child: Text('No results found'),
                          ),
                          filter: (model) => [model.word],
                          builder: (model) =>
                              ListTile(
                                title: Text(model.word),
                                subtitle: Text(model.trans),
                                onTap: () {
                                  navigateToDetail(Model(
                                      model.id, model.word, model.trans),
                                      'Edit');
                                },
                              ),
                        ))
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<Model>>(
                    stream: _mainBloc.ouputStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Model>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length < 1) {
                          return Center(
                            child: Text('No items found'),
                          );
                        }
                        modelList = snapshot.data;
                        return ListView.builder(
                          itemCount: modelList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(modelList[index].word),
                                  subtitle: Text(modelList[index].trans),
                                  onTap: () {
                                    navigateToDetail(
                                        Model(
                                            modelList[index].id,
                                            modelList[index].word,
                                            modelList[index].trans),
                                        'Edit');
                                  },
                                ),
                                Divider(
                                  height: 2.0,
                                  indent: 15.0,
                                  endIndent: 20.0,
                                )
                              ],
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Model(null, '', ''), 'Add');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
