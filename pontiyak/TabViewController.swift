//
//  TabViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 23/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var events = [Event]()
    var eventsDict: [Int: Event] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if Reachability.isConnectedToNetwork(){
            events = getEventsOnline()!
        }
        loadSampleEvents()
        
        SharedData.sharedEvents = events
        
        
        //        addNewEvents(localEvents: events)
        
        //addEventsToMap()
        
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
        let url = URL(string: "https://api.sudo.org.au/api/pontiyak/events/")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
                for jsonEvent in json!{
                    let eventID:Int? = (jsonEvent as AnyObject).value(forKey:"id") as? Int
                    let title:String = ((jsonEvent as AnyObject).value(forKey:"title") as? String)!
                    let location:String = ((jsonEvent as AnyObject).value(forKey:"location") as? String)!
                    //                    let vendor:String = (jsonEvent as AnyObject).value(forKey:"id") as? String
                    let lat = (jsonEvent as AnyObject).value(forKey:"latitude") as? String
                    let long = (jsonEvent as AnyObject).value(forKey:"longitude") as? String
                    let latlong:[Float] = [Float(lat!)!,Float(long!)!]
                    //                    let backgroundData:Data = ((jsonEvent as AnyObject).value(forKey:"background_image_blob") as? Data)!
                    
                    let sDate: String = ((jsonEvent as AnyObject).value(forKey:"start_time") as? String)!
                    //                    let isoDate = "2016-04-14T10:44:00+0000"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let tdate = dateFormatter.date(from:sDate)!
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour], from: tdate)
                    let date = calendar.date(from:components)!
                    
                    
                    
                    let event = Event(eventID: eventID!, title: title, location: location, vendor: "Test", latlong: latlong, backgroundImage: #imageLiteral(resourceName: "ucPark"), date: date)
                    
                    self.events.append(event!)
                }
                
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        
        
        //        task.resume()
        
        
        
        return []
        
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
    
    private func addNewEvents(localEvents:[Event]){
        //Checks for new events and cancels any duplicates
        let temp = localEvents
        
        for each in temp{
            eventsDict[each.eventID] = each
        }
        
        //        for each in onlineEvents!{
        //            eventsDict[each.eventID] = each
        //        }
        
    }
}
