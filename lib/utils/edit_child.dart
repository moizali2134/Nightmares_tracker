import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrortracker/db/Childs.dart';

import '../db/DbHelper.dart';
import '../main.dart';
import '../pages/Home/Child_Setting.dart';
import 'NOTIFIER.dart';

add_update(BuildContext context,String? txt,String c,id){

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {

      final themeChange = Provider.of<DarkThemeProvider>(context);
      TextEditingController tx1=TextEditingController();
      String ColorString= c;

      tx1.text=txt!;
      var size=MediaQuery.of(context).size;
      return Wrap(
          children: <Widget>[
          Container(
          height: size.height*0.8,

          color:  themeChange.darkTheme ? Colors.grey : Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height:size.height*0.005),
                const Text(" Update Child ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                SizedBox(height:size.height*0.005),
                Container(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  margin:  EdgeInsets.only(left:size.width*0.05,right: size.width*0.05),
                  child: TextField(

                    controller: tx1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Child Name',
                        // hintText: txt !=null ?"E ":
                    )
                  ),
                ),
                SizedBox(height:size.height*0.005),

                Container(
                    margin:  EdgeInsets.all(size.width*0.08),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeChange.darkTheme ? Colors.white60:Colors.indigo, // Set border color
                          width: 3.0),   // Set border width
                      borderRadius:  BorderRadius.all(
                          Radius.circular(size.width*0.08)),// Set rounded corner radius
                      // Make rounded corner of border
                    ),
                    child: Column(
                      children: [
                        const Text(" Select Color For Your Child ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                        ColorPicker(

                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.primary: false,
                            // ColorPickerType.custom:false,
                          },
                          onColorChanged: (Color value) {
                            print(value);
                            ColorString=value.toString();
                            // String valueString = value.toString().split('(0x')[1].split(')')[0]; // kind of hacky..
                            // int values = int.parse(valueString, radix: 16);
                            // Color otherColor = Color(values);
                            // print(otherColor);
                          },

                        ),
                      ],)
                ),
                SizedBox(width: size.width*0.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                  [
                    ElevatedButton(
                      onPressed: () {

                        if(tx1.text.isEmpty){
                          displaytoastmsg("Kindly Enter Child Name", context);
                        }else if(ColorString=="000"){
                          displaytoastmsg("Kindly Select Color", context);
                        }

                        else{
                          _update(id, tx1.text,ColorString,context);
                          Navigator.pop(context);
                        }

                      },
                      child: const Text('Update'),
                    ),
                    SizedBox(width: size.width*0.05,),
                    ElevatedButton(
                      onPressed: () {


                        tx1.clear();

                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),

                    ),
                    SizedBox(width: size.height*0.008,),
                  ],),

              ],
            ),
          ),
        )]);
    },
  );

}
void _update(id, name, miles,BuildContext cx) async {
  // row to update
  Child c = Child(id, name, miles,ur["id"]);
  final rowsAffected = await dbHelper.updateChild(c);
  displaytoastmsg('Child Updated',cx );
  print('updated $rowsAffected row(s)');
  // displaytoastmsg('Child Added',cx);
  // print('inserted child id: $id');
  Navigator.pushAndRemoveUntil(
    cx,
    MaterialPageRoute(builder: (BuildContext context) => Child_Setting()),
        (route)=>false,
  );
  // Navigator.pop(cx);
}



