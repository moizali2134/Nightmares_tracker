
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrortracker/db/user.dart';
import 'package:terrortracker/pages/auth/Login.dart';

import '../main.dart';
import 'NOTIFIER.dart';

update_user(BuildContext context,String? txt,String c){

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {

      final themeChange = Provider.of<DarkThemeProvider>(context);
      TextEditingController tx1=TextEditingController();

      if(c!="Password"){ tx1.text=txt!;}


      return
        Container(
          height: MediaQuery.of(context).size.height/1,
          color:  themeChange.darkTheme ? Colors.grey : Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10,),
                Text(" Update $c ",style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10,),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                      obscureText: c=="Password" ? true:false,
                      controller: tx1,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: c,

                        // hintText: txt !=null ?"E ":
                      )
                  ),
                ),



                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                  [
                    ElevatedButton(
                      onPressed: () {
                        if(c!="Password"){
                         _updateemail( tx1.text,context);
                        }
                        else{
                          _updatepass( tx1.text,context);
                        }
                          Navigator.pop(context);


                      },
                      child: const Text('Update'),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {


                        tx1.clear();

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
void _updateemail(String eml,BuildContext cx) async {
  // row to update
  user c = user(ur["id"],ur["username"], ur["password"],eml);

  final rowsAffected = await dbHelper.updateuser(c);
  displaytoastmsg('Email Updated ',cx);
  print('updated $rowsAffected row(s)');
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
  Navigator.pushAndRemoveUntil(
      cx,
      MaterialPageRoute(builder: (BuildContext context) => LoginView()),
        (route)=>false,
  );
}
void _updatepass(String pss,BuildContext cx) async {
  // row to update

  user c = user(ur["id"],ur["username"], pss, ur["email"]);
  final rowsAffected = await dbHelper.updateuser(c);
  displaytoastmsg('Password Updated ',cx);
  print('updated $rowsAffected row(s)');
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
  Navigator.pushAndRemoveUntil(
      cx,
      MaterialPageRoute(builder: (BuildContext context) => LoginView()),
        (route)=>false,
  );
}