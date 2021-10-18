import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutterapplatinlist/db_model.dart';

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
  DetailBloc _detailBloc;
  bool isSaved = true;

  TextEditingController ControllerOne = TextEditingController();
  TextEditingController ControllerTwo = TextEditingController();

  DetailPageState(Model model, String title) {
    this.model = model;
    this.title = title;
    ControllerOne.text = model.word;
    ControllerTwo.text = model.trans;
  }

  @override
  void initState() {
    super.initState();
    _detailBloc = BlocProvider.of<DetailBloc>(context);
    //ControllerOne.addListener(updateWord);
  }

  @override
  void dispose() {
    ControllerOne.dispose();
    ControllerTwo.dispose();
    super.dispose();
  }

_onBackPressed() async {
    if (!isSaved && ControllerOne.text.length > 0) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Notice!'),
                content: Text('Your text was not saved'),
                actions: <Widget>[
                  TextButton(
                    child: Text("Don't save"),
                    onPressed: () {
                      moveToLastScreen();
                    },
                  ),
                  TextButton(
                      child: Text('Save'),
                      onPressed: () {
                        _saveWrapper();
                        moveToLastScreen();
                      }),
                ],
              ));
    } else {
      moveToLastScreen();
    }
  }

  void moveToLastScreen() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void updateWord() {
    if (model.word != ControllerOne.text) {
      model.word = ControllerOne.text;
      isSaved = false;
    }
  }

  void updateTranslation() {
    if (model.trans != ControllerTwo.text) {
      model.trans = ControllerTwo.text;
      isSaved = false;
    }
  }

  void _saveWrapper() {
    if (model.word.length > 0 || model.trans.length > 0) {
      isSaved = true;

      if (model.id != null) {
        _detailBloc.updateSink.add(model);
      } else {
        _detailBloc.addSink.add(model);
      }
    }
  }

  void _submit() {
    _saveWrapper();
    moveToLastScreen();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(this.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _onBackPressed();
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.save),
          //     onPressed: () {
          //       if (_formKey.currentState.validate()) {
          //         _saveWrapper();
          //       }
          //     },
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: _deleteDialogWrapper,
          //   )
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: ControllerOne,
                  style: textStyle,
                  maxLength: 256,
                  maxLines: null,
                  autocorrect: false,
                  autofocus: true, // this triggers onChange
                  keyboardType: TextInputType.text,
                  onChanged: (String value) {
                    updateWord();
                  },
                  // validator: (String value) {
                  //   if (value.isEmpty) {
                  //     return 'This field is required!';
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  decoration: InputDecoration(
                      labelText: 'Latin Word',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                ElevatedButton(
                  onPressed: _submit,
                  child: Text("SAVE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
