//
//  DashBoardViewController.swift
//  FlappyBirdCrossWatch
//
//  Created by Kevin Vishal on 9/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import WatchConnectivity

class DashBoardViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var labelTimestamp: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
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
        
        
   
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "ss"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(NSDate())
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.labelTimestamp.text = "\(dateString)"
            if let messageValue = message["message_value"] {
                self.labelMessage.text = "Last message_value: \(messageValue)"
            }
        }
    }
    
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        let message_val = applicationContext["message_value"] as? String
//        let timeStr : String =  "\(NSDate().timeIntervalSince1970)"
//        print("\(timeStr)")
//        //Use this to update the UI instantaneously (otherwise, takes a little while)
//        dispatch_async(dispatch_get_main_queue()) {
//            self.labelTimestamp.text = timeStr
//            if let message = message_val {
//                self.labelMessage.text = "Last message_value: \(message)"
//            }
//        }
//    }

    
}