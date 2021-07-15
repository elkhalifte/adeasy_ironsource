import Flutter
import UIKit




public class SwiftFlutterIronsourcePlugin: NSObject, FlutterPlugin {
  
 
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_ironsource", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterIronsourcePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
    
}
