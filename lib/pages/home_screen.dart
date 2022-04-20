import 'package:flutter/material.dart';
import 'package:flutter_mantras_app/model/affirmation.dart';
import 'package:flutter_mantras_app/pages/session_screen.dart';
import 'package:flutter_mantras_app/providers/primary_data_provider.dart';
import 'package:flutter_mantras_app/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final friendActivity = Provider.of<ProviderDataProvider>(context, listen: false);
    friendActivity.getData(context);
    friendActivity.getFav();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScale = MediaQuery.of(context).size.width / 390;
    final double heightScale = MediaQuery.of(context).size.height / 845;
    return Stack(
        children: [
        Consumer<ProviderDataProvider>(builder: (context, provider, child) {
          return Padding(
                padding: EdgeInsets.only(top:116*heightScale),
                child: Column(
                  children: [
                    Expanded(
                      child: !provider.isLoading && provider.affList.isNotEmpty ?
                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                              crossAxisSpacing: 14*widthScale,
                              mainAxisSpacing: 14*widthScale,
                              childAspectRatio: 2.5 / 3),
                          padding: EdgeInsets.only(left: 14*widthScale, right: 14*widthScale, top: 20*widthScale, bottom: 20*widthScale),
                          itemCount: provider.affList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                showSubCategories(context,provider.affList[index]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8*widthScale),
                                decoration: const BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x18000000),
                                        offset: Offset(0, 2),
                                        blurRadius: 7,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${provider.affList[index].title}',
                                    style: TextStyle(
                                        fontSize: 16.5*widthScale,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          })
                          : !provider.isLoading && provider.affList.isEmpty ?
                      const Center(
                        child: Text('No Affirmations Found !'),
                      ) : const Center(child: CircularProgressIndicator())
                    ),
                  ],
                ),
              );}),
          Container(
            width: double.infinity,
            height: 116 * heightScale,
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(28 * widthScale),
                  bottomLeft: Radius.circular(28 * widthScale)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x18000000),
                    offset: Offset(0, 4),
                    blurRadius: 18,
                    spreadRadius: 0)
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 65*heightScale),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Session",
                  style: TextStyle(fontSize: 18*widthScale),
                ),
              ),
            ),
          ),
    ]);
  }

  /// sub categories pop up alert
  showSubCategories(BuildContext context, Affirmation aff){
    final double widthScale = MediaQuery.of(context).size.width / 390;
    showDialog<void>(
      context: context,
      builder: (BuildContext cntx) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16*widthScale,vertical: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28.0*widthScale))),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 4*widthScale),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(left:8*widthScale,right:8*widthScale,top: 4*widthScale,),
                    child: IconButton(
                      splashRadius: 24*widthScale,
                      icon: Container(
                        width: 56*widthScale,
                        height: 56*widthScale,
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
                        child: Center(child:Icon(Icons.close,size: 24*widthScale,color: Colors.white,)),),
                      onPressed: (){
                        Navigator.pop(cntx);
                      },
                    ),
                  ),
                ),
                Text('${aff.title}',style: TextStyle(fontSize: 15.5*widthScale,fontWeight: FontWeight.bold),),
                Padding(
                  padding: EdgeInsets.only(top:8.0*widthScale),
                  child: const Divider(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left:16*widthScale,right:16*widthScale),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: aff.subcategories?.length ?? 0,
                              itemBuilder: (context1,index){
                                return ListTile(
                                  title: Text('${aff.subcategories?[index]}',style: TextStyle(fontSize: 15*widthScale),),
                                  onTap: (){
                                    Navigator.pop(cntx);
                                    pushNewScreenWithRouteSettings(
                                      context,
                                      settings: const RouteSettings(name: '/session'),
                                      screen: SessionScreen(title: aff.title,subcategory: aff.subcategories![index],),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                );
                              })
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
