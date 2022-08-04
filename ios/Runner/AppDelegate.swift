import UIKit
import Flutter
import UserNotifications
import Parse

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     
    GeneratedPluginRegistrant.register(with: self)
      
      let parseConfig = ParseClientConfiguration {
          $0.applicationId = Bundle.main.infoDictionary?["USER_APP_ID"] as! String
            $0.clientKey = Bundle.main.infoDictionary?["USER_CLIENT_KEY"] as! String
            $0.server = Bundle.main.infoDictionary?["USER_SERVER_URL"] as! String
        }
        Parse.initialize(with: parseConfig)

      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      
//      method to get deviceToken
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let batteryChannel = FlutterMethodChannel(name: "com.quellenreiter.quellenreiterApp/deviceToken",
                                                    binaryMessenger: controller.binaryMessenger)
          batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
              guard call.method == "getDeviceToken" else {
                  result(FlutterMethodNotImplemented)
                  return
                }
              result(PFInstallation.current()?.deviceToken)
          })
      //
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay ]) {
               (granted, error) in
               print("Permission granted: \(granted)")
               guard granted else { return }
               self.getNotificationSettings()
           }
      
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func getNotificationSettings() {
         UNUserNotificationCenter.current().getNotificationSettings { (settings) in
             print("Notification settings: \(settings)")
             guard settings.authorizationStatus == .authorized else { return }
             UIApplication.shared.registerForRemoteNotifications()
         }
     }
        
    override func application(_ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         createInstallationOnParse(deviceTokenData: deviceToken)
     }

     override func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register: \(error)")
     }

    func createInstallationOnParse(deviceTokenData:Data){
         if let installation = PFInstallation.current(){
             installation.setDeviceTokenFrom(deviceTokenData)
             installation.saveInBackground {
                 (success: Bool, error: Error?) in
                 if (success) {
                     print("You have successfully saved your push installation to Back4App!")
                 } else {
                     if let myError = error{
                         print("Error saving parse installation \(myError.localizedDescription)")
                     }else{
                         print("Uknown error")
                     }
                 }
             }
         }
     }
}
