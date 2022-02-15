import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutterapplatinlist/model.dart';

import 'cu_queries.dart';
import 'dialogs.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.model, this.title}) : super(key: key);

  final CustomModel model;
  final String title;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isSaved = true;

  CustomDBQueries _customDBQueries = CustomDBQueries();

  TextEditingController controllerOne = TextEditingController();
  TextEditingController controllerTwo = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerOne.text = widget.model.word;
    controllerTwo.text = widget.model.trans;
  }

  @override
  void dispose() {
    controllerOne.dispose();
    controllerTwo.dispose();
    super.dispose();
  }

  _onBackPressed() async {
    if (!isSaved && controllerOne.text.length > 0) {
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

  Future<void> moveToLastScreen() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void updateWord() {
    // if (model.word != controllerOne.text) {
    //   model.word = controllerOne.text;
    //   isSaved = false;
    // }
  }

  void updateTranslation() {
    // if (model.trans != controllerTwo.text) {
    //   model.trans = controllerTwo.text;
    //   isSaved = false;
    // }
  }

  void _deleteWrapper() {
    var arr = List.filled(2, '');
    arr[0] = "DELETE?";
    arr[1] = "Are you sure you want to delete this item?";

    ConfirmDialog().showConfirmDialog(context, arr).then(
      (value) {
        if (value == ConfirmAction.accept) {
          _customDBQueries
              .deleteModel(widget.model.id)
              .then((value) => {moveToLastScreen()});
        }
      }, //_deleteWrapper,
    );
  }

  void _saveWrapper() {
    if (widget.model.id == null) {
      var model =
          CustomModel(word: controllerOne.text, trans: controllerTwo.text);
      _customDBQueries.insertModel(model).then((value) => {moveToLastScreen()});
    } else {
      var model = CustomModel(
          id: widget.model.id,
          word: controllerOne.text,
          trans: controllerTwo.text);
      _customDBQueries.updateModel(model).then((value) => {moveToLastScreen()});
    }
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _onBackPressed();
            },
          ),
          actions: [
            //   IconButton(
            //     icon: Icon(Icons.save),
            //     onPressed: () {
            //       if (_formKey.currentState.validate()) {
            //         _saveWrapper();
            //       }
            //     },
            //   ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteWrapper,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controllerOne,
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
                    controller: controllerTwo,
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
                  onPressed: _saveWrapper,
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
