import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mantras_app/model/audio_record.dart';
import 'package:flutter_mantras_app/providers/app_provider.dart';
import 'package:flutter_mantras_app/utils/shared_pref.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundRecorder{

  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInitialized = false;
  bool get isRecording => _soundRecorder!.isRecording;
  String filePath = '';
  String fileName = '';

  Future init() async{
    _soundRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Mic permission required');
    }

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    filePath = '$appDocumentsPath/recordings'; // 3
    print(filePath);
    if(await Directory(filePath).exists()){
      print('exist');
    }else{
      Directory(filePath).create();
    }

    _soundRecorder!.openRecorder();
    isRecorderInitialized = true;
  }

  Future dispose() async{
    _soundRecorder!.closeRecorder();
    _soundRecorder = null;
    isRecorderInitialized = false;
  }

  Future _record() async{
    fileName = DateFormat("dd_MM_yyyy_HH_mm").format(DateTime.now()).toString();
    await _soundRecorder!.startRecorder(toFile: "$filePath/$fileName.aac");
  }

  Future _stop(String? title,BuildContext? context) async{
    await _soundRecorder!.stopRecorder();
    AudioRecords records = await getRecordingData();
    records.recordsList!.add(
        AudioRecord(
          id: fileName,
          title: title ?? '',
          filePath: "$filePath/$fileName.aac",
          date: fileName
        )
    );
    saveRecordingData(records).whenComplete((){
      final friendActivity = Provider.of<AppProvider>(context!, listen: false);
      friendActivity.getRecordingsList();
    });
  }

  Future toggleRecording({String? title,BuildContext? context}) async{
    if(_soundRecorder!.isStopped){
      await _record();
    }else{
      await _stop(title,context);
    }
  }




}