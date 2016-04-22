//
//  AppDelegate.swift
//  nearbyPOC
//
//  Created by Zack on 3/30/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

var myAPIKey = "AIzaSyDrpWmPjqzVOHZGpX3PC8gB94JTpSqwVCQ"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /**
    * @property
    * This class lets you check the permission state of Nearby for the app on the current device.  If
    * the user has not opted into Nearby, publications and subscriptions will not function.
    */
    var nearbyPermission: GNSPermission!
    
    /**
    * @property
    * The message manager lets you create publications and subscriptions.  They are valid only as long
    * as the manager exists.
    */
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    var navController: UINavigationController!
    var messageViewController: MessageViewController!
    var paymentVc: PaymentViewController!
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        messageViewController = MessageViewController()
        navController = UINavigationController(rootViewController: messageViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        paymentVc = PaymentViewController()
        
        
        // Set up the message view navigation buttons.
        nearbyPermission = GNSPermission(changedHandler: {[unowned self] granted in
            self.messageViewController.leftBarButton =
                UIBarButtonItem(title: String(format: "%@ Nearby", granted ? "Deny" : "Allow"),
                    style: UIBarButtonItemStyle.Bordered, target: self, action: "toggleNearbyPermission")
            })
        setupStartStopButton()
        
        // Enable debug logging to help track down problems.
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        // Create the message manager, which lets you publish messages and subscribe to messages
        // published by nearby devices.
        messageMgr = GNSMessageManager(APIKey: myAPIKey,
            paramsBlock: {(params: GNSMessageManagerParams!) -> Void in
                // This is called when microphone permission is enabled or disabled by the user.
                params.microphonePermissionErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if microphone use is allowed")
                    }
                }
                // This is called when Bluetooth permission is enabled or disabled by the user.
                params.bluetoothPermissionErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if Bluetooth use is allowed")
                    }
                }
                // This is called when Bluetooth is powered on or off by the user.
                params.bluetoothPowerErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if Bluetooth is turned on")
                    }
                }
        })
        
        return true
    }
    
    
    /// Sets up the right bar button to start or stop sharing, depending on current sharing mode.
    func setupStartStopButton() {
        let isSharing = (publication != nil)
        messageViewController.rightBarButton = UIBarButtonItem(title: isSharing ? "Stop" : "Start",
            style: UIBarButtonItemStyle.Bordered,
            target: self, action: isSharing ? "stopSharing" :  "startSharing")
    }
    
    /// Starts sharing with a randomized name.
    func startSharing() {
        var idCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("id")
        var idString: String = idCheck as! String
        
        startSharingWithName(idString)
        setupStartStopButton()
    }
    
    /// Stops publishing/subscribing.
    func stopSharing() {
        publication = nil
        subscription = nil
        messageViewController.title = ""
        setupStartStopButton()
    }
    
    func sendPayMessage(fullMessage: String) {
        if let messMan = self.messageMgr {
            let pubMessage: GNSMessage = GNSMessage(content: fullMessage.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true))
            publication = messMan.publicationWithMessage(pubMessage)
        }
    }
    
    /// Toggles the permission state of Nearby.
    func toggleNearbyPermission() {
        GNSPermission.setGranted(!GNSPermission.isGranted())
    }
    
    /// Starts publishing the specified name and scanning for nearby devices that are publishing
    /// their names.
    func startSharingWithName(name: String) {
        if let messageMgr = self.messageMgr {
            // Show the name in the message view title and set up the Stop button.
            messageViewController.title = name
            
            
            //Set initial message for publication
            let state = "1"
            let content = name
            let devId = UIDevice.currentDevice().identifierForVendor!.UUIDString
            let recId = " "
            let amt = " "
            
            let message = state + "," + content + "," + devId + "," + recId + "," + amt
            
            // Publish the name to nearby devices.
            let pubMessage: GNSMessage = GNSMessage(content: message.dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true))
            publication = messageMgr.publicationWithMessage(pubMessage)
            
            // Subscribe to messages from nearby devices and display them in the message view.
            subscription = messageMgr.subscriptionWithMessageFoundHandler({[unowned self] (message: GNSMessage!) -> Void in
                self.messageViewController.addMessage(String(data: message.content, encoding:NSUTF8StringEncoding)!)
                }, messageLostHandler: {[unowned self](message: GNSMessage!) -> Void in
                    self.messageViewController.removeMessage(String(data: message.content, encoding: NSUTF8StringEncoding))                })
        }
    }
    
    func sendPayment(state: String, content: String, devId: String, recId: String, amt: String){
        if let messageMgr = self.messageMgr {
            
            let state = state
            let content = content
            let devId = devId
            let recId = recId
            let amt = amt
            
            let messageOne = state + "," + content + ","
            let messageTwo = devId + "," + recId + "," + amt
            let fullMessage = messageOne + messageTwo
            
            
            //publish payment message
            let pubMessage: GNSMessage = GNSMessage(content: fullMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))
            publication = messageMgr.publicationWithMessage(pubMessage)
            
        }
    }
}

