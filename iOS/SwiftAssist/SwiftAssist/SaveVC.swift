//
//  SaveVC.swift
//  SwiftAssist
//
//  Created by Sohan Vichare on 1/30/16.
//  Copyright © 2016 Sohan Vichare. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SaveVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var label: UITextView!
    
    
    var goLoc: CLLocationCoordinate2D?
    var currentLoc: CLLocationCoordinate2D?
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true;
        self.mapView.delegate = self;
        
        let dropPin = MKPointAnnotation()
        if (goLoc != nil)
        {
            dropPin.coordinate = goLoc!
            dropPin.title = "Emergency"
            mapView.addAnnotation(dropPin)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var bol = true;
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        currentLoc = center;
    
        if bol {
            let request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLoc!, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: goLoc!, addressDictionary: nil))
            request.requestsAlternateRoutes = false;
            request.transportType = .Automobile
            let directions = MKDirections(request: request)
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    var label = ""
                    for item in route.steps {
                        label = label + "\n\n" + item.instructions
                    }
                    self.label.text = label;
                }
                
            }
        }
        bol = false;
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        
        
        return renderer
    }

    
    @IBAction func openMaps(sender: AnyObject) {
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = goLoc!
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Emergency"
        mapItem.openInMapsWithLaunchOptions(options)
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
