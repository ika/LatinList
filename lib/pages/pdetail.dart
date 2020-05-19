//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutterapplatinlist/models/model.dart';
//import 'package:flutterapplatinlist/database/dbhelper.dart';
//import 'package:provider/provider.dart';
//
//class DetailPage extends StatefulWidget {
//  final Repo repo;
//
//  DetailPage(this.repo);
//
//  @override
//  State<StatefulWidget> createState() {
//    return DetailPageState(this.repo);
//  }
//}
//
//class DetailPageState extends State<DetailPage> {
//  var _formKey = GlobalKey<FormState>();
//  Repo repo;
//
//  DatabaseHelper databaseHelper = DatabaseHelper();
//
//  TextEditingController ControllerOne = TextEditingController();
//  TextEditingController ControllerTwo = TextEditingController();
//
//  DetailPageState(this.repo);
//
//  @override
//  Widget build(BuildContext context) {
//    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
//
//    ControllerOne.text = repo.word;
//    ControllerTwo.text = repo.trans;
//
//    return WillPopScope(
//        // bottom back button
//        onWillPop: () {
//          moveToLastScreen('back');
//          return Future.value(false);
//        },
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text('Edit entry'),
//            leading: IconButton(
//              icon: Icon(Icons.arrow_back), // top arrow back
//              onPressed: () {
//                moveToLastScreen('back');
//              },
//            ),
//          ),
//          body: Form(
//            key: _formKey,
//            child: Padding(
//              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
//              child: ListView(
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                    child: TextFormField(
//                      controller: ControllerOne,
//                      style: textStyle,
//                      maxLength: 64,
//                      validator: (String value) {
//                        if (value.isEmpty) {
//                          return 'This field cannot be empty';
//                        } else {
//                          return null;
//                        }
//                      },
//                      onChanged: (value) {
//                        updateWord();
//                      },
//                      decoration: InputDecoration(
//                          labelText: 'Word',
//                          labelStyle: textStyle,
//                          errorStyle:
//                              TextStyle(color: Colors.red, fontSize: 15.0),
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(5.0))),
//                    ),
//                  ),
//                  // Third element
//                  Padding(
//                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                    child: TextField(
//                      controller: ControllerTwo,
//                      style: textStyle,
//                      maxLength: 128,
//                      onChanged: (value) {
//                        updateTranslation();
//                      },
//                      decoration: InputDecoration(
//                          labelText: 'Translation',
//                          labelStyle: textStyle,
//                          border: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(5.0))),
//                    ),
//                  ),
//                  // Forth element
//                  Padding(
//                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                      child: Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: RaisedButton(
//                              color: Theme.of(context).primaryColorDark,
//                              textColor: Theme.of(context).primaryColorLight,
//                              child: Text(
//                                'Submit',
//                                textScaleFactor: 1.5,
//                              ),
//                              onPressed: () {
//                                if (_formKey.currentState.validate()) {
//                                  _save();
//                                }
//                              },
//                            ),
//                          ),
//                        ],
//                      )),
//                ],
//              ),
//            ),
//          ),
//        ));
//  }
//
//  void updateWord() {
//    repo.word = ControllerOne.text;
//  }
//
//  void updateTranslation() {
//    repo.trans = ControllerTwo.text;
//  }
//
//  void _save() async {
//    // updateWord();
//
//    //model.date = DateFormat.yMMMd().format(DateTime.now());
//
//    int result = null;
//    if (repo.word.length > 0) {
//
//      if (repo.id != null) {
//        //Case 1: update operation
//        result =
//            await Provider.of<Repo>(context, listen: false).updateItem(repo);
//      } else {
//        //Case 2: insert operation
//        result =
//            await Provider.of<Repo>(context, listen: false).insertItem(repo);
//      }
//
//      if (result != 0) {
//        // success!
//        moveToLastScreen('save');
//      } else {
//        //failure
//        moveToLastScreen('saveError');
//      }
//    }
//  }
//
//  void moveToLastScreen(String status) {
//    //pop accepts other parameter (can be anything?)
//    Navigator.pop(context, status);
//  }
//}
