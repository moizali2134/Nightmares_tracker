class user {
  int? _id;
  String? _username;
  String? _password;
  String? _email;
  user(this._id,this._username, this._password,this._email);
  user.fromMap(dynamic obj) {
    _id = obj['id'];
    _username = obj['name'];
    _password = obj['pass'];
    _email = obj['email'];
  }
  int get id =>_id!;
  String get username => _username!;
  String get password => _password!;
  String get email => _email!;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"]=_id;
    map["name"] = _username;
    map["pass"] = _password;
    map['email']=_email;
    return map;
  }
}