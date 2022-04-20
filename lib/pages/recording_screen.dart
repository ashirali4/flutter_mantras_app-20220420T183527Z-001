import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/player/common.dart';
import 'package:flutter_mantras_app/player/control_buttons.dart';
import 'package:flutter_mantras_app/providers/app_provider.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

class RecordingsScreen extends StatefulWidget {
  const RecordingsScreen({Key? key}) : super(key: key);

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> with WidgetsBindingObserver {

  late double widthScale, heightScale;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    final friendActivity = Provider.of<AppProvider>(context, listen: false);
    friendActivity.getRecordingsList();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return Stack(
      children: [
        /// body (list view)
        Consumer<AppProvider>(builder: (context, provider, child) {
          return Padding(
            padding: EdgeInsets.only(top: 116 * heightScale),
            child: Column(
              children: [
                Expanded(
                    child: !provider.isRecListLoading && provider.recordingList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                                left: 14 * widthScale,
                                right: 14 * widthScale,
                                top: 20 * heightScale),
                            itemCount: provider.recordingList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // await player.togglePlaying(
                                  //   whenFinished: ()=>setState(() {}),
                                  //   filePath: recordingList[index].path
                                  // );
                                  // setState(() {});
                                  setAudioSource(provider.recordingList[index].filePath ?? '');
                                  showPlayer();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16 * heightScale),
                                  padding: EdgeInsets.only(
                                      left: 12 * widthScale,
                                      right: 12 * widthScale,
                                      top: 20 * heightScale,
                                      bottom: 20 * heightScale),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(18)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0x18000000),
                                          offset: Offset(0, 2),
                                          blurRadius: 7,
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Title',
                                            style: TextStyle(
                                                fontSize: 13.5 * widthScale, color: kPurple),
                                          ),
                                          SizedBox(
                                            width: 185 * widthScale,
                                            child: Text(
                                              provider.recordingList[index].title ?? 'n/a',
                                              style: TextStyle(fontSize: 15 * widthScale),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Length',
                                                  style: TextStyle(
                                                      fontSize: 13.5 * widthScale, color: kPurple)),
                                              Text(
                                                  "${provider.recordingList[index].length ?? '00:00'}",
                                                  style: TextStyle(fontSize: 15 * widthScale)),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 24 * widthScale,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Date',
                                                  style: TextStyle(
                                                      fontSize: 13.5 * widthScale, color: kPurple)),
                                              Text(
                                                  DateFormat("dd MMM yyyy").format(
                                                      DateFormat("dd_MM_yyyy_HH_mm").parse(
                                                          provider.recordingList[index].date ?? '')),
                                                  style: TextStyle(fontSize: 15 * widthScale)),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                        : !provider.isRecListLoading && provider.recordingList.isEmpty
                            ? Center(
                                child: Text('No Recordings Found !'),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              )),
              ],
            ),
          );
        }),
        /// top header (Recordings)
        Container(
          width: double.infinity,
          height: 116 * heightScale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(28 * widthScale),
                bottomLeft: Radius.circular(28 * widthScale)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x18000000), offset: Offset(0, 4), blurRadius: 18, spreadRadius: 0)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 65 * heightScale),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Recordings",
                  style: TextStyle(fontSize: 18 * widthScale),
                )),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  /// initialize audio player
  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  /// set audio file to player
  setAudioSource(String filePath) async {
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setFilePath(filePath);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, bufferedPosition, duration ?? Duration.zero));

  /// show audio player pop up
  showPlayer() {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 240 * heightScale,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8 * widthScale,
                    right: 8 * widthScale,
                    top: 4 * widthScale,
                  ),
                  child: IconButton(
                    splashRadius: 24 * widthScale,
                    icon: Container(
                      width: 64 * widthScale,
                      height: 64 * widthScale,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Icon(
                        Icons.close,
                        size: 28 * widthScale,
                        color: Colors.black,
                      )),
                    ),
                    onPressed: () async {
                      await _player.stop();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              ControlButtons(_player),
              // Display seek bar. Using StreamBuilder, this widget rebuilds
              // each time the position, buffered position or duration changes.
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: _player.seek,
                  );
                },
              ),
            ],
          )),
        );
      },
    );
  }

  /// get duration of the recording
  Future<dynamic> getDuration(String path) async {
    AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setFilePath(path).whenComplete(() {
        audioPlayer.duration!.inSeconds;
        print(audioPlayer.duration!.inSeconds);
      });
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

}
