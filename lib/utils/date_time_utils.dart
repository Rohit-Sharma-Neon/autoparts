import "package:intl/intl.dart";

int getCurrentYear() {
  DateTime dateTimeNow = DateTime.now();
  return dateTimeNow.year;
}

String getYear(DateTime dateTime) {
  return dateTime.year.toString();
}

var myFormat = DateFormat('yyyy');

String formatDateTimeNow() {
  DateTime dateTimeNow = DateTime.now();

  var formattedDate = DateFormat("dd-MM-yyyy").format(dateTimeNow);
  return formattedDate;
}

int getCurrentMonth() {
  DateTime dateTimeNow = DateTime.now();
  return dateTimeNow.month;
}
