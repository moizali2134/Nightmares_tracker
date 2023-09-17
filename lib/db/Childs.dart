


import 'DbHelper.dart';

class Child {
  int? id;
  String? name;
  String? colr;
  int? parent_id;

  Child(this.id, this.name, this.colr,this.parent_id);

  Child.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    colr = map['child_color'];
    parent_id = map['parent_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnchd_color: colr,
      DatabaseHelper.columnparent_id : parent_id,
    };
  }
}