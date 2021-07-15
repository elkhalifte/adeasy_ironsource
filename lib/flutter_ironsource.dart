import 'dart:async';

import 'package:flutter/services.dart';
import 'iron_source_listener.dart';
export './units/banner.dart';
export './iron_source_listener.dart';
import './constants.dart';

class FlutterIronSource {
  static FlutterIronSource? _instance;
  final MethodChannel methodChannel = MethodChannel(Constants.CHANNEL);
  FlutterIronSourceListener? _listener;
  static const String TAG = "IronSourcePlugin > ";

  FlutterIronSource() {
    print("init method");
    methodChannel.setMethodCallHandler(_handler);
  }

  Future _handler(MethodCall call) async {
    var method = call.method;
    var args = call.arguments;

    print("$TAG method:$method  args: $args");

    switch (method) {
      case Constants.EVENT_LOAD:
        {
          _listener?.onLoad!();
          break;
        }

      case Constants.EVENT_FAIL:
        {
          _listener?.onFail!(Exception(args["error"] ?? ""));
          break;
        }

      case Constants.EVENT_CLICK:
        {
          _listener?.onClick!();
          break;
        }

      case Constants.EVENT_CLOSE:
        {
          _listener?.onClose!();
          break;
        }

      case Constants.EVENT_COMPLETE:
        {
          _listener?.onComplete!();
          break;
        }

      case Constants.EVENT_REWARDE:
        {
          _listener?.setData(args["data"] ?? args);
          _listener?.onReward!(_listener?.getData());
          break;
        }

      case Constants.EVENT_START:
        {
          _listener?.onStart!();
          break;
        }

      case Constants.EVENT_LEAVE:
        {
          _listener?.onLeave!();
          break;
        }

      case Constants.EVENT_IMPRESSION:
        {
          _listener?.onLeave!();
          break;
        }

      default:
        {}
    }
  }

  Future<bool> init(
      {bool testMode = false,
      required String appKey,
      bool consent = false,
      String? userID}) async {
    var result = await methodChannel.invokeMethod(Constants.METHOD_INIT, {
      "appKey": appKey,
      "debugMode": testMode,
      "consent": consent,
      "userID": userID ?? ""
    });

    return result;
  }

  Future<void> setConcent({required String userID}) async {
    await methodChannel.invokeMethod(Constants.METHOD_SET_CONCENT, {
      "userID": userID,
    });
  }

  Future<void> pause({required String userID}) async {
    await methodChannel.invokeMethod(Constants.METHOD_PAUSE, {});
  }

  Future<void> resume() async {
    await methodChannel.invokeMethod(Constants.METHOD_RESUME, {});
  }

  Future<void> setUserId(String? userID) async {
    await methodChannel.invokeMethod(Constants.METHOD_SET_USER, {
      "userID":userID ?? ""
    });
  }


  Future<void> shouldTrackNetworkState({required bool state}) async {
    await methodChannel
        .invokeMethod(Constants.METHOD_SET_TRACK_NETWORK, {"state": state});
  }

  Future<String> getAdvertiserID() async {
    return await methodChannel
        .invokeMethod(Constants.METHOD_GET_ADVERTISER_ID, {});
  }

  Future<bool> loadInterstitial([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result = await methodChannel
        .invokeMethod(Constants.METHOD_LOAD_INTERSTITIAL, {});

    return result;
  }

  Future<bool> showInterstitial([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result = await methodChannel
        .invokeMethod(Constants.METHOD_SHOW_INTERSTITIAL, {});

    return result;
  }

  Future<bool> loadRewarded([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result =
        await methodChannel.invokeMethod(Constants.METHOD_LOAD_REWARD, {});

    return result;
  }

  Future<bool> showRewarded([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result =
        await methodChannel.invokeMethod(Constants.METHOD_SHOW_REWARD, {});

    return result;
  }

  Future<bool> loadOfferWall([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result =
        await methodChannel.invokeMethod(Constants.METHOD_LOAD_OFFERSWALL, {});

    return result;
  }

  Future<bool> showOfferWall([FlutterIronSourceListener? listener]) async {
    _listener = listener;
    var result =
        await methodChannel.invokeMethod(Constants.METHOD_SHOW_OFFERSWALL, {});

    return result;
  }

  static FlutterIronSource get instance => _instance ??= FlutterIronSource();
}
