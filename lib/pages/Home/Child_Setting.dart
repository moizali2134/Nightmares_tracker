import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrortracker/utils/add_child.dart';
import 'package:terrortracker/utils/edit_child.dart';

import '../../db/Childs.dart';
import '../../db/DbHelper.dart';
import '../../main.dart';
import '../../utils/NOTIFIER.dart';
import 'Setting.dart';

class Child_Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Child_Setting> {
  final dbHelper = DatabaseHelper.instance;

  List<Child> child = [];

  @override
  void initState() {
    super.initState();
    _queryAll();

  } // // List<Car> carsByName = [];



  var items = [
    'Edit',
    'Delete'
  ];
  void _showMessageInScaffold(String message,BuildContext cx){
    ScaffoldMessenger.of(cx).showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(

        appBar: AppBar(
          backgroundColor:  Colors.white.withOpacity(0.2),

          title: Text('Add Child',style: TextStyle(color: themeChange.darkTheme ?Colors.white:Colors.indigo),),
          leading: IconButton(
            onPressed: ( ){ Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  Setting()),
                  (route)=>false,
            );},
            icon:const Icon( Icons.arrow_back),

          ),
          iconTheme:  themeChange.darkTheme ? const IconThemeData(
              color: Colors.white //change your color here
          ) :const IconThemeData(
              color: Colors.indigo //change your color here
          ),

        ),
        body: Container(
          child: ListView.builder(
            padding: const EdgeInsets.all(1),
            itemCount: child.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == child.length) {
                return TextButton(
                  child: const Text(' '),
                  onPressed: () {
                   print("pressed");
                  },
                );
              }
              return Card(

                  child: ListTile(



              title:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [

                    Row(children: [
                      const Text("Child Name : "),
                      Text(
                        '${child[index].name} ',
                        textScaleFactor: 1.2,
                      ),],), Row(
                      children: [
                        const Text("Color :   "),
                        Icon(Icons.square,
                          color: Color(int.parse(child[index].colr
                              .toString().split('(0x')[1].split(')')[0],
                              radix: 16)),size: 50,),],),],),

                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(child: Row(children:const [
                        Icon(Icons.edit,color: Colors.cyan,),Text("Edit")
                      ]) ,onTap: (){
add_update(context, "${child[index].name}",'${child[index].colr}',child[index].id);
                      },),
                      const SizedBox(height: 5,),
                      InkWell(child: Row(children:const [
                        Icon(CupertinoIcons.bin_xmark,color: Colors.red,),Text("Delete")
                      ]) ,onTap:()=> showDialog<String?>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Child'),
                          content:  Text('Are you shore you want delete \n child: ${child[index].name}'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () { _delete(child[index].id);
                                Navigator.pop(context, 'OK');},
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),)

                    ],
                  )],)

              )
              );






            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
            add_child(context,"add child");
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
      ),
    );
  }



  void _queryAll() async {
    final allRows = await dbHelper.querychildAllRows(ur["id"]);
    child.clear();
    allRows.forEach((row) {
        if(row["name"]!="All"){
print(row);
      child.add(Child.fromMap(row));
    }
    });
    // print(child[0].colr);
  //  _showMessageInScaffold('Query done.',context);
    setState(() {});
  }
  //
  // void _query(name) async {
  //   final allRows = await dbHelper.queryRows(name);
  //   carsByName.clear();
  //   allRows.forEach((row) => carsByName.add(Car.fromMap(row)));
  // }
  //


  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.deletechild(id);
    _showMessageInScaffold('deleted $rowsDeleted row(s): row $id',context);
  }
}