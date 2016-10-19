//
//  DashBoardViewController.swift
//  FlappyBirdCrossWatch
//
//  Created by Kevin Vishal on 9/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import WatchConnectivity

class DashBoardViewController: UIViewController, WCSessionDelegate , AsyncClientDelegate {
    
    @IBOutlet weak var labelTimestamp: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    
    var isPreviousCallCompleted : Bool = true
    var client : AsyncClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
     self.performSelector(#selector(DashBoardViewController.connectToTV), withObject: nil, afterDelay: 1.0)
    }
    
    
    func connectToTV() -> Void {
        client = AsyncClient()
        client!.serviceType = "_ClientServer._tcp"
        client!.delegate = self
        client!.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var connectTv: UIButton!
    
    @IBAction func connect(sender: AnyObject) {
        self.connectToTV()
    }
    
    
    @IBAction func sendSignalToTvFromPhone(sender: UIButton) {
       self.sendSignalToTv()
    }
    
    func sendSignalToTv() -> Void {
//        var defaults = NSUserDefaults(suiteName: "com.tuffytiffany.flappybird")
//        
//        defaults?.setBool(false, forKey: "isPeakNotified")
//        defaults?.synchronize()
        
        client!.sendObject("PING To tv through phone")
    }
    
    func client(theClient: AsyncClient!, didFindService service: NSNetService!, moreComing: Bool) -> Bool {
        
        print("didFindService")
       // self.labelTimestamp.text = "didFindService"
        print(service)
        return true
    }
    
    func client(theClient: AsyncClient!, didRemoveService service: NSNetService!) {
        
        print("didRemoveService")
       // self.labelTimestamp.text = "didRemoveService"
        print(theClient)
    }
    
    func client(theClient: AsyncClient!, didConnect connection: AsyncConnection!) {
        
        print("didConnect")
        self.labelTimestamp.text = "TV Connected : YES"
        print(theClient)
    }
    
    func client(theClient: AsyncClient!, didDisconnect connection: AsyncConnection!) {
        print("diddisconnect")
        self.labelTimestamp.text = "TV Connected : NO"
        self.performSelector(#selector(DashBoardViewController.connectToTV), withObject: nil, afterDelay: 0.5)
        print(theClient)
    }
    
    func client(theClient: AsyncClient!, didReceiveCommand command: AsyncCommand, object: AnyObject!, connection: AsyncConnection!) {
        print("didreceivecommand")
       // self.labelTimestamp.text = "didreceivecommand"
        print(command)
    }
    
    func client(theClient: AsyncClient!, didFailWithError error: NSError!) {
        print("didfailwitherror")
      //  self.labelTimestamp.text = "didfailwitherror"
    }
    
    
    // MARK: Watch to phone connection delegates
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureWCSession()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureWCSession()
    }
    
    private func configureWCSession() {
        session?.delegate = self;
        session?.activateSession()
    }
    
    
    // MARK: WCSessionDelegate
    
   func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        
        
   
//        let dayTimePeriodFormatter = NSDateFormatter()
//        dayTimePeriodFormatter.dateFormat = "ss"
//        
//        let dateString = dayTimePeriodFormatter.stringFromDate(NSDate())
        
        
      //  if  isPreviousCallCompleted {
            dispatch_async(dispatch_get_main_queue()) {
                
                if let messageValue : String = message["message_value"] as? String {
                    //self.labelMessage.text = "Last message_value: \(messageValue)"
                    //print(messageValue)
                   // if messageValue == "jump" {
                        self.labelTimestamp.text = "\(messageValue)"
                        self.client!.sendObject(messageValue)
//                    }
//                    else if messageValue == "start" {
//                        
//                        
//                    }
            
                }
        //    }
        }
        
    }

    
    /*
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            
//            if let messageValue : String = message["message_value"] as? String {
//                //self.labelMessage.text = "Last message_value: \(messageValue)"
//                print(messageValue)
            
            
//            var defaults = NSUserDefaults(suiteName: "group.com.tuffytiffany.flappybird")
//            
//            defaults?.setBool(false, forKey: "isPeakNotified")
//            defaults?.synchronize()
//
            
            let message_dict : [String : AnyObject] = applicationContext
            self.labelMessage.text = "\(message_dict["message_value"] as? String)"
                self.client.sendObject(message_dict["message_value"] as? String)
           // }
                }
    }
*/
    
}