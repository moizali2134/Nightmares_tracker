import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:terrortracker/pages/Home/Tracker.dart';



import '../../db/Childs.dart';
import '../../db/report_model.dart';
import '../../main.dart'as ms;

import '../../main.dart';

import '../../utils/NOTIFIER.dart';
import 'Setting.dart';



TooltipBehavior? _tooltipBehavior;


String defaultcolor="Color(0xff00b0ff)";
class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
   // queryAllch();

    ms.queryAll();

    getprefrence();


    _queryAll('All');


  }

  int total=0;
  int this_month_total=0;
  String general_time="00:00";
  String general_day=" ";
  List<Child>? ch;
  bool st=false;
  List<DailyReport> dailyreport = [];
  Child dropdownValue1 = childs.isEmpty ? Child(0,"All","0000",0) : childs.first;
  @override
  Widget build(BuildContext context) {

final themeChange = Provider.of<DarkThemeProvider>(context);
var size=MediaQuery.of(context).size;
if(childs.isNotEmpty){
//
  ch=childs;

}



    return AdvancedDrawer(
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
      child: Scaffold(
        appBar:  themeChange.darkTheme ? AppBar(
        //  backgroundColor: Colors.black.withOpacity(0.2),
          title: const Text('Main'),
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

          title: const Text('Main', style: TextStyle(color: Color(0xff001e8c)), ),
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
        body:
        Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:  Colors.grey,
                          width: 5,

                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child:
                          Text('$total', style: TextStyle(fontSize: 18))
                      ),
                    ),  const SizedBox(height: 2,),const Center(
                        child:
                        Text("Total Entries", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                    ),],) ,Column(children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:  Colors.grey,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child:
                          Text("$this_month_total", style: TextStyle(fontSize: 18))
                      ),
                    ),  const SizedBox(height: 2,),const Center(
                        child:
                        Text("Monthly Entry", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                    ),],)
                ],),
              SizedBox(height: size.height*0.005,),
              Column(children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:  Colors.grey,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child:
                      Text(general_time, style: TextStyle(fontSize: 18))
                  ),
                ), const SizedBox(height: 2,), const Center(
                    child:
                    Text("General Nightmare Time", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                ),],) ,
              SizedBox(height: size.height*0.005,),
              Column(children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:  Colors.grey,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child:
                      Text(general_day,
                          style: const TextStyle(fontSize: 18))
                  ),
                ),     SizedBox(height: size.height*0.005,),
                const Center(
                    child:
                    Text("Most Nightmare Day", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                ),],),
              FutureBuilder(
                future: ms.queryAll(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.error != null) {
                    return const Center(
                      child: Text(' '),
                    );
                  }  else {

                    return   Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [const Text("    Child :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                        SizedBox(height: 50,

                          child: DropdownButton(
                            hint:Text('${dropdownValue1.name}'),
                            //  value: dropdownValue1,
                            onChanged: (Child? value) {
                              // if(newValue!.name!="All"){
                              setState(() {
                                dropdownValue1 = value!;
                                _queryAll('${value.name}');
                                defaultcolor= '${value.colr}';
                                // print('${value!.colr}');

                              });
                            },

                            items: childs.map((Child value){

                              return DropdownMenuItem<Child>(
                                value: value,
                                child: Text('${value.name}'),
                              );
                            }).toList(),
                          ),)
                      ],)
                    ;

                  }
                },
              ),




              SizedBox(height: size.height*0.005,),

Expanded(child: SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    tooltipBehavior: _tooltipBehavior,

    series: <LineSeries<NightMareData, String>>[
      LineSeries<NightMareData, String>(
          dataSource:  getNightmares(),
          xValueMapper: (NightMareData values, _) => values.year,
          yValueMapper: (NightMareData values, _) => values.value,

          color: Color(int.parse(defaultcolor.toString().split('(0x')[1].split(')')[0], radix: 16)),
          dataLabelSettings: const DataLabelSettings(isVisible: true)
      ),
      // LineSeries<NightMareData, String>(
      //     dataSource:  getNightmares1(),
      //     xValueMapper: (NightMareData values, _) => values.year,
      //     yValueMapper: (NightMareData values, _) => values.value,
      //     // Enable data label
      //     color: Colors.red,
      //     dataLabelSettings: const DataLabelSettings(isVisible: true)
      // )
    ]
))



            ],),
        )
      ,

      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  _queryAll(String name) async {
    if (name == "All") {
    Future.delayed(const Duration(seconds: 2), () async {

        final allRows = await ms.dbHelper.queryAllRows(ur["id"]);
        dailyreport.clear();
        allRows.forEach((row) => dailyreport.add(DailyReport.fromMap(row)));
        // displaytoastmsg('Query done.',context);


        setState(() {
          total = dailyreport.length;
        });

    });
    }else{
      Future.delayed(const Duration(seconds: 2), () async {

        final allRows = await ms.dbHelper.queryRows(name,ur["id"]);
        dailyreport.clear();
        allRows.forEach((row) => dailyreport.add(DailyReport.fromMap(row)));
        // displaytoastmsg('Query done.',context);

        setState(() {
          // total = dailyreport.length;
        });


      });
    }
  }
//   List<NightMareData> getNightmares(){
//     if (dailyreport.isNotEmpty) {
//       List<NightMareData> nightmare = <NightMareData>[];
//       var formatter = DateFormat('MMMM');
//       var counts = dailyreport.fold<Map<String, int>>({}, (map, element) {
//         var index = dailyreport.indexOf(element);
//         var st = DateTime.parse(dailyreport[index].name!);
//         String month = formatter.format(st);
//
//         map[month] = (map[month] ?? 0) + 1;
//         // print(map.entries.toList().sort(((a, b) => a.key.compareTo(b.key))););
//
//
//         return map;
//       });
//       Future.delayed(const Duration(seconds: 5), () {
//         String month = DateFormat('MMMM').format(DateTime.now());
//         int i = counts[month]!;
//         setState(() {
//           this_month_total = i;
//           setmonthly(i);
//         });
//         getMostDay();
//         getMosTime();
//       });
//
//
// // print(sortedKeys);
// //       final sorted = SplayTreeMap<String,dynamic>.from(counts, (a, b) => a.compareTo(b));
// //       print(sorted);
// //
//       print(counts);
//         counts.forEach((key, value) {
//         nightmare.add(NightMareData(key, value.toDouble()));
//       });
//
//       return nightmare;
//     }else{
//       List<NightMareData> nightmare = <NightMareData>[];
//       return nightmare ;
//     }
//
//   }
  List<NightMareData> getNightmares(){
    if (dailyreport.isNotEmpty) {
      List<NightMareData> nightmare = <NightMareData>[];
      var formatter = DateFormat('yyyy-MM');
      var counts = dailyreport.fold<Map<String, int>>({}, (map, element) {
        var index = dailyreport.indexOf(element);
        var date = formatter.parse(dailyreport[index].name!);
        String key = formatter.format(date);

        map[key] = (map[key] ?? 0) + 1;
        return map;
      });
      Future.delayed(const Duration(seconds: 5), () {
        String date = DateFormat('yyyy-MM').format(DateTime.now());
        int i = counts[date]!;
        setState(() {
          this_month_total = i;
          setmonthly(i);
        });
        getMostDay();
        getMosTime();
      });

      SplayTreeMap<String, int> sorted = SplayTreeMap<String, int>.from(counts, (a, b) => a.compareTo(b));
     print(sorted);
    //  var sortedMap = sorted.entries.toList();
   //   print(sortedMap);
      //  print(counts);
      while (sorted.length>6) {
        sorted.remove(sorted.keys.first);
      }
      // if(sorted.length>6){
      //   sorted.remove(sorted.keys.first);
      // }
      sorted.forEach((key, value) {

        nightmare.add(NightMareData( getmonth_year(key), value.toDouble()));
      });


      return nightmare;
    }else{
      List<NightMareData> nightmare = <NightMareData>[];
      return nightmare ;
    }

  }
  getMostDay(){
    var formatter = DateFormat('EEEE');
    final list=[];
    dailyreport.forEach((e){
      // print(formatter.format(DateTime.parse(e.name!)));
      String st=formatter.format(DateTime.parse(e.name!));
      list.add(st);
    });

    // print(list);
    list.sort();
    var popularNumbers = [];
    List<Map<dynamic, dynamic>> data = [];
    var maxOccurrence = 0;

    var i = 0;
    while (i < list.length) {

      var number = list[i];
      var occurrence = 1;
      for (int j = 0; j < list.length; j++) {
        if (j == i) {
          continue;
        }
        else if (number == list[j]) {
          occurrence++;
        }
      }
      list.removeWhere((it) => it == number);
      data.add({number: occurrence});
      if (maxOccurrence < occurrence) {
        maxOccurrence = occurrence;
      }
    }

    data.forEach((map) {
      if (map[map.keys.toList()[0]] == maxOccurrence) {

        popularNumbers.add(map.keys.toList()[0]);

      }

    });

    // print(popularNumbers);
    setState(() {
      general_day=popularNumbers[0].toString();
      setdaily(general_day);
    });
  }
  getMosTime(){
    final list=[];
    dailyreport.forEach((e){
      // print(e.name);
      // print(e.start_time);
  if(!e.start_time!.contains("AM")&&!e.start_time!.contains("PM")){
     String st=DateFormat('hh:mm a').format(DateTime.parse("${e.name} ${e.start_time}"));
     list.add(st);
  }else{
    list.add(e.start_time);
  }
     // print(DateFormat('hh:mm a').format(DateTime.parse("${e.name} ${e.start_time}")));

    });

    // print(list);
    list.sort();
    var popularNumbers = [];
    List<Map<dynamic, dynamic>> data = [];
    var maxOccurrence = 0;

    var i = 0;
    while (i < list.length) {

      var number = list[i];
      var occurrence = 1;
      for (int j = 0; j < list.length; j++) {
        if (j == i) {
          continue;
        }
        else if (number == list[j]) {
          occurrence++;
        }
      }
      list.removeWhere((it) => it == number);
      data.add({number: occurrence});
      if (maxOccurrence < occurrence) {
        maxOccurrence = occurrence;
      }
    }

    data.forEach((map) {
      if (map[map.keys.toList()[0]] == maxOccurrence) {

        popularNumbers.add(map.keys.toList()[0]);

      }

    });

    // print(popularNumbers[0]);
    setState(() {
      general_time=popularNumbers[0].toString();
      settime(general_time);
    });
  }

void getprefrence() async {const mon_val = "mon_val";
    const Daily_val = "Daily_val";
const time_val = "time_val";
    SharedPreferences prefs = await SharedPreferences.getInstance();
setState(() {
  this_month_total=prefs.getInt(mon_val) ?? 0;
  general_day= prefs.getString(Daily_val) ?? "None";
  general_time= prefs.getString(time_val) ?? "00:00 AM";
});



  }
  setmonthly(int st) async {
    const mon_val = "mon_val";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(mon_val,st) ;
  }
  setdaily(String st) async {const Daily_val = "Daily_val";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Daily_val,st) ;
  }
  settime(String st) async {const time_val = "time_val";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(time_val,st) ;
  }
}
class NightMareData {
  NightMareData(this.year, this.value);
  final String year;
  final double value;
}
List<Child> ch = [];
queryAll() async {
  final allRows = await dbHelper.querychildAllRows(ur["id"]);
  ch.clear();

  allRows.forEach((row) => ch.add(Child.fromMap(row)));


  // print(childs[0].colr);


}
getmonth_year(var dat){
  var parts = dat.split("-");
  var year = parts[0]; // 2022
  var month = parts[1];// 09
  var formatter = DateFormat("MM");
  var date = formatter.parse("$month-01");
  var monthName = DateFormat.MMM().format(date);
  var lastTwoChars = year.substring(year.length-2);
  // print(lastTwoChars);
  // print(monthName);
return "$monthName $lastTwoChars";
}

