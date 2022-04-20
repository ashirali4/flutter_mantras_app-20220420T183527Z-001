import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/model/audio_record.dart';
import 'package:flutter_mantras_app/utils/shared_pref.dart';

class AppProvider extends ChangeNotifier{

  bool isRecListLoading = false;
  List<AudioRecord> recordingList = [];


  setIsRecLoading(value){
    isRecListLoading = value;
  }

  /// get record list from shared pref
  getRecordingsList() async {
    setIsRecLoading(true);
    AudioRecords records = await getRecordingData();
    recordingList = records.recordsList ?? [];
    setIsRecLoading(false);
    notifyListeners();
  }

  /// get records list from device storage
  // _getRecordingsList() async {
  //  setIsRecLoading(true);
  //   final String directory = (await getApplicationDocumentsDirectory()).path;
  //     try {
  //       recordingList = io.Directory("$directory/recordings/").listSync();
  //     } on Exception catch (e) {
  //       print(e);
  //     }
  //     setIsRecLoading(false);
  //     print('length - ${recordingList.length}');
  // }

}