//
//  InterfaceController.swift
//  FlappyBirdWatchApp Extension
//
//  Created by Kevin Vishal on 9/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion




class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet var xstatusLabel: WKInterfaceLabel!
    @IBOutlet var ystatusLabel: WKInterfaceLabel!
    @IBOutlet var zstatusLabel: WKInterfaceLabel!
    
    
    var isPeekValueReached : Bool = false
    
    
    
    var motionMgr : CMMotionManager = CMMotionManager()
    var motionQueue : NSOperationQueue = NSOperationQueue()
    
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    // MARK:  Init cycle
    
    override init() {
        super.init()
        
        //        session?.delegate = self
        //        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //self.initializeMotionManager()
    }
    
    override func willActivate() {
        super.willActivate()
        
        
        //self.motionUpdates()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    // MARK: Core Motion Initialization
    
    func initializeMotionManager() -> Void {
        
        let tmpMotionMgr =  CMMotionManager()
        self.motionMgr = tmpMotionMgr
        
        var status  = ""
        
        if self.motionMgr.accelerometerAvailable {
            status = status + "\("A")"
        }
        if self.motionMgr.gyroAvailable {
            status = status + "\("G")"
        }
        if self.motionMgr.magnetometerAvailable {
            status = status + "\("M")"
        }
        if self.motionMgr.deviceMotionAvailable {
            status = status + "\("D")"
        }
        
    }
    
    // MARK: Motion updates
    
    func  motionUpdates() -> Void {
        
        let queue = NSOperationQueue.mainQueue()
        
        let watchUtly : WatchUtility = WatchUtility.init()
        
        
        self.motionMgr.accelerometerUpdateInterval = 0.008
        
        
        self.motionMgr.startAccelerometerUpdates()
        
        self.motionMgr.startAccelerometerUpdatesToQueue(queue) {
            [weak self] (data: CMAccelerometerData?, error: NSError?) in
            if let acceleration = data?.acceleration {
                //                let rotation = atan2(acceleration.x, acceleration.y) - M_PI
                //                self?.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                /// NSOperationQueue.mainQueue().addOperationWithBlock {
                
                dispatch_async(dispatch_get_main_queue()) {
                    //                                    // update UI here
                    //                    self!.xstatusLabel.setText("x \(acceleration.x) y \(acceleration.y) Z \(acceleration.z)")
                    //                    self!.xstatusLabel.setText("x \(acceleration.x) y \(acceleration.y) Z \(acceleration.z)")
                    //                    self!.xstatusLabel.setText("x \(acceleration.x) y \(acceleration.y) Z \(acceleration.z)")
                    //
                    
                    // let valuesStr  = watchUtly.startTrackingMotionValuesForAccelerometerValues(acceleration.x, yValue: acceleration.y, zValue: acceleration.z) as? NSDictionary
                    //
                    //                    self!.sendvalueToPhone("fly high \(valuesStr)")
                    
                    //
                    //                    self!.xstatusLabel.setText("\(valuesStr!["1"]!)")
                    //                    self!.ystatusLabel.setText("\(valuesStr!["2"]!)")
                    //                    self!.zstatusLabel.setText("\(valuesStr!["3"]!)")
                    
                    //
                    self?.isPeekValueReached =  watchUtly.getSpikeForAccelerometerValues(acceleration.y, yValue: acceleration.y, zValue: acceleration.y)
                    //                    if returnval {
                    //                       self?.sendPingToPhone(returnval)
                    //                    }
                    //                    else {
                    //                        var defaults = NSUserDefaults(suiteName: "group.com.tuffytiffany.flappybird")
                    //                        defaults?.synchronize()
                    //
                    //                        // Check for null value before setting
                    //                        if let restoredValue : Bool = defaults!.boolForKey("isPeakNotified") {
                    //                            self?.ystatusLabel.setText("value is\(restoredValue)")
                    //                        }
                    //                    }
                    //                    if (fabs(acceleration.z) > 0.6 && fabs(acceleration.z) < 0.7) {
                    //                     self!.sendvalueToPhone("\(acceleration.x)")
                    //                    }
                }
                //self!.sendvalueToPhone("x \(String(format: "%.1f", acceleration.x)) y \(String(format: "%.1f", acceleration.y)) Z \(String(format: "%.1f", acceleration.z))")
                
                
            }
        }
        
    }
    
    
    func sendPingToPhone() -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.zstatusLabel.setText("\(NSDate().timeIntervalSince1970)");
            self.sendvalueToPhone("fly high \(NSDate().timeIntervalSince1970)")
        }
    }
    
    
    
    
    func sendvalueToPhone(emoji: String){
        dispatch_async(dispatch_get_main_queue()) {
         
         let applicationData = ["message_value" : emoji]
         
         // The paired iPhone has to be connected via Bluetooth.
         if let session = self.session where session.reachable {
         session.sendMessage(applicationData,
         replyHandler: { replyData in
         // handle reply from iPhone app here
         print(replyData)
         }, errorHandler: { error in
         // catch any errors here
         print(error)
         })
         } else {
         // when the iPhone is not connected via Bluetooth
         }
         }
       
        /*
        // The paired iPhone has to be connected via Bluetooth.
        dispatch_async(dispatch_get_main_queue()) {
            
            
            if let validSession = self.session {
                let applicationData = ["message_value" : emoji]
                do {
                    try validSession.updateApplicationContext(applicationData)
                } catch {
                    print("Something went wrong")
                }
            }
        }
 */
        
    }
    
    // MARK: Timer Init / ping the Phone
    
    func startThePingMoniterTimer() -> Void {
        NSTimer.scheduledTimerWithTimeInterval(0.237, target: self, selector: #selector(InterfaceController.moniterPeakValuesAndPing), userInfo: nil, repeats: true)
    }
    
    func moniterPeakValuesAndPing() -> Void {
        if  (self.isPeekValueReached == true){
            //send the ping
            self.sendPingToPhone()
        }
        //else {
        //dont ping but reset the timer flag
        self.isPeekValueReached = false
        // }
    }
    
    // MARK: Button Actions
    
    @IBAction func initializeTimerAndDefaults() {
        
        session?.delegate = self
        session?.activateSession()
        self.initializeMotionManager()
        self.motionUpdates()
        self.startThePingMoniterTimer()
    }
    
}
