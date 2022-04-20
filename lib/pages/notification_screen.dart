import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mantras_app/notifications/notifications.dart';
import 'package:flutter_mantras_app/providers/primary_data_provider.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:flutter_mantras_app/utils/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late double widthScale;
  late double heightScale;

  bool activity = true;
  bool friends = false;
  var controller = PageController(initialPage: 0);

  // for scheduled notifications
  bool isExpand = false;
  List<String> dropDownList2 = ["Repeat", "Once"];
  String? selectedDate;
  String? selectedRepeatType = '';
  String? selectedAffirmation = '';
  int? hour, minute;

  // for random notifications
  List<String> selectedList = [];
  final repeatList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int selectedValue = -1;

  @override
  void initState() {
    super.initState();
    LocalNotifications.init(initScheduled: true);
  }

  @override
  Widget build(BuildContext context) {
    widthScale = MediaQuery.of(context).size.width / 390;
    heightScale = MediaQuery.of(context).size.height / 845;
    return Scaffold(
      body: Column(
        children: [
          /// top bar
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
                  top: 65 * heightScale,
                ),
                child: Text('Notification', style: TextStyle(fontSize: 18 * widthScale)),
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
                                "Random Notification",
                                style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              Container(
                                width: 145 * widthScale,
                                height: 4 * widthScale,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(3.5)),
                                  color: kPurple,
                                ),
                              ),
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
                                  'Random Notification',
                                  style: TextStyle(
                                      color: const Color(0xff969696),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0 * widthScale),
                                ),
                                SizedBox(
                                  width: 145 * widthScale,
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
                                  'Schedule Notification',
                                  style: TextStyle(
                                      color: const Color(0xff969696),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0 * widthScale),
                                ),
                                SizedBox(
                                  width: 150 * widthScale,
                                  height: 4 * widthScale,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Schedule Notification',
                                style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0 * widthScale),
                              ),
                              Container(
                                width: 150 * widthScale,
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
                  /// random notification body
                  randomBody(),

                  /// scheduled notification body
                  scheduleBody()
                ]),
          ),
        ],
      ),
    );
  }

  /// random notification body
  Widget randomBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0 * heightScale, left: 20 * widthScale),
              child: Text(
                'Select the Affirmations you want',
                style: TextStyle(
                  fontSize: 16 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 14 * widthScale, right: 14 * widthScale, top: 16.0 * heightScale),
            height: 320 * heightScale,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x18000000), offset: Offset(0, 2), blurRadius: 7, spreadRadius: 0)
              ],
            ),
            child: Consumer<ProviderDataProvider>(builder: (context, provider, child) {
              return ListView.builder(
                padding: EdgeInsets.only(
                    left: 4 * widthScale,
                    right: 4 * widthScale,
                    top: 8 * heightScale,
                    bottom: 8 * heightScale),
                shrinkWrap: true,
                itemCount: provider.affList.length,
                itemBuilder: (context, index1) {
                  return Theme(
                    data: ThemeData().copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Mantras for a Happy Life',
                        style: TextStyle(
                          fontSize: 16 * widthScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: <Widget>[
                        Column(
                          children: provider.affList[index1].subcategories!
                              .map((e) => ListTile(
                                    onTap: () {
                                      setState(() {
                                        if (selectedList.contains(e)) {
                                          selectedList.removeWhere((element) => element == e);
                                        } else {
                                          selectedList.add(e);
                                        }
                                      });
                                    },
                                    title: Text(
                                      e,
                                      style: TextStyle(fontSize: 15.5 * widthScale),
                                    ),
                                    trailing: Icon(
                                      selectedList.contains(e)
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked,
                                      color: selectedList.contains(e) ? kPurple : Colors.grey,
                                      size: 24 * widthScale,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20.0 * heightScale, left: 20 * widthScale),
              child: Text(
                'How often do you want affirmation',
                style: TextStyle(
                  fontSize: 16 * widthScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 14 * widthScale, right: 14 * widthScale, top: 16.0 * heightScale),
            padding: EdgeInsets.only(left: 32 * widthScale, right: 40 * widthScale),
            height: 100 * heightScale,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x18000000), offset: Offset(0, 2), blurRadius: 7, spreadRadius: 0)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily',
                  style: TextStyle(fontSize: 15.5 * widthScale),
                ),
                SizedBox(
                  width: 120 * widthScale,
                  height: 100 * heightScale,
                  child: CupertinoPicker(
                      useMagnifier: false,
                      //scrollController: fTypeController,
                      backgroundColor: Colors.transparent,
                      selectionOverlay: Container(
                        decoration: BoxDecoration(
                          color: kPurple.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(Radius.circular(22)),
                        ),
                      ),
                      itemExtent: 40 * heightScale,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedValue = repeatList[index];
                        });
                      },
                      children: repeatList
                          .map(
                            (e) => Center(
                              child: Text(
                                "$e",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16 * widthScale, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                          .toList()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// scheduled notifications body
  Widget scheduleBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 20 * widthScale, left: 20 * widthScale),
              decoration: BoxDecoration(
                color: kPurple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPurple.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                color: Colors.white,
                icon: Icon(isExpand ? Icons.close : Icons.add),
                onPressed: () {
                  setState(() {
                    isExpand = !isExpand;
                  });
                },
              ),
            ),
          ),
          isExpand
              ? Container(
                  margin: EdgeInsets.only(
                      left: 14 * widthScale, right: 14 * widthScale, top: 14 * widthScale),
                  padding: EdgeInsets.only(top: 16 * heightScale, bottom: 16 * heightScale),
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8 * heightScale, top: 8 * heightScale),
                          child: Text(
                            'Add your Affirmations notification',
                            style: TextStyle(fontSize: 16 * widthScale),
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24 * widthScale,
                            right: 18 * widthScale,
                            bottom: 4 * heightScale,
                            top: 8 * heightScale),
                        child: Text(
                          'Affirmations',
                          style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                        ),
                      ),
                      Consumer<ProviderDataProvider>(builder: (context, provider, child) {
                        return Container(
                          height: 64 * heightScale,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                          margin: EdgeInsets.only(
                              left: 18 * widthScale,
                              right: 18 * widthScale,
                              top: 8 * heightScale,
                              bottom: 8 * heightScale),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: Colors.grey, width: 0.25),
                          ),
                          child: Center(
                            child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: widthScale * 24,
                                ),
                                //underline: SizedBox(),
                                decoration: const InputDecoration(border: InputBorder.none),
                                hint: Text(
                                  'Select Affirmation',
                                  style: TextStyle(
                                      color: const Color(0xff9e9e9e),
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      fontSize: widthScale * 15.5),
                                ),
                                items: provider.favouriteList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15.5 * widthScale)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedAffirmation = value;
                                  });
                                }),
                          ),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24 * widthScale,
                            right: 18 * widthScale,
                            bottom: 4 * heightScale,
                            top: 8 * heightScale),
                        child: Text(
                          'Time',
                          style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showTime12hPicker(context, showTitleActions: true,
                              onChanged: (date) {
                            setState(() {
                              selectedDate = DateFormat('hh:mm a').format(date);
                              hour = date.hour;
                              minute = date.minute;
                            });
                          }, onConfirm: (date) {
                            setState(() {
                              selectedDate = DateFormat('hh:mm a').format(date);
                              hour = date.hour;
                              minute = date.minute;
                            });
                          }, currentTime: DateTime.now());
                        },
                        child: Container(
                          height: 64 * heightScale,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                          margin: EdgeInsets.only(
                              left: 18 * widthScale,
                              right: 18 * widthScale,
                              top: 8 * heightScale,
                              bottom: 8 * heightScale),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: Colors.grey, width: 0.25),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedDate ?? 'Select Time',
                              style: selectedDate == null
                                  ? TextStyle(
                                      color: const Color(0xff9e9e9e),
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.5 * widthScale)
                                  : TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.5 * widthScale),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24 * widthScale,
                            right: 18 * widthScale,
                            bottom: 4 * heightScale,
                            top: 8 * heightScale),
                        child: Text(
                          'Repeat Type',
                          style: TextStyle(fontSize: 14 * widthScale, color: kPurple),
                        ),
                      ),
                      Container(
                        height: 64 * heightScale,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 12 * widthScale, right: 12 * widthScale),
                        margin: EdgeInsets.only(
                            left: 18 * widthScale,
                            right: 18 * widthScale,
                            top: 8 * heightScale,
                            bottom: 8 * heightScale),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: Colors.grey, width: 0.25),
                        ),
                        child: Center(
                          child: DropdownButtonFormField<String>(
                              //value: selectedAffirmation,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: widthScale * 24,
                              ),
                              //underline: SizedBox(),
                              decoration: const InputDecoration(border: InputBorder.none),
                              hint: Text(
                                'Select Repeat Type',
                                style: TextStyle(
                                    color: const Color(0xff9e9e9e),
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    fontSize: widthScale * 15.5),
                              ),
                              items: dropDownList2.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.5 * widthScale)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedRepeatType = value;
                                });
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 18 * widthScale, top: 8 * heightScale),
                          child: SizedBox(
                            width: 120 * widthScale,
                            height: 48 * heightScale,
                            child: ElevatedButton(
                              onPressed: () {
                                if (selectedAffirmation == '') {
                                  SnackBarMessage.show(
                                      context: context, message: "Please select a Affirmation");
                                } else if (hour == null || minute == null) {
                                  SnackBarMessage.show(
                                      context: context, message: "Please select a time");
                                } else if (selectedRepeatType == '') {
                                  SnackBarMessage.show(
                                      context: context, message: "Please select a repeat type");
                                } else {
                                  LocalNotifications.showScheduledNotification(
                                      id: int.parse('$hour$minute'),
                                      title: 'Affirmation for the Day',
                                      body: '$selectedAffirmation',
                                      payload: 'payload 1',
                                      hour: hour!,
                                      minute: minute!,
                                      type: selectedRepeatType!);
                                  SnackBarMessage.show(
                                      context: context, message: "Notification setup success");
                                  setState(() {
                                    selectedDate = null;
                                    selectedAffirmation = '';
                                    selectedRepeatType = '';
                                    isExpand = !isExpand;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: kPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0 * widthScale),
                                ),
                              ),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    fontSize: 15 * widthScale,
                                    fontFamily: "Poppins",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
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
