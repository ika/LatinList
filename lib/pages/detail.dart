import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapplatinlist/blocs/bdetail.dart';
import 'package:flutterapplatinlist/blocs/provider.dart';
import 'package:flutterapplatinlist/models/model.dart';

class DetailPage extends StatefulWidget {
  Model model;
  String title;

  DetailPage(Model model, String title) {
    this.model = model;
    this.title = title;
  }

  @override
  State<StatefulWidget> createState() {
    return DetailPageState(model, title);
  }
}

class DetailPageState extends State<DetailPage> {
  Model model;
  String title;

  bool isSaved = true;

  DetailBloc _detailBloc;

  TextEditingController ControllerOne = TextEditingController();
  TextEditingController ControllerTwo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
  }

  DetailPageState(Model model, String title) {
    this.model = model;
    this.title = title;
  }

  Future<bool> _onBackPressed() async {
    if (!isSaved) {
      return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Notice!'),
                    content: Text('Your text was not saved'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Don't save"),
                        onPressed: () {
                          moveToLastScreen();
                        },
                      ),
                      FlatButton(
                          child: Text('Save'),
                          onPressed: () {
                            _saveWrapper();
                            moveToLastScreen();
                          }),
                    ],
                  )) ??
          false;
    } else {
      moveToLastScreen();
    }
  }

  void moveToLastScreen() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void updateWord() {
    model.word = ControllerOne.text;
    isSaved = false;
  }

  void updateTranslation() {
    model.trans = ControllerTwo.text;
    isSaved = false;
  }

  void _saveWrapper() {
    if (model.id != null) {
      _detailBloc.updateSink.add(model);
      isSaved = true;
    } else {
      _detailBloc.addSink.add(model);
      isSaved = true;
    }
  }

  _deleteItem() {
    if(model.id != null) {
      _detailBloc.deleteSink.add(model.id);
    }
    moveToLastScreen();
    //Navigator.pop(context);
  }

  _deleteDialogWrapper() {
    if (ControllerOne.text.length > 0) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Delete?',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(ControllerOne.text),
                actions: <Widget>[
                  FlatButton(
                    child: Text('NO'),
                    onPressed: () {
                     // moveToLastScreen();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('YES'),
                    onPressed: () {
                      _deleteItem();
                    },
                  ),
                ],
              ));
    } //else {
      //_deleteItem();
    //}
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    ControllerOne.text = model.word;
    ControllerTwo.text = model.trans;

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _onBackPressed();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveWrapper,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteDialogWrapper,
            )
          ],
        ),
        body: Form(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextFormField(
                    controller: ControllerOne,
                    style: textStyle,
                    maxLength: 256,
                    maxLines: null,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'This field cannot be emptry';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      updateWord();
                    },
                    decoration: InputDecoration(
                        labelText: 'Word',
                        labelStyle: textStyle,
                        errorStyle:
                            TextStyle(color: Colors.red, fontSize: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: ControllerTwo,
                    style: textStyle,
                    maxLength: 512,
                    maxLines: null,
                    onChanged: (value) {
                      updateTranslation();
                    },
                    decoration: InputDecoration(
                      labelText: 'Translation',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
