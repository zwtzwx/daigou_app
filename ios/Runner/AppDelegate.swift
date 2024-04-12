import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
             let controller:FlutterViewController = self.window.rootViewController as! FlutterViewController
             let jumpChannel = FlutterMethodChannel.init(name: "channel:wakeupSchemeJump", binaryMessenger: controller  as! FlutterBinaryMessenger)
             jumpChannel.invokeMethod("wakeupSchemeJump", arguments: url.relativeString)
            return true
        }
}