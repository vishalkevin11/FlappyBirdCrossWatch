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
    
    
    var callToPhoneCompleted : Bool = false
    
    var counter = 0
    
    
    var motionMgr : CMMotionManager = CMMotionManager()
     var motionQueue : NSOperationQueue = NSOperationQueue()
    
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
       self.initializeMotionManager()
    }
    
    override func willActivate() {
        super.willActivate()
        
       
        self.motionUpdates()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK: Core Motion
    
    func initializeMotionManager() -> Void {
        
      // self.playSound()
        
       // self.motionQueue =
        var tmpMotionMgr =  CMMotionManager()
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
        
       // self.statusLabel.setText(status)
    }
    
    
    
    
    func updsteCounter() -> Void {
        self.counter = self.counter + 1
        self.sendvalueToPhone("\(self.counter)")
    }
    
    
    func  motionUpdates() -> Void {
        
        let queue = NSOperationQueue.mainQueue()
        
        let watchUtly : WatchUtility = WatchUtility.init()
        
        
        
        
//        manager.startDeviceMotionUpdatesToQueue(queue) {
//            [weak self] (data: CMDeviceMotion?, error: NSError?) in
//            
//            // motion processing here
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock {
//                // update UI here
//            }
//        }
//        
    
        self.motionMgr.accelerometerUpdateInterval = 0.01
        
        
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
                    let returnval =  watchUtly.getSpikeForAccelerometerValues(acceleration.x, yValue: acceleration.y, zValue: acceleration.z)
                    if returnval {
                   self?.sendPingToPhone(returnval)
                    }
                    else {
                        var defaults = NSUserDefaults(suiteName: "group.com.tuffytiffany.flappybird")
                        defaults?.synchronize()
                        
                        // Check for null value before setting
                        if let restoredValue : Bool = defaults!.boolForKey("isPeakNotified") {
                            self?.ystatusLabel.setText("value is\(restoredValue)")
                        }
                    }
//                    if (fabs(acceleration.z) > 0.6 && fabs(acceleration.z) < 0.7) {
//                     self!.sendvalueToPhone("\(acceleration.x)")
//                    }
                                }
                //self!.sendvalueToPhone("x \(String(format: "%.1f", acceleration.x)) y \(String(format: "%.1f", acceleration.y)) Z \(String(format: "%.1f", acceleration.z))")
               
                
            }
        }
 
      //  self.motionMgr.deviceMotionUpdateInterval = 0.03; // update every 30ms

//        if  self.motionMgr.deviceMotionAvailable {
//             self.motionMgr.deviceMotionUpdateInterval = 0.01
//            self.motionMgr.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data: CMDeviceMotion?, error: NSError?) in
//        
//                    if let gravity = data?.gravity {
//                        let rotation = atan2(gravity.x, gravity.y) - M_PI
//                         NSOperationQueue.mainQueue().addOperationWithBlock {
//                        self.sendvalueToPhone("x \(String(format: "%.1f", gravity.x)) y \(String(gravity: "%.1f", gravity.y)) Z \(String(gravity: "%.1f", gravity.z))")
//                        }
//                       // self?.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
//                    }
//                })
//            }
        
        
        /*
         if manager.deviceMotionAvailable {
         manager.deviceMotionUpdateInterval = 0.01
         manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
         [weak self] (data: CMDeviceMotion?, error: NSError?) {
         if let gravity = data?.gravity {
         let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
         self?.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
         }
         }
         }
 
 */
    }
    
    
    
    
    
    func sendPingToPhone(returnval : Bool) -> Void {
       dispatch_async(dispatch_get_main_queue()) {
        
        if (returnval) {
            //print("fly high")
            
            self.callToPhoneCompleted = false
            
            self.zstatusLabel.setText("\(NSDate().timeIntervalSince1970)");
            
          //  // self?.playSound()
            self.sendvalueToPhone("fly high \(NSDate().timeIntervalSince1970)")
        }
        else {
            self.zstatusLabel.setText("");
            // self!.sendvalueToPhone("\(acceleration.x)")
        }
        }
    }
    
    
    func timerBoolReset() -> Void {
//        if self.callToPhoneCompleted {
//            self.callToPhoneCompleted = false
//        }
//        else {
            self.callToPhoneCompleted  = true
//        dispatch_async(dispatch_get_main_queue()) {
//        self.sendvalueToPhone("fly high \(NSDate().timeIntervalSince1970)")
    //    }
       // }
    }
    
    func playSound() -> Void {
        
        let path = NSBundle.mainBundle().pathForResource("censor_beep", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        let asset : WKAudioFileAsset = WKAudioFileAsset.init(URL: fileURL)
        let playerItem : WKAudioFilePlayerItem = WKAudioFilePlayerItem.init(asset: asset)
        let audioFilePlayer : WKAudioFilePlayer = WKAudioFilePlayer.init(playerItem: playerItem)
        audioFilePlayer.play()
    }
    
    
    
    @IBAction func watchShookJustNow() {
        print("ppppp")
       // var tmeeee = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:#selector(InterfaceController.updsteCounter), userInfo: nil, repeats: true)
         self.callToPhoneCompleted  = true
         //NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector:#selector(InterfaceController.timerBoolReset), userInfo: nil, repeats: true)
        //sendvalueToPhone("dog")
      //  self.updsteCounter()
    }
    
    func sendvalueToPhone(emoji: String){
        /* dispatch_async(dispatch_get_main_queue()) {
         
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
         }*/
        
        
        
        
        // The paired iPhone has to be connected via Bluetooth.
        dispatch_async(dispatch_get_main_queue()) {
            
       //     NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isPeakNotified")
            
            
            
            
            if let validSession = self.session {
                //let iPhoneAppContext = ["switchStatus": sender.on]
                let applicationData = ["message_value" : emoji]
                var defaults = NSUserDefaults(suiteName: "group.com.tuffytiffany.flappybird")
                
                defaults?.setBool(false, forKey: "isPeakNotified")
                defaults?.synchronize()
                do {
                    try validSession.updateApplicationContext(applicationData)
                } catch {
                    print("Something went wrong")
                }
            }
        }
        
    }
    
}
