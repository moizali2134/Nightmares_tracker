import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:terrortracker/db/report_model.dart';
import 'package:terrortracker/utils/DataSource.dart';


import '../../main.dart'as ms;
import '../../main.dart';
import '../../utils/Add_Mighmare.dart';
import '../../utils/NOTIFIER.dart';
import '../../utils/edit_nightmare.dart';
import 'HomePage.dart';
import 'Child_Setting.dart';
import 'Setting.dart';






class TrackerPage extends StatefulWidget {
  @override
  _TrackerState createState() => _TrackerState();
}


class _TrackerState extends State<TrackerPage> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();


    _calendarController = CalendarController();
    _queryAll();
    ms.queryAll();
  }

  void _showMessageInScaffold(String message,BuildContext cx){
    ScaffoldMessenger.of(cx).showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  List<DailyReport> daily_report = [];
  late CalendarController _calendarController ;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    _calendarController.displayDate=DateTime(DateTime.parse(today).year,DateTime.parse(today).month,DateTime.parse(today).day,DateTime.parse(today).hour,DateTime.parse(today).minute);

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
          title: const Text('Tracker'),
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

          title: const Text('Tracker', style: TextStyle(color: Color(0xff001e8c)), ),
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
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
              [
                ElevatedButton(
                  onPressed: () {

                    _calendarController.displayDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

                  },
                  child: const Text('TODAY'),

                ),
                const SizedBox(width: 20,),
              ],),
            SizedBox(
               height:MediaQuery.of(context).size.height*0.7
              ,child: SfCalendar(
              view: CalendarView.week,

              controller: _calendarController,
              dataSource: DataSource(getNightmares()),
              // onLongPress: DeleteEntry,
              onTap:tapPressed,
              // onCalendarTapped,
              timeSlotViewSettings: const TimeSlotViewSettings(

                  timeFormat: 'h a'
              ),

            ),),

          ],
        ),


        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(childs.isNotEmpty && childs.length!=1)
            {

            add_nightmare(context,"tracker");
            }
            else
            {
              displaytoastmsg("Kindly List child in Settings then add Add NightMare", context);
            }
          },
          backgroundColor: Colors.white54,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  void tapPressed(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments == null) {
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext cx) {
          return Dialog(

                shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(30.0)),
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Select One of The Options Below",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                     const SizedBox(height: 5,),
          ElevatedButton(onPressed: (){
                onCalendarTapped(calendarTapDetails);

              }, child: const Text('Update')),
              ElevatedButton(onPressed: (){
                today=calendarTapDetails.date.toString();
                _delete(calendarTapDetails.appointments![0]!.id);

                Navigator.pushAndRemoveUntil(
                  cx,
                  MaterialPageRoute(builder: (BuildContext context) => TrackerPage()),
                      (route)=>false,
                );

              }, child: const Text('Delete'))
                    ],
                  ),
                ),
              );
            // title:Container(child: const Text("Update or Delete")),
            // content:Column(
            //   // mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //
            // ],),
              ;
        });
  }
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    // if(calendarTapDetails!=null){

    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }


    DateTime _startDate;
    TimeOfDay _startTime;
    DateTime _endDate;
    String chnam;

    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments!.length == 1) {
      final Appointment nightDetails = calendarTapDetails.appointments![0];
     // print(calendarTapDetails.appointments![0]);

      _startDate = nightDetails.startTime;
      _endDate =nightDetails.endTime;
      print("${nightDetails!.id} ${nightDetails.startTime}");

    } else {
      final DateTime? date = calendarTapDetails.date;
      _startDate = date!;
      _endDate = date.add(const Duration(hours: 2));
    }
    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);


    update_nightmare(context,DateFormat('yyyy-MM-dd').format(calendarTapDetails.appointments![0].startTime),DateFormat('hh:mm a').format(calendarTapDetails.appointments![0].startTime),calendarTapDetails.appointments![0]!.id,daily_report[int.parse(calendarTapDetails.appointments![0]!.notes)].child_name.toString());
// Navigator.of(context).pop();
  }
  int? getindex(String chd){
    int i=0;
    for (var e in daily_report) {
      if(e.child_name==chd){
        return i;
      }
      i++;
    }
    return null;
  }
   _queryAll() async {
    final allRows = await ms.dbHelper.queryAllRows(ur["id"]);
    daily_report.clear();
    allRows.forEach((row) => daily_report.add(DailyReport.fromMap(row)));


    setState(() {});
  }
  List<Appointment> getNightmares(){
    List<Appointment> nightmare =<Appointment>[];

    for (int e=0;e<= daily_report.length-1;e++) {
    // if(!dailyreport[e].start_time!.contains("AM")&&!dailyreport[e].start_time!.contains("PM")){
    //  print(dailyreport[e]!.start_time);
    //     nightmare.add(
    //         Appointment(
    //           startTime:
    //           DateTime.parse("${dailyreport[e].name} ${dailyreport[e].start_time}"),
    //           endTime:DateTime.parse("${dailyreport[e].name} ${dailyreport[e].start_time}").add(const Duration( hours:1 )) ,
    //           color: Color(int.parse(dailyreport[e].child_color
    //               .toString().split('(0x')[1].split(')')[0],
    //               radix: 16)),
    //           subject: getInitials("${dailyreport[e].child_name}")
    //           ,
    //         )
    //     );
    //   }else{
      var startTime;
      if(daily_report[e].start_time=="12:00 PM"){
        daily_report[e].start_time= daily_report[e].start_time!.replaceAll("PM",""); // myString is "s t r"

        startTime = TimeOfDay(hour:int.parse(daily_report[e].start_time!.split(":")[0]),minute:
        int.parse(daily_report[e].start_time!.split(":")[1].split(" ")[0]));
      }
      else if(daily_report[e].start_time=="12:00 AM"){
        daily_report[e].start_time="00:00 AM";
        daily_report[e].start_time=daily_report[e].start_time!.replaceAll("AM","");
        startTime = TimeOfDay(hour:int.parse(daily_report[e].start_time!.split(":")[0]),minute: int.parse(daily_report[e].start_time!.split(":")[1].split(" ")[0]));
      }
      else if(daily_report[e].start_time!.contains("PM")){
        daily_report[e].start_time=daily_report[e].start_time!.replaceAll("PM","");
        startTime = TimeOfDay(hour:int.parse(daily_report[e].start_time!.split(":")[0])+12,minute: int.parse(daily_report[e].start_time!.split(":")[1].split(" ")[0]));

      }
      else{
        daily_report[e].start_time=daily_report[e].start_time!.replaceAll("AM","");
        startTime = TimeOfDay(hour:int.parse(daily_report[e].start_time!.split(":")[0]),minute: int.parse(daily_report[e].start_time!.split(":")[1].split(" ")[0]));

      }if(daily_report[e].child_color!=" "){
        getchildcolor("${daily_report[e].child_name}");
      nightmare.add(
          Appointment(
            notes: "$e",
            id: daily_report[e].id,
            startTime:
            DateTime.parse("${daily_report[e].name} ${startTime.toString().split('TimeOfDay(')[1].split(')')[0]}"),
            endTime:DateTime.parse("${daily_report[e].name} ${startTime.toString().split('TimeOfDay(')[1].split(')')[0]}").add(const Duration( hours:1 )) ,
            color: daily_report[e].child_color!=" " ?Color(int.parse(getchildcolor("${daily_report[e].child_name}").toString().split('(0x')[1].split(')')[0],
                radix: 16)):Colors.blueAccent,
            subject: getInitials("${daily_report[e].child_name}")
            ,
          )
      );}
    // }

    }

    return nightmare;

  }
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('deleted Entry: $id',context);
  }
}


String getInitials(String Name) => Name.isNotEmpty&&Name!=" "
    ? Name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
    : '';

getchildcolor(String name){

  var colr = childs.firstWhere((x) => x.name! == name,
);

return colr.colr;
print(colr.colr);
}