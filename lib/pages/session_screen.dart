import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/providers/primary_data_provider.dart';
import 'package:flutter_mantras_app/recorder/sound_recorder.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:provider/provider.dart';

class SessionScreen extends StatefulWidget {
  final String? title;
  final String? subcategory;
  const SessionScreen({Key? key, this.title, this.subcategory}) : super(key: key);

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late double widthScale;
  late double heightScale;

  bool activity = true;
  bool friends = false;
  var controller = PageController(
    initialPage: 0,
  );

  final recorder = SoundRecorder();

  @override
  void initState() {
    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return Scaffold(
        body: Column(
      children: [
        /// top header
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28 * widthScale),
                bottomRight: Radius.circular(28 * widthScale)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x18000000), offset: Offset(0, 4), blurRadius: 18, spreadRadius: 0)
            ],
            color: Colors.white,
          ),
          child: Column(children: [
            /// top title bar
            Padding(
              padding: EdgeInsets.only(
                top: 48 * heightScale,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 24 * widthScale,
                  ),
                  Text('Session', style: TextStyle(fontSize: 18 * widthScale)),
                  SizedBox(
                    width: 40 * widthScale,
                  )
                ],
              ),
            ),

            ///divider
            Padding(
              padding: EdgeInsets.only(top: 16.0 * heightScale, bottom: 16 * heightScale),
              child: const Divider(),
            ),

            /// tab bar
            Padding(
              padding: EdgeInsets.only(bottom: 40 * heightScale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  activity == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Read It",
                              style: TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0 * widthScale),
                            ),
                            Container(
                                width: 56 * widthScale,
                                height: 4 * widthScale,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                  color: kPurple,
                                ))
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            onAddButtonTapped(0);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Read It',
                                style: TextStyle(
                                    color: const Color(0xff969696),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              SizedBox(
                                width: 64 * widthScale,
                                height: 4 * widthScale,
                              ),
                            ],
                          ),
                        ),
                  friends == false
                      ? GestureDetector(
                          onTap: () {
                            onAddButtonTapped(1);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Record It',
                                style: TextStyle(
                                    color: const Color(0xff969696),
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              SizedBox(
                                width: 64 * widthScale,
                                height: 4 * widthScale,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Record It',
                              style: TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0 * widthScale),
                            ),
                            Container(
                              width: 64 * widthScale,
                              height: 4 * widthScale,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                color: kPurple,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ]),
        ),

        /// body section
        Expanded(
          child: PageView(
              onPageChanged: _onPageViewChange,
              allowImplicitScrolling: false,
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: [
                /// read it tab body
                readItBody(),

                /// record it tab body
                recordItBody()
              ]),
        ),
      ],
    ));
  }

  /// readIt tab body
  Widget readItBody() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10 * widthScale, right: 10 * widthScale, top: 30 * heightScale),
                child: Text(
                  widget.title ?? 'n/a',
                  style: TextStyle(fontSize: 15 * widthScale, color: kGrey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0 * widthScale),
              child: Text('"${widget.subcategory ?? 'n/a'}"',
                  style: TextStyle(
                      fontFamily: "RobotoSlab",
                      fontSize: 28 * widthScale,
                      fontWeight: FontWeight.normal,
                      color: kPurple),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 80 * heightScale,
            )
          ],
        ),
        Consumer<ProviderDataProvider>(builder: (context, provider, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (provider.favouriteList.contains(widget.subcategory)) {
                  provider.favouriteList.removeWhere((element) => element == widget.subcategory);
                } else {
                  provider.favouriteList.add(widget.subcategory!);
                }
                provider.saveFav();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8 * heightScale),
                width: 64 * widthScale,
                height: 64 * widthScale,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x18000000),
                        offset: Offset(0, 2),
                        blurRadius: 7,
                        spreadRadius: 0)
                  ],
                ),
                child: Center(
                    child: provider.favouriteList.contains(widget.subcategory)
                        ? Icon(
                            Icons.favorite_rounded,
                            size: 36 * widthScale,
                            color: kPurple,
                          )
                        : Icon(
                            Icons.favorite_outline_rounded,
                            size: 36 * widthScale,
                            color: kGrey,
                          )),
              ),
            ),
          );
        })
      ],
    );
  }

  /// recordIt tab body
  Widget recordItBody() {
    final isRecording = recorder.isRecording;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10 * widthScale, right: 10 * widthScale, top: 30 * heightScale),
                child: Text(
                  widget.title ?? 'n/a',
                  style: TextStyle(fontSize: 15 * widthScale, color: kGrey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0 * widthScale),
              child: Text('"${widget.subcategory ?? 'n/a'}"',
                  style: TextStyle(
                      fontFamily: "RobotoSlab",
                      fontSize: 28 * widthScale,
                      fontWeight: FontWeight.normal,
                      color: kPurple),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 80 * heightScale,
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              final isRecording = await recorder.toggleRecording(
                  title: widget.subcategory ?? 'n/a', context: context);
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8 * heightScale),
              width: 64 * widthScale,
              height: 64 * widthScale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x18000000),
                      offset: Offset(0, 2),
                      blurRadius: 7,
                      spreadRadius: 0)
                ],
              ),
              child: Center(
                child: isRecording
                    ? Icon(
                        Icons.stop_circle_outlined,
                        size: 36 * widthScale,
                      )
                    : Image.asset(
                        'images/icons/record.png',
                        width: 30 * widthScale,
                        height: 30 * widthScale,
                        color: Colors.red,
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }

  onAddButtonTapped(int index) {
    controller.jumpToPage(index);
  }

  _onPageViewChange(int page) {
    if (page == 0) {
      setState(() {
        activity = true;
        friends = false;
      });
    } else {
      setState(() {
        friends = true;
        activity = false;
      });
    }
  }
}
