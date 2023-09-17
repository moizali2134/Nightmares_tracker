import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:terrortracker/pages/Home/HomePage.dart';
import 'package:terrortracker/pages/auth/Login.dart';
import 'package:terrortracker/utils/NOTIFIER.dart';
import 'package:terrortracker/utils/style.dart';

import 'db/Childs.dart';
import 'db/DbHelper.dart';


final dbHelper = DatabaseHelper.instance;
var email;
late int user_id;
String today="";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  email=prefs.getString("email")??"none";
  user_id=prefs.getInt("value")?? 0;
  today=DateTime.now().toString();
  print(email);
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getPref();
    getCurrentAppTheme();

  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }
  void getdailytime() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (_, model, __) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context), // Provide light theme.

            home: email == "none" ? LoginView() : HomePage()

          );
          // else{
          //   return MaterialApp(
          //     theme: Styles.themeData(themeChangeProvider.darkTheme, context), // Provide light theme.
          //     // Decides which theme to show.
          //     home:HomePage(),
          //   );
          // }
        },
      ),
    );
  }

}
displaytoastmsg(String msgss ,BuildContext context){
  Fluttertoast.showToast(msg: msgss);
}
Map ur={};
getPref() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
ur={
    "id":preferences.getInt("value")?? 0,
    "password": preferences.getString("pass")?? "none" ,
    "username":   preferences.getString("user")?? "none",
    "email": preferences.getString("email")??"none",
   };
print(ur);
}
List<Child> childs = [];
queryAll() async {
  final allRows = await dbHelper.querychildAllRows(ur["id"]);
  childs.clear();

    for (var row in allRows) {
      childs.add(Child.fromMap(row));
    }


  // print(childs[0].colr);


}







