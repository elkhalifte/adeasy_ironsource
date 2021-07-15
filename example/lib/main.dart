import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ironsource/flutter_ironsource.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterIronSourceWidget(),
    );
  }
}

class FlutterIronSourceWidget extends StatefulWidget {
  @override
  _FlutterIronSourceWidgetState createState() =>
      _FlutterIronSourceWidgetState();
}

class _FlutterIronSourceWidgetState extends State<FlutterIronSourceWidget> {
  static const String APP_KEY = "85460dcd";
  static const String APP_KEY_IOS = "10078c0a9";

  bool ready = false;
  bool rewardLoaded = false;
  bool interstitialLoaded = false;
  bool offerWallLoaded = false;
  bool showBanner = false;

  ISBannerSize bannerSize = ISBannerSize.STANDARD;
  late Size size;

  ////
  ////
  ////  SHOW ALERT
  ///////////////////////////////
  void alert({required String title, required List<Widget> body}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: body,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  ////
  ////
  ////  Interstitial
  ///////////////////////////////
  void loadInterstitial() async {
    FlutterIronSource.instance
        .loadInterstitial(FlutterIronSourceListener(onFail: (exception) {
      print(exception);
    }, onLoad: () {
      setState(() {
        interstitialLoaded = true;
      });
    }));
  }

  void showInterstitial() async {
    FlutterIronSource.instance
        .showInterstitial(FlutterIronSourceListener(onClose: () {
      setState(() {
        interstitialLoaded = false;
      });
    }));
  }

  ////
  ////
  ////  Reward
  ///////////////////////////////
  void loadReward() async {
    FlutterIronSource.instance
        .loadRewarded(FlutterIronSourceListener(onFail: (e) {
      rewardLoaded = false;
      print(e);
    }, onLoad: () {
      setState(() {
        rewardLoaded = true;
      });
    }));
  }

  void showReward() async {
    FlutterIronSourceListener? listener;
    listener = FlutterIronSourceListener(onClose: () {
      setState(() {
        rewardLoaded = false;
      });

      //// Getting rewarded Data

      if (listener!.hasData()) {
        print(listener.getData());
        alert(title: "Reward Ad Credit", body: [
          Text("placementName:${listener.get("placementName")}"),
          Text("rewardAmount:${listener.get("rewardAmount")}"),
          Text("isDefault:${listener.get("isDefault")}")
        ]);
      }
    }, onReward: (data) {
      print("rewarded data $data");
    });

    FlutterIronSource.instance.showRewarded(listener);
  }

  ////
  ////
  ////  OfferWall
  ///////////////////////////////
  void loadOfferWall() async {
    FlutterIronSource.instance
        .loadOfferWall(FlutterIronSourceListener(onLoad: () {
      setState(() {
        offerWallLoaded = true;
      });
    }));
  }

  void showOfferWall() async {
    FlutterIronSourceListener? listener;

    listener = FlutterIronSourceListener(
        onClose: () {
          setState(() {
            offerWallLoaded = false;
          });

          if (listener!.hasData()) {
            alert(title: "Offerwall Ad Credit", body: [
              Text(
                  "Credits:${listener.get("credits")} TotalCredit:${listener.get("totalCredits")} totalCreditsFlag:${listener.get("totalCreditsFlag")}")
            ]);
          }
        },
        onReward: (data) {});

    FlutterIronSource.instance.showOfferWall(listener);
  }

  ////
  ////  INIT FlutterIronSource
  ///////////////////////
  Future<void> initFlutterIronSource() async {
    await FlutterIronSource.instance.init(
        appKey: Platform.isAndroid ? APP_KEY : APP_KEY_IOS,
        testMode: true,
        consent: true,
        userID: "");

    setState(() {
      ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterIronSource Plugin'),
      ),
      body: ready
          ? Container(
              width: size.width,
              height: size.height - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Banner Ad".toUpperCase()),
                          trailing: ElevatedButton(
                            child: Text(showBanner ? "Hide" : "Show"),
                            onPressed: () {
                              setState(() {
                                showBanner = showBanner ? false : true;
                              });
                            },
                          ),
                        ),
                        ListTile(
                            title: Text("Interstitial Ad".toUpperCase()),
                            trailing: ElevatedButton(
                              child: Text(interstitialLoaded ? "Show" : "Load"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => interstitialLoaded
                                              ? Colors.deepPurple
                                              : Colors.blueAccent)),
                              onPressed: () {
                                setState(() {
                                  if (interstitialLoaded) {
                                    showInterstitial();
                                  } else {
                                    loadInterstitial();
                                  }
                                });
                              },
                            )),
                        ListTile(
                          title: Text("Reward Ad".toUpperCase()),
                          trailing: ElevatedButton(
                            child: Text(rewardLoaded ? "Show" : "Load"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => rewardLoaded
                                            ? Colors.deepPurple
                                            : Colors.blueAccent)),
                            onPressed: () {
                              setState(() {
                                if (rewardLoaded) {
                                  showReward();
                                } else {
                                  loadReward();
                                }
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("OfferWall AD".toUpperCase()),
                          trailing: ElevatedButton(
                            child: Text(offerWallLoaded ? "Show" : "Load"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => offerWallLoaded
                                            ? Colors.deepPurple
                                            : Colors.blueAccent)),
                            onPressed: () {
                              setState(() {
                                if (offerWallLoaded) {
                                  showOfferWall();
                                } else {
                                  loadOfferWall();
                                }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  if (showBanner)
                    Container(
                      width: bannerSize.width.toDouble(),
                      height: bannerSize.height.toDouble(),
                      color: Colors.red,
                      child: ISPluginBannerAd(
                          size: bannerSize, placement_id: "DefaultBanner"),
                    ),
                  SizedBox(height: 100)
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    initFlutterIronSource();
  }
}
