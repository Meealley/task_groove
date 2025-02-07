// import UIKit
// import Flutter
// import Firebase
// import UserNotifications

// @main
// @objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         // Configure Firebase
//         FirebaseApp.configure()

//         // Set the UNUserNotificationCenter delegate if iOS 10 or above
//         if #available(iOS 10.0, *) {
//             UNUserNotificationCenter.current().delegate = self
//         }

//         // Request notification permission
//         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//         UNUserNotificationCenter.current().requestAuthorization(
//             options: authOptions,
//             completionHandler: { granted, error in
//                 if let error = error {
//                     print("Error requesting notification permission: \(error.localizedDescription)")
//                 }
//                 if granted {
//                     print("Notification permission granted.")
//                 } else {
//                     print("Notification permission denied.")
//                 }
//             }
//         )
        
//         // Register for remote notifications
//         application.registerForRemoteNotifications()

//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }

//     // Handle the notification when the app is in the foreground
//     func userNotificationCenter(
//         _ center: UNUserNotificationCenter,
//         willPresent notification: UNNotification,
//         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//     ) {
//         // Show alert, sound, or badge when the app is in the foreground
//         completionHandler([.alert, .badge, .sound])
//     }

//     // Handle the action when a notification is clicked in the background or terminated state
//     func userNotificationCenter(
//         _ center: UNUserNotificationCenter,
//         didReceive response: UNNotificationResponse,
//         withCompletionHandler completionHandler: @escaping () -> Void
//     ) {
//         // Handle notification click and route to specific part of the app
//         completionHandler()
//     }
// }



import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        application.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
