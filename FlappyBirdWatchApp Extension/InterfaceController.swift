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
    
    
//    @IBOutlet var xstatusLabel: WKInterfaceLabel!
//    @IBOutlet var ystatusLabel: WKInterfaceLabel!
//    @IBOutlet var zstatusLabel: WKInterfaceLabel!
    
    
    @IBOutlet var btnStart: WKInterfaceButton!
    @IBOutlet var btnPlayAgain: WKInterfaceButton!
    @IBOutlet var labelStartWave: WKInterfaceLabel!
    var strtext : String = ""
    
    var isPeekValueReached : Bool = false
    
    var counter : Int = 0
    
    
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
        
        self.labelStartWave.setHidden(true)
        self.btnPlayAgain.setHidden(true)
        self.btnStart.setHidden(false)
        
        //self.motionUpdates()
        
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func PlayAgain() {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.sendvalueToPhone("playagain")
        }
    }
    
    @IBAction func startTheGame() {
        
        self.labelStartWave.setHidden(false)
        self.btnPlayAgain.setHidden(false)
        self.btnStart.setHidden(true)
        
        session?.delegate = self
        session?.activateSession()
        self.initializeMotionManager()
        self.motionUpdates()
        
        // will show startwaving
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
        
        
        self.motionMgr.accelerometerUpdateInterval = 0.03
        
        
        
        self.motionMgr.startAccelerometerUpdatesToQueue(queue) {
            [weak self] (data: CMAccelerometerData?, error: NSError?) in
            if let acceleration = data?.acceleration {
                let value : Double = watchUtly.getSpikeForAccelerometerValues(acceleration.x, yValue: acceleration.y, zValue: acceleration.z)
                
                if (value>0.3) {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self?.counter = (self?.counter)! + 1
                        if (self?.counter == 1) {
                            self!.strtext = "NOT \(value)"
                         //   self!.zstatusLabel.setText(self?.strtext)
                            self?.sendPingToPhone()
                            self?.performSelector(#selector(InterfaceController.resetTheCounter), withObject: nil, afterDelay: 0.8)
                        }
                    }
                }
            }
        }
    }
    
    
    func  resetTheCounter() -> Void {
        self.counter = 0
    }
    
    
    func sendPingToPhone() -> Void {
        // dispatch_async(dispatch_get_main_queue()) {
        //  let date = NSDate().timeIntervalSince1970
        //  self.zstatusLabel.setText("\(date)");
        self.sendvalueToPhone("jump")
        // }
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
        
    }
    
    // MARK: Timer Init / ping the Phone
    
    func startThePingMoniterTimer() -> Void {
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(InterfaceController.moniterPeakValuesAndPing), userInfo: nil, repeats: true)
    }
    
    func moniterPeakValuesAndPing() -> Void {
        
        objc_sync_enter(self)
        if  (self.isPeekValueReached == true){
            //send the ping
            self.isPeekValueReached = false
            self.sendPingToPhone()
        }
        self.isPeekValueReached = false
        
        objc_sync_exit(self)
        
        
        //else {
        //dont ping but reset the timer flag
        
        // }
    }
    
    // MARK: Button Actions
    
    @IBAction func initializeTimerAndDefaults() {
        
        session?.delegate = self
        session?.activateSession()
        self.initializeMotionManager()
        self.motionUpdates()
        //self.startThePingMoniterTimer()
    }
    
}
