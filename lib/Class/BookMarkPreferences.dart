import 'package:shared_preferences/shared_preferences.dart';

class BookMarkPreferences{

  static SharedPreferences _preferences;
  static const _key = 'idBook';

  static Future init() async=>
      _preferences = await SharedPreferences.getInstance();

  static Future setBookID(List<String> id) async{
    await _preferences.setStringList(_key, id);
  }

  static List<String> getBookID(){
    return _preferences.getStringList(_key);
  }
}