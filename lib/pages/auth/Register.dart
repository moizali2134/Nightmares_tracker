
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrortracker/db/Login_response.dart';
import 'package:terrortracker/main.dart';
import '../../db/Childs.dart';
import '../../db/DbHelper.dart';
import '../../utils/Flatbutton.dart';
import '../../utils/NOTIFIER.dart';
import 'Login.dart';


import '../Home/HomePage.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegState createState() => _RegState();
}
TextEditingController userc=TextEditingController();
TextEditingController passc =TextEditingController();
TextEditingController cpassc =TextEditingController();
TextEditingController emailc =TextEditingController();
class _RegState extends State<RegisterView> implements RegCallBack{
  @override
  Widget build(BuildContext context) {
    RegisterResponse response=RegisterResponse(this);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(

      appBar: themeChange.darkTheme ? AppBar(
        //  backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text('Register'),

      ): AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),

        title: const Text('Register', style: TextStyle(color: Color(0xff001e8c)), ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child:Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.blueAccent.withOpacity(0.5)),
                  //  borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                  ),
                  child: Image.asset('asset/images/flutter-logo.png'),
                ),
                // Container(
                //     width: 150,
                //     height: 150,
                //     /*decoration: BoxDecoration(
                //         color: Colors.red,
                //         borderRadius: BorderRadius.circular(50.0)),*/
                //     child: Image.asset('asset/images/flutter-logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: userc,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter valid UserName'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
              // //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailc,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
           Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
controller: passc,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
controller: cpassc,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  style: flatButtonStyle,
                  onPressed: () {
                    if(userc.text.isEmpty){
                      displaytoastmsg("Name Is Empty", context);
                    }else if(emailc.text.isEmpty){
                      displaytoastmsg("Email Is Empty", context);
                    }else if(passc.text.isEmpty){
                      displaytoastmsg("Password Is Empty", context);
                    }else if(cpassc.text!=passc.text){
                      displaytoastmsg("Password is not same in confirm Password", context);
                    }else {
                      response.doRegister(
                          userc.text, passc.text, emailc.text);
                    } // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: const  Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )


            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginView()));
              },
              child: const Text("Already have an Account?", ),

            ),


          ],
        ),
      ),
    );
  }

  @override
  void onRegError(String error) {
    print(error);
    _showSnackBar(error);

  }
  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
  savePref(int value,String user, String pass,String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.setString("user", user);
      preferences.setString("pass", pass);
      preferences.commit();
    });
  }
  @override
  void onRegSuccess(int usr) {
    if(usr != null){

      savePref(usr,userc.text, passc.text,emailc.text);
      fake_child(usr);
      getPref();
      // savePref(1,usr.username, usr.password);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    }else{
      _showSnackBar("Register Failed... ");
      setState(() {
        // _isLoading = false;
      });
    }
    // TODO: implement onRegSuccess
  }
  fake_child(int i) async {
    final dbHelper = DatabaseHelper.instance;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: "All",
      DatabaseHelper.columnchd_color: "Color(0xff00b0ff)",
      DatabaseHelper.columnparent_id : i,
    };
    Child dr =Child.fromMap(row);
    final id = await dbHelper.insertchild(dr);
    print(id);
  }
}