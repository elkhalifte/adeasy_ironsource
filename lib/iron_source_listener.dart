import 'dart:ui';

class FlutterIronSourceListener {
  dynamic? _data;

  FlutterIronSourceListener(
      {this.onOpen,
      this.onStart,
      this.onLoad,
      this.onReward,
      this.onComplete,
      this.onClick,
      this.onFail,
      this.onClose,
      this.onLeave,
      this.onImpression});
  final void Function(dynamic)? onReward;
  final VoidCallback? onLoad,
      onOpen,
      onClose,
      onComplete,
      onStart,
      onLeave,
      onClick,
      onImpression;
  Function(Exception)? onFail;

  void setData(data) {
    _data = data;
  }

  getData() {
    return _data;
  }

  bool hasData() {
    return _data != null;
  }

  get([String? key]) {
    return _data![key];
  }
}
