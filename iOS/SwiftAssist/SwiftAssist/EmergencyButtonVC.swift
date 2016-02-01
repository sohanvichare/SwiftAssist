//
//  EmergencyButtonVC.swift
//  SwiftAssist
//
//  Created by Sohan Vichare on 1/30/16.
//  Copyright © 2016 Sohan Vichare. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class EmergencyButtonVC: UIViewController, CLLocationManagerDelegate {
    
    var currCenter: CLLocationCoordinate2D?;
    
    var goLoc: CLLocationCoordinate2D?;
    
    @IBOutlet weak var cpr: UISegmentedControl!
    
    @IBOutlet weak var doctor: UISegmentedControl!
    
    @IBOutlet weak var epipen: UISegmentedControl!
    
    @IBOutlet weak var inhaler: UISegmentedControl!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var locationManager: CLLocationManager!
    let ref = Firebase(url: "HIDDEN_FOR_SECURITY")
    let emerRef = Firebase(url: "HIDDEN_FOR_SECURITY")
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    var bl = false;
    
    @IBOutlet weak var mapView: MKMapView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        endBackgroundTask()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: false)
        
        emerRef.observeEventType(FEventType.ChildAdded, withBlock: { snapshot in
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Respond"
            let type = snapshot.value.objectForKey("type")
            if (type != nil)
            {
                let bodyText = "IMPORTANT: There is somebody in imminent danger in the area with an emergency of type " + (type! as! String)
                print(bodyText)
                localNotification.alertBody = bodyText
                localNotification.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(0))
                if self.bl {
                    let lat = snapshot.value.objectForKey("lat") as! Double
                    let long = snapshot.value.objectForKey("lon") as! Double
                    let emergencyLoc = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                    let emLoc = CLLocation(latitude: emergencyLoc.latitude, longitude: emergencyLoc.longitude)
                    let l = CLLocation(latitude: self.currCenter!.latitude, longitude: self.currCenter!.longitude)
                    let dist = emLoc.distanceFromLocation(l)
                    if (dist < 8047)
                    {
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        self.goLoc = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                        let alert = UIAlertController(title: "Emergency!", message: "Important: There is somebody in your area in imminent danger with emergency of type " + (type as! String), preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Respond", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.performSegueWithIdentifier("toSave", sender: self);
}))
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                            switch action.style{
                            case .Default:
                              print("def")
                            default:
                                print("def");
                            }
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                print("object is nil")
            }
        })
        registerBackgroundTask();
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true;
        // Do any additional setup after loading the view.
    }
    
    
    func next() {
        self.performSegueWithIdentifier("toSave", sender: self)
    }
    
    func willEnterForeground(notification: NSNotification!) {
        self.performSegueWithIdentifier("toSave", sender: self)
        print(currCenter!.latitude)
    }
    
    func update() {
        bl = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        currCenter = center;
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func logout(sender: AnyObject) {
        defaults.setObject("", forKey: "username")
        defaults.setObject("", forKey: "password")
        ref.unauth()
        self.performSegueWithIdentifier("back", sender: self)
    }
    
    
    @IBAction func helo(sender: AnyObject) {
        var str = "general";
        
        if (self.epipen.selectedSegmentIndex == 1)
        {
            str = "epipen";
        }
        
        if (self.doctor.selectedSegmentIndex == 1)
        {
            str = "allergy";
        }
        
        if (self.inhaler.selectedSegmentIndex == 1)
        {
            str = "inhaler";
        }
        
        if (self.cpr.selectedSegmentIndex == 1)
        {
            str = "CPR";
        }
        
        let emerData = ["lat":currCenter!.latitude, "lon":currCenter!.longitude, "type": str];
        
        emerRef.childByAutoId().setValue(emerData);
        
        let alert = UIAlertController(title: "Help is on the way!", message: "People in your area have been notified. You will be told when somebody responds. Remeber to also call 911, this is a backup measure.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("def")
            default:
                print("def");
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: nil, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController2 = segue.destinationViewController as? SaveVC {
            viewController2.goLoc = self.goLoc
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
