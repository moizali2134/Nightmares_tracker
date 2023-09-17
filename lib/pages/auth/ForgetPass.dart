import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/Flatbutton.dart';
import '../../utils/NOTIFIER.dart';
import 'Login.dart';





class ForgetView extends StatefulWidget {
  @override
  _ForgetState  createState() => _ForgetState ();
}

class _ForgetState extends State<ForgetView> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar:  themeChange.darkTheme ? AppBar(
        //  backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text('Forget Password'),

      ): AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),

        title: const Text('Forget Password', style: TextStyle(color: Color(0xff001e8c)), ),

      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/flutter-logo.png')),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => LoginView()));
                  },
                  child: const  Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )


            ),

          ],
        ),
      ),
    );
  }
}