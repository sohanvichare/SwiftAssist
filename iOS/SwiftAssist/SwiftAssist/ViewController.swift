//
//  ViewController.swift
//  SwiftAssist
//
//  Created by Sohan Vichare on 1/30/16.
//  Copyright © 2016 Sohan Vichare. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    @IBOutlet weak var uname: UITextField!
    
    @IBOutlet weak var pswd: UITextField!
    
    
    let ref = Firebase(url: "https://swiftassist.firebaseio.com")
    let emerRef = Firebase(url: "https://swiftassist.firebaseio.com/emergency")
    
    var bl = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endBackgroundTask();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        if ref.authData != nil {
            self.performSegueWithIdentifier("toMain", sender: self)
        } else {
            // No user is signed in
        }
        
        let us = defaults.stringForKey("username")
        let pd = defaults.stringForKey("password")
        if (us != nil)
        {
            let name = us! + "@account.com"
            ref.authUser(name, password: pd!,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        // There was an error logging in to this account
                    } else {
                        // We are now logged in
                        self.performSegueWithIdentifier("toMain", sender: self)
                    }
            })
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: false)
        
       

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func update()
    {
        self.bl = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


    
    @IBAction func loginBtn(sender: AnyObject) {
        if (self.uname.text != nil && self.pswd.text != nil)
        {
            let ref = Firebase(url: "https://swiftassist.firebaseio.com")
            let name = self.uname.text! + "@account.com";
            ref.authUser(name, password: self.pswd.text!,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        // There was an error logging in to this account
                    } else {
                        self.defaults.setObject(self.uname.text!, forKey: "username")
                        self.defaults.setObject(self.pswd.text!, forKey: "password")
                        self.performSegueWithIdentifier("toMain", sender: self);
                    }
            })
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    

    
}

