//
//  SharedData.swift
//  pontiyak
//
//  Created by Stephen Mercer on 25/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import Foundation

class SharedData{
    static var sharedEvents = [Event]()
    
    class func getEventsOnline(){
        let url = URL(string: "https://api.sudo.org.au/api/pontiyak/events/")!
        let request = URLRequest(url: url)
        var eventList = [Event]()
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                var tempList = [Event]()
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
                    
                    let sDate: String = ((jsonEvent as AnyObject).value(forKey:"start_time") as! String)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let tdate = dateFormatter.date(from:sDate)
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour], from: tdate!)
                    let date = calendar.date(from:components)!
                    
                    
                    
                    let aevent = Event(eventID: eventID!, title: title, location: location, vendor: "Test", latlong: latlong, backgroundImage: #imageLiteral(resourceName: "ucPark"), date: date)
                    
                    tempList.append(aevent!)
                }
                eventList.append(contentsOf: tempList)
            } catch let error as NSError {
                print(error)
            }

        }).resume()

        repeat{
        SharedData.sharedEvents = eventList
        }while(eventList.isEmpty)
        
    }

}

