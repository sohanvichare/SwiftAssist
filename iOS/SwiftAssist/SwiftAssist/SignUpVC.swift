//
//  SignUpVC.swift
//  SwiftAssist
//
//  Created by Sohan Vichare on 1/30/16.
//  Copyright © 2016 Sohan Vichare. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var ref = Firebase(url:"HIDDEN_FOR_SECURITY")
    
    @IBOutlet weak var uname: UITextField!
    
    @IBOutlet weak var pswd: UITextField!
    
    @IBOutlet weak var epiPen: UISegmentedControl!
    
    @IBOutlet weak var inhaler: UISegmentedControl!
    
    @IBOutlet weak var cpr: UISegmentedControl!
    
    @IBOutlet weak var doctor: UISegmentedControl!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        endBackgroundTask();
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        let name = self.uname.text! + "@account.com"
        ref.createUser(name, password: pswd.text!,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    print("Error creating account");
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    self.ref.authUser(name, password: self.pswd.text!,
                        withCompletionBlock: { error, authData in
                            if error != nil {
                                print("Error 2: creating account");
                            } else {
                                
                                var ePen = false;
                                var doc = false;
                                var inh = false;
                                var cp = false;
                                
                                if (self.epiPen.selectedSegmentIndex == 1)
                                {
                                    ePen = true;
                                }
                                
                                if (self.doctor.selectedSegmentIndex == 1)
                                {
                                     doc = true;
                                }
                                
                                if (self.inhaler.selectedSegmentIndex == 1)
                                {
                                    inh = true;
                                }

                                if (self.cpr.selectedSegmentIndex == 1)
                                {
                                    cp = true;
                                }

                                
                                let userData = ["epipen":ePen, "doctor":doc, "inhaler": inh, "cpr": cp]
                                
                                let usersRef = self.ref.childByAppendingPath("userInfo");
                                
                                
                                usersRef.childByAppendingPath(self.uname.text!).updateChildValues(userData);
                                
                                self.defaults.setObject(self.uname.text!, forKey: "username")
                                self.defaults.setObject(self.pswd.text!, forKey: "password")
                                
                                self.performSegueWithIdentifier("toMain", sender: self);
                                
                                
                                
                            }
                    })
                }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func endBackgroundTask() {
        
        
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }


}
