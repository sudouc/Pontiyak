//
//  TabViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 23/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class TabViewController: UITabBarController {
    
    var events = [Event]()
    var eventsDict: [Int: Event] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork(){
            events = getEventsOnline()!
        }
        
        addNewEvents(localEvents:getSavedEvents()!,onlineEvents:events)
        
        saveEventstoLocal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: Private Functions
    private func getEventsOnline() -> [Event]?{
        //Add API fucntions here
        
        return nil
    }
    
    private func getSavedEvents() -> [Event]?{
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: Event.ArchiveURL.path) as? [Event]
    }
    
    private func saveEventstoLocal(){
        let isSaveSuccessful = NSKeyedArchiver.archiveRootObject(events, toFile: Event.ArchiveURL.path)
        
        if isSaveSuccessful{
            if #available(iOS 10.0, *) {
                os_log("Events successfully saved.",log:.default,type:.debug)
            } else {
                // Fallback on earlier versions
            }
        }else{
            if #available(iOS 10.0, *) {
                os_log("Events could not be saved.",log:.default,type:.error)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func loadSampleEvents(){ //Create sample events for testing
        let sampleImage1 = #imageLiteral(resourceName: "ucArt")
        let sampleImage2 = #imageLiteral(resourceName: "ucPark")
        let sampleImage3 = #imageLiteral(resourceName: "ucInspire")
        let sampleImage4 = #imageLiteral(resourceName: "ucUCLodge")
        
        guard let event1 = Event(eventID: 0, title: "Art Expo", location: "Refractory", vendor: "UC Art UG", latlong: [-35.2385,149.0844], backgroundImage: sampleImage1, date: Date())
            else{
                fatalError("Unable to instantiate event1")
        }
        
        guard let event2 = Event(eventID:1,title: "Study Sesh", location: "UC Concourse", vendor: "UC Life!", latlong: [-35.2375,149.0839], backgroundImage: sampleImage2, date: Date())
            else{
                fatalError("Unable to instantiate event2")
        }
        guard let event3 = Event(eventID:2,title: "Inspriation Function", location: "Inspire Center", vendor: "ESTEM", latlong: [-35.2382,149.0822], backgroundImage: sampleImage3, date: Date())
            else{
                fatalError("Unable to instantiate event3")
        }
        guard let event4 = Event(eventID:3,title: "Movie Night", location: "UC Lodge", vendor: "UniLodge", latlong: [-35.2379,149.0828], backgroundImage: sampleImage4, date: Date())
            else{
                fatalError("Unable to instantiate event4")
        }
        
        events += [event1,event2,event3,event4]
    }
    
    private func addNewEvents(localEvents:[Event],onlineEvents:[Event]){
        //Checks for new events and cancels any duplicates
        for each in localEvents{
            eventsDict[each.eventID] = each
        }
        
        for each in onlineEvents{
            eventsDict[each.eventID] = each
        }
        
    }
}
