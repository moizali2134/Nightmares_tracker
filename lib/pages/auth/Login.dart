import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrortracker/db/user.dart';
import 'package:terrortracker/main.dart';
import '../../db/Login_response.dart';
import '../../utils/Flatbutton.dart';
import '../../utils/NOTIFIER.dart';
import 'ForgetPass.dart';
import 'Register.dart';



import '../Home/HomePage.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();


}

TextEditingController? userc=TextEditingController();
TextEditingController? passc =TextEditingController();
class _LoginState extends State<LoginView> implements LoginCallBack {
  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() {
      // _isLoading = false;
    });
  }
  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
  savePref(int value,String email, String pass, String user) async {
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
  void onLoginSuccess(user usr) async {

    if(usr != null){
      savePref(usr.id,usr.email, usr.password,usr.username);
      getPref();
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    }else{
      _showSnackBar("Login Failed, Please Check Your Login");
      setState(() {
        // _isLoading = false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    LoginResponse response=LoginResponse(this);

    // TextEditingController tx3=TextEditingController();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(

      appBar: themeChange.darkTheme ? AppBar(
        //  backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text('Login'),

      ): AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),

        title: const Text('Login', style: TextStyle(color: Color(0xff001e8c)), ),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child:  Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.blueAccent.withOpacity(0.5)),

                  // borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                ),
                child: Image.asset('asset/images/flutter-logo.png'),
              ),
              ),
            ),
             SizedBox(height: 5,),
             Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                controller: userc,
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
                        response.doLogin(userc!.text, passc!.text);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  child: const  Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )


            ),
            const SizedBox(
              height: 100,
            ),
      TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => RegisterView()));
        },
        child: Text("New User? Create Account'",
          style: TextStyle(color: themeChange.darkTheme ? Colors.indigo:Colors.black),),

),

            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => ForgetView()));
            //
            //   },
            //   child: const Text("Forgot Password?"),
            // ),
          ],
        ),
      ),
    );
  }

}