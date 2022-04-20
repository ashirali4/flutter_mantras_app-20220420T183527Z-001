import 'dart:convert';
import 'package:flutter_mantras_app/model/audio_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// save recording file data
Future saveRecordingData(AudioRecords records) async {
  String val = jsonEncode(records);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("records_list", val);
}

/// get all recordings
Future<dynamic> getRecordingData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringValue = prefs.getString('records_list');
  AudioRecords records = AudioRecords(recordsList: []);
  if(stringValue != null) {
    Map<String, dynamic> userMap = jsonDecode(stringValue);
    records = AudioRecords.fromJson(userMap);
  }
  return Future<dynamic>.value(records);
}

/// save favourites
Future saveFavourites(List<String> favourites) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("favourite_list", favourites);
}

/// get all favourites
Future<List<String>> getFavourites() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringValue = prefs.getStringList('favourite_list');
  List<String> list = [];
  if(stringValue != null) {
    list = stringValue;
  }
  return list;
}