class CustomModel {
  int id;
  String word;
  String trans;

  CustomModel({this.id, this.word, this.trans});

  CustomModel.fromMap(dynamic map) {
    this.id = map['id'];
    this.word = map['word'];
    this.trans = map['trans'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['word'] = word;
    map['trans'] = trans;

    return map;
  }
}
