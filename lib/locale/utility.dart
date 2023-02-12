import '../utility/base.dart';
import 'package:intl/intl.dart';
import 'localization.dart';

//reference - https://medium.com/@podcoder/flutter-localization-a39402757a42

//use sharedpreference to store locale setting
// Future<Locale> setLocale(String languageCode) async {
//   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   await _prefs.setString(LAGUAGE_CODE, languageCode);
//   return _locale(languageCode);
// }

Future<Locale> getLocale() async {
  //should get from sharedpreference
  return Locale('en', '');
}


String getTranslated(BuildContext context, String key) {
  return Localization.of(context).translate(key);
}

NumberFormat getCurrencyFormat(){
  return NumberFormat.currency(name: getCurrencyCode());
}

DateFormat getMonthFormat(){
  return DateFormat('MMMM y');
}

DateFormat getDateFormat(){
  return DateFormat('d MMMM y');
}

DateFormat getDateTimeFormat(){
  return DateFormat('d MMMM y - hh:mm a');
}

//require upgrade to multi national currency
String getCurrencyCode(){
  return 'RM';
}

class Common{
  static String url = '35.192.17.83';
}