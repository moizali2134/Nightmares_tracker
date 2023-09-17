import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terrortracker/main.dart';
import 'package:terrortracker/pages/Home/Child_Setting.dart';
import 'package:terrortracker/pages/auth/Login.dart';
import 'package:terrortracker/utils/update_user.dart';

import '../../utils/NOTIFIER.dart';
import 'HomePage.dart';
import 'Tracker.dart';

class Setting extends StatefulWidget {


  @override
  State<Setting> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Setting> {
  final _advancedDrawerController = AdvancedDrawerController();
  bool lockAppSwitchVal = true;
  bool fingerprintSwitchVal = false;
  bool changePassSwitchVal = true;

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );
  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return  AdvancedDrawer(
        backdropColor: themeChange.darkTheme ? Colors.white.withOpacity(0.2) : Colors.blueGrey,
    controller: _advancedDrawerController,
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 300),
    animateChildDecoration: true,
    rtlOpening: false,

    disabledGestures: false,
    childDecoration: const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    drawer: SafeArea(

    child: SizedBox(
    width: 50,
    child: ListTileTheme(
    textColor: Colors.white,
    iconColor: Colors.white,
    child: Column(

    children: [

    ListTile(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage()),
            (route)=>false,
      );

    },
    leading: const Icon(Icons.home),
    title: const Text('Main'),
    ),

    ListTile(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  TrackerPage()),
            (route)=>false,
      );

    },
    leading: const Icon(Icons.find_in_page_sharp),
    title: const Text('Tracker'),
    ),
    ListTile(
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  Setting()),
            (route)=>false,
      );

    },
    leading: const Icon(Icons.settings),
    title: const Text('Settings'),
    ),
    const Spacer(),
    Column(
    children: <Widget>[
    Container(
    alignment: Alignment.center,
    child: themeChange.darkTheme ? const Icon(CupertinoIcons.moon):const Icon(CupertinoIcons.sun_max,color: Colors.yellowAccent,),),
    const SizedBox(height: 10,),
    FlutterSwitch(
    value: themeChange.darkTheme,
    onToggle: (val) {
    setState(() {
    themeChange.darkTheme  = val;
    });
    },
    ),

    ],
    ),

    ],
    ),
    ),
    ),
    ),
    child:    Scaffold(
      appBar:  themeChange.darkTheme ? AppBar(
        //  backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: _handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: _advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
      ): AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),

        title: const Text('Settings', style: TextStyle(color: Color(0xff001e8c)), ),
        leading: IconButton(
          onPressed: _handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: _advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  key: ValueKey<bool>(value.visible),
                  color:  const Color(0xff001e8c) ,
                ),
              );
            },
          ),
        ),
      ),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Account"),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.mail),
                  title:  Text("Email: ${ur["email"]}"),

                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(Icons.child_care),
                  title: const Text("Add Child"),
                  onTap:(){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Child_Setting()));
                  },
                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Sign Out"),
                  onTap: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                        (route)=>false,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Security"),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.mail_lock),
                  title: const Text("Edit Email "),
                   onTap:(){ update_user(context, ur["email"], "Email");},
                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                  onTap: (){update_user(context, ur["password"], "Password");},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Theme"),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(),
                ListTile(
                  leading: themeChange.darkTheme ? const Icon(CupertinoIcons.moon):const Icon(CupertinoIcons.sun_max,color: Colors.orangeAccent,),
                    title: const Text("Change Theme"),
                  trailing: Switch(
                      value:  themeChange.darkTheme,
                      activeColor: Colors.blueAccent,
                      onChanged: (val) {
                        setState(() {
                          themeChange.darkTheme  = val;
                        });
                      }),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children:  [
                //     const SizedBox(width: 10,),
                //     Container(
                //       child: themeChange.darkTheme ? const Icon(CupertinoIcons.moon):const Icon(CupertinoIcons.sun_max,color: Colors.blueAccent,),),
                //     FlutterSwitch(
                //       value: themeChange.darkTheme,
                //       onToggle: (val) {
                //         setState(() {
                //           themeChange.darkTheme  = val;
                //         });
                //       },
                //     ),
                //   ],
                // ),

                const SizedBox(height: 10,),


              ],
            ),
          ),
        ),
      ),
    );
  }
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}