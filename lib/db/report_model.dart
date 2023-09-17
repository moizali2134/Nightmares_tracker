import 'DbHelper.dart';

class DailyReport {
  int? id;
  String? name;
  String? start_time ;
  String? child_color;
  String? child_name;
  int? parent_id;

  DailyReport(this.id, this.name, this.start_time,this.child_name,this.child_color,this.parent_id);

  DailyReport.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    start_time = map['time'];
    child_name = map['child_name'];
    child_color = map['child_color'];
    parent_id = map['parent_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnstime: start_time,
      DatabaseHelper.columnchild:child_name,
      DatabaseHelper.columnchd_color:child_color,
      DatabaseHelper.columnparent_id:parent_id,


    };
  }
}