import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../iron_source_listener.dart';

class ISBannerSize {
  const ISBannerSize({this.width = 320, this.height = 50});

  final int width;
  final int height;

  static const ISBannerSize STANDARD = ISBannerSize(width: 320, height: 50);
  static const ISBannerSize SMALL = ISBannerSize(width: 300, height: 50);
  static const ISBannerSize LARGE = ISBannerSize(width: 320, height: 90);
  static const ISBannerSize MEDIUM_RECTANGLE =
      ISBannerSize(width: 300, height: 250);
}

enum ISBannerSizeType { STANDARD, MEDIUM_ECTANGLE, LARGE }

class ISPluginBannerAd extends StatefulWidget {
  final Key? key;
  final FlutterIronSourceListener? listener;
  final bool keepAlive;
  final ISBannerSize size;
  final String? placement_id;

  ISPluginBannerAd(
      {this.key,
      this.listener,
      this.keepAlive = false,
      this.placement_id,
      required this.size})
      : super(key: key);

  @override
  _IronSourceBannerAdState createState() => _IronSourceBannerAdState();
}

class _IronSourceBannerAdState extends State<ISPluginBannerAd>
    with AutomaticKeepAliveClientMixin {
  late MethodChannel channel;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (Platform.isIOS) {
      return UiKitView(
        key: UniqueKey(),
        viewType: Constants.CHANNEL_BANNER,
        onPlatformViewCreated: _onBannerAdViewCreated,
        creationParams: <String, dynamic>{
          "height": widget.size.height,
          "width": widget.size.width,
          "placement_id": widget.placement_id ?? ""
        },
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        key: UniqueKey(),
        viewType: Constants.CHANNEL_BANNER,
        onPlatformViewCreated: _onBannerAdViewCreated,
        creationParams: <String, dynamic>{
          "height": widget.size.height,
          "width": widget.size.width,
          "placement_id": widget.placement_id ?? ""
        },
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void _onBannerAdViewCreated(int id) async {
    channel = MethodChannel('${Constants.CHANNEL_BANNER}$id');

    channel.setMethodCallHandler((MethodCall call) async {
      var args = call.arguments;

      switch (call.method) {
        case Constants.EVENT_LOAD:
          {
            widget.listener?.onLoad!();
            break;
          }

        case Constants.EVENT_FAIL:
          {
            widget.listener?.onFail!(Exception(args["error"] ?? ""));
            break;
          }

        case Constants.EVENT_CLICK:
          {
            widget.listener?.onClick!();
            break;
          }

        case Constants.EVENT_CLOSE:
          {
            widget.listener?.onClose!();
            break;
          }

        case Constants.EVENT_COMPLETE:
          {
            widget.listener?.onComplete!();
            break;
          }

        default:
          {}
      }
    });
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void dispose() {
    channel.invokeMethod("dispose", {});
  }
}
