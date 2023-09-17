import 'package:syncfusion_flutter_calendar/calendar.dart'as terror;

class DataSource extends terror.CalendarDataSource{

  DataSource(List<terror.Appointment> nightmare){
    appointments = nightmare;
  }
}