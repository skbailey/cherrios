//
//  AppDelegate.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/20/20.
//

import UIKit
import CoreLocation

var authToken = ""
var profileID = ""

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        locationManager.delegate = self
        locationManager.distanceFilter = 35
        //locationManager.allowsBackgroundLocationUpdates = true
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("failed to retrieve a location value: `", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      print("new location data available: ", locations)
        
      NotificationCenter.default.post(
        name: NSNotification.Name(rawValue: "locationUpdate"),
        object: locations,
        userInfo: ["locations": locations]
      )
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
      print("location updates are paused")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
      print("resumed location updates")
    }
}
