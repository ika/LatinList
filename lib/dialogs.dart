import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

// dialogs.dart

enum ConfirmAction { cancel, accept }

class ConfirmDialog {
  Future showConfirmDialog(context, arr) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(arr[0].toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(arr[1].toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
            TextButton(
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.cancel);
              },
            ),
          ],
        );
      },
    );
  }
}

class WarnDialog {
  Future showWarnDialog(context, arr) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(arr[0].toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(arr[1].toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
          ],
        );
      },
    );
  }
}

String searchInput;

class InputDialog {
  Future showInputDialog(context) async {
    TextEditingController _controller = new TextEditingController();

    searchInput = "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // Text(
                //   arr[0].toString(),
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      maxLength: 50,
                      controller: _controller,
                      decoration: new InputDecoration(
                          labelText: 'Enter search text',
                          labelStyle: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                      onChanged: (value) {
                        searchInput = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('YES', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
            TextButton(
              child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.cancel);
              },
            ),
          ],
        );
      },
    );
  }
}
