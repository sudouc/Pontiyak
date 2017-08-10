//
//  MasterViewController.swift
//  pontiyak
//
//  Created by Alex Sinnott on 5/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let uc = CLLocationCoordinate2D(latitude: -35.2379301, longitude: -149.0831383)
    
    var events = [Event]()
    var firsttime = true
    
    @IBOutlet weak var map: MKMapView!
    var myLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .satellite
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsUserLocation = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
        map.centerCoordinate = uc
        
        events = SharedData.sharedEvents
        addEventsToMap()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firsttime = true
        map.removeAnnotations(map.annotations)
        events = SharedData.sharedEvents
        addEventsToMap()
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    @IBAction func centreOnMe(_ sender: Any) {
        firsttime = true
        centerMap((map.userLocation.location?.coordinate)!)
    }
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        myLocation = center
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        if firsttime{
            firsttime = false
        centerMap(locValue)
        }
    }
    
    static var enable:Bool = true
    @IBAction func getMyLocation(_ sender: UIButton) {
        
    }
    
    func addEventsToMap(){
        //Map annotation
        print("Function Run")
        
        for i in events{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(i.latlong[0]),CLLocationDegrees(i.latlong[1]))
            annotation.title = i.title
            annotation.subtitle = i.location
            map.addAnnotation(annotation)
        }
    }
}



