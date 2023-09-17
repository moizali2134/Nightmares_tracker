
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:terrortracker/pages/Home/Tracker.dart';

import '../db/Childs.dart';
import '../db/DbHelper.dart';
import '../db/report_model.dart';
import '../main.dart';
import 'NOTIFIER.dart';

String ch_name=" ";
String ch_color=" ";
late int childposition;
final format = DateFormat("hh:mm a");
List<Child> ch=childs.where((x) => childs.indexOf(x) != 0).toList();
TextEditingController tx1=TextEditingController();
TextEditingController tx2=TextEditingController();
int? getindex(String chd){
  int i=0;
  for (var e in ch) {
    if(e.name==chd){
     return i;
    }
i++;
  }
  return null;
}
late int index;
update_nightmare(BuildContext context,String date,String start_time,int id,String? child){

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      initializeDateFormatting();
      final themeChange = Provider.of<DarkThemeProvider>(context);
      print(child);
      index=getindex(child!)!;
      ch_name=ch[index].name!;
      ch_color=ch[index].colr!;
      print(index);
      tx1.text=date;
      tx2.text=start_time;

      return
        Container(
          height: MediaQuery.of(context).size.height/2,
          color:  themeChange.darkTheme ? Colors.grey : Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                const Text(" Edit Nightmare ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeChange.darkTheme ? Colors.white60:Colors.indigo, // Set border color
                          width: 3.0),   // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                      // Make rounded corner of border
                    ),
                    child:TextField(
                        controller: tx1, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today), //icon of text field
                            labelText: "Select NightMare Date" //label text of field
                        ),
                        readOnly: true,  // when true user cannot edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime.now().subtract(Duration(days: 365)), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now()
                          );

                          if(pickedDate != null ){
                            print(pickedDate);  //get the picked date in the format => 2022-07-04 00:00:00.000
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                            print(formattedDate); //formatted date output using intl package =>  2022-07-04
                            //You can format date as per your need


                            tx1.text = formattedDate; //set foratted date to TextField value.

                          }else{
                            print("Date is not selected");
                          }  //when click we have to show the datepicker
                        }
                    )

                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: themeChange.darkTheme ? Colors.white60:Colors.indigo, // Set border color
                            width: 3.0),   // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                        // Make rounded corner of border
                      ),
                      child:  SizedBox(width: MediaQuery.of(context).size.width/3,child:

                      DateTimeField(
                        decoration: const InputDecoration(
                    //      icon: Icon(CupertinoIcons.clock),
                          labelText: 'Select Time',),
                        controller: tx2 ,
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return time == null ? null : DateTimeField.convert(time);
                        },
                      ),  ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: themeChange.darkTheme ? Colors.white60:Colors.indigo, // Set border color
                            width: 3.0),   // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                        // Make rounded corner of border
                      ),
                      child:  SizedBox(width: MediaQuery.of(context).size.width/3,child:
                      DropdownButtonExample(),
                      ),
                    ),


                  ],),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                  [
                    ElevatedButton(
                      onPressed: () {
                        print(tx2.text);

                        if(tx1.text.isEmpty){
                          displaytoastmsg("Kindly Enter NightMare Date", context);
                        }else if(tx2.text.isEmpty){
                          displaytoastmsg("Kindly Enter NightMare Time", context);
                        }
                        else if(ch_name.isEmpty){
                          displaytoastmsg("Kindly Create Child value in settings then add Nightmare", context);
                        }
                        else{
                           today=tx1.text;
                          _update(id,tx1.text, tx2.text.toString(),context);

                        }

                      },
                      child: const Text('Update'),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {


                        tx1.clear();
                        tx2.clear();

                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),

                    ),
                    SizedBox(width: 20,),
                  ],),

              ],
            ),
          ),
        );
    },
  );

}
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample( {super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {

  Child  dropdownValue =  ch[index];
  @override
  Widget build(BuildContext context) {

    print(ch_color);
    return DropdownButton(
      hint: Text(ch_name == " " ? "None" : ch_name  ),
        onChanged: (Child? newValue) {
        setState(() {

          ch_name= '${newValue!.name}';
          ch_color= '${newValue!.colr}';
          print('${newValue!.colr}');

        });
      },

      items: ch.map((Child value){

        return DropdownMenuItem<Child>(
          value: value,
          child: Text('${value.name}'),
        );}

      ).toList(),
    );
  }


}

 _update(int id,String name,String time,BuildContext cx) async {
  // row to update
  final dbHelper = DatabaseHelper.instance;
if(ch_name.isEmpty){
  DailyReport dr = DailyReport(id, name, time, ch[index].name, ch[index].colr,ur["id"]);
  final rowsAffected = await dbHelper.update(dr);
  print('$rowsAffected row(s)');
  displaytoastmsg('Updated', cx);
  // Navigator.pop(cx);
  tx1.clear();
  tx2.clear();
}else if(ch_color.isEmpty){
  DailyReport dr = DailyReport(id, name, time,  ch[index].name, ch[index].colr,ur["id"]);
  final rowsAffected = await dbHelper.update(dr);
  print('$rowsAffected row(s)');
  displaytoastmsg('Updated', cx);
  // Navigator.pop(cx);
  tx1.clear();
  tx2.clear();
}else {
  DailyReport dr = DailyReport(id, name, time, ch_name, ch_color,ur["id"]);
  final rowsAffected = await dbHelper.update(dr);
  print('$rowsAffected row(s)');
  displaytoastmsg('Nightmare Updated', cx);
  // Navigator.pop(cx);
  tx1.clear();
  tx2.clear();
}
  Navigator.pushAndRemoveUntil(
      cx,
      MaterialPageRoute(builder: (BuildContext context) => TrackerPage()),
        (route)=>false,
  );

  // _showMessageInScaffold('updated $rowsAffected row(s)',cx);
}
