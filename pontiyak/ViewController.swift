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
    
    @IBOutlet weak var map: MKMapView!
    var myLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
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
        
        loadSampleEvents()
        addEventsToMap()
        
        addLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(ViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.map.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        
        
        annot.coordinate = touchMapCoordinate
        annot.title = "Your Pin"
        annot.subtitle = "Tap to edit"
        
        //Adds label to marker
        let pinView = MKAnnotationView.init(annotation: annot, reuseIdentifier: nil)
        pinView.isEnabled = true
        
        self.resetTracking()
        self.map.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    
    func resetTracking(){
        if (map.showsUserLocation){
            map.showsUserLocation = false
            self.map.removeAnnotations(map.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        myLocation = center
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
    static var enable:Bool = true
    @IBAction func getMyLocation(_ sender: UIButton) {
        
    }
    
    //MARK: Private Functions
    private func loadSampleEvents(){ //Create sample events for testing
        let sampleImage1 = #imageLiteral(resourceName: "ucArt")
        let sampleImage2 = #imageLiteral(resourceName: "ucPark")
        let sampleImage3 = #imageLiteral(resourceName: "ucInspire")
        let sampleImage4 = #imageLiteral(resourceName: "ucUCLodge")
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        
        guard let event1 = Event(title: "Art Expo", location: "Refractory", vendor: "UC Art UG", latlong: [-35.2385,149.0844], backgroundImage: sampleImage1, date: Date())
            else{
                fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(title: "Study Sesh", location: "UC Park", vendor: "UC Life!", latlong: [-35.2375,149.0839], backgroundImage: sampleImage2, date: Date())
            else{
                fatalError("Unable to instantiate event2")
        }
        guard let event3 = Event(title: "Inspriation Function", location: "Inspire Center", vendor: "ESTEM", latlong: [-35.2382,149.0822], backgroundImage: sampleImage3, date: Date())
            else{
                fatalError("Unable to instantiate event3")
        }
        guard let event4 = Event(title: "Movie Night", location: "UC Lodge", vendor: "UniLodge", latlong: [-35.2379,149.0828], backgroundImage: sampleImage4, date: Date())
            else{
                fatalError("Unable to instantiate event4")
        }
        
        events += [event1,event2,event3,event4]
    }
    
    private func addEventsToMap(){
        //Map annotation
        for i in events{
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(i.latlong[0]),CLLocationDegrees(i.latlong[1]))
        annotation.title = i.title
        annotation.subtitle = i.location
        map.addAnnotation(annotation)
        }
    }
}



