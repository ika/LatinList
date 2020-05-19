
class Model  {

  int _id;
  String _word;
  String _trans;

  Model(this._id, this._word, this._trans) {
    //searchData();
  }

  int get id => _id;

  String get word => _word;

  String get trans => _trans;

  set id(int value) {
    _id = value;
  }

  set word(String value) {
    _word = value;
  }

  set trans(String value) {
    _trans = value;
  }

  Model.fromMap(dynamic map) {
    this._id = map['id'];
    this._word = map['word'];
    this._trans = map['trans'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['word'] = _word;
    map['trans'] = _trans;

    return map;
  }

//  searchData() async {
//    repoList.clear();
//    List<Repo> repo = await db.getModelList() as List<Repo>;
//    for (var i = 0; i < repo.length; i++) {
//      repoList.add(repo[i]);
//    }
//  }
//
//  Future<int> deleteItem(int id) async {
//    Future<int> res = db.deleteModel(id);
//    searchData();
//    notifyListeners();
//    return res;
//  }
//
//  Future<int> updateItem(repo) async {
//    Future<int> res = db.updateModel(repo);
//    searchData();
//    notifyListeners();
//  }
//
//  Future<int> insertItem(repo) {
//    Future<int> res = db.insertModel(repo);
//    searchData();
//    notifyListeners();
//  }
}
