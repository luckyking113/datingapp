//
//  AppDelegate.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/22.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var deviceTokenData: Data?
	
	var chatSingleVC: ChatSingleVC?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey("AIzaSyBdkMdD45ZcewVYzS6aLQGpDKYT9pGICZQ")
        
        Parse.enableLocalDatastore()
        let configuration = ParseClientConfiguration {
            $0.applicationId = "my71GX1zVRDk2SrynM5nAcPWI8EQxs6MlRdrTxFM"
            $0.clientKey = "BdBmh6j5tRGYXb3IaQvJsHtp84LPu36LZBDuR4IL"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: configuration)
        
        saveInstallationObject()
		
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay ]) {
			(granted, error) in
			print("Permission granted: \(granted)")
			guard granted else { return }
			self.getNotificationSettings()
		}
        
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.isIdleTimerDisabled = true
        
        /// Check user is already logged in
        checkCurrentUser()
        return true
    }
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		self.deviceTokenData = deviceToken
//		createInstallationOnParse(deviceTokenData: deviceToken)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		if let aps = userInfo["aps"] as? NSDictionary {
			if (self.chatSingleVC != nil) {
				self.chatSingleVC?.reload()
			}
		}
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
	}
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
	
	func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			print("Notification settings: \(settings)")
			guard settings.authorizationStatus == .authorized else { return }
			DispatchQueue.main.async(execute: {
				UIApplication.shared.registerForRemoteNotifications()
			})
		}
	}

	func createInstallationOnParse(deviceTokenData:Data){
		if let installation = PFInstallation.current(){
			installation.setDeviceTokenFrom(deviceTokenData)
			installation.setObject(["News"], forKey: "channels")
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
	
	func configureChannel() {
		if let installation = PFInstallation.current(){
			installation.setDeviceTokenFrom(deviceTokenData)
			installation.setObject([PFUser.current()?.objectId], forKey: "channels")
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

extension AppDelegate {
    
    func saveInstallationObject() {        
        if let installation = PFInstallation.current() {
			installation.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("You have successfully connected your app to Back4App!")
                } else {
                    if let myError = error{
                        print(myError.localizedDescription)
                    }else{
                        print("Uknown error")
                    }
                }
            }
        }
    }
    
    func setRootWithTabVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "CTTabBarVC") as! CTTabBarVC
        
        let navController = UINavigationController(rootViewController: tabbarVC)
        navController.isNavigationBarHidden = true
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func checkCurrentUser() {
        if let user = UserManager.sharedInstance.user {
            Helper.showLoading(target: (self.window?.rootViewController)!)
            UserManager.sharedInstance.loadProfile(user: user) {
                Helper.showLoading(target: (self.window?.rootViewController)!)
                self.setRootWithTabVC()
            }
        }
    }
}

