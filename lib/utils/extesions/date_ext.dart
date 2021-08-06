// class DateExtensions{
//   static String getSimpleDay(DateTime dateTime){
//     final dd = dateTime.day < 10 ? '0${dateTime.day}' : '${dateTime.day}';
//     final mm = dateTime.month < 10 ? '0${dateTime.month}' : '${dateTime.month}';
//     final yy = '${dateTime.year}';
//
//     return "$dd/$mm/$yy";
//   }
// }

extension DateExtensions on DateTime{
  String get getSimpleDay {
    final dd = this.day < 10 ? '0${this.day}' : '${this.day}';
    final mm = this.month < 10 ? '0${this.month}' : '${this.month}';
    final yy = '${this.year}';

    return "$dd/$mm/$yy";
  }
}