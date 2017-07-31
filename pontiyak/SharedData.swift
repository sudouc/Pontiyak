//
//  SharedData.swift
//  pontiyak
//
//  Created by Stephen Mercer on 25/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import Foundation
import UIKit

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
                    let vendorArray:[String:Any] = ((jsonEvent as AnyObject).value(forKey:"vendor") as? [String:Any])!
                    let vendor:String = vendorArray["name"]! as! String
                    
                    let lat = (jsonEvent as AnyObject).value(forKey:"latitude") as? String
                    let long = (jsonEvent as AnyObject).value(forKey:"longitude") as? String
                    let latlong:[Float] = [Float(lat!)!,Float(long!)!]
                    
                    var background:UIImage
                    if ((jsonEvent as AnyObject).value(forKey:"background_image_blob")) is NSNull{
                        background = #imageLiteral(resourceName: "ucPark")
                    }else{
                        let backgroundData:Data = ((jsonEvent as AnyObject).value(forKey:"background_image_blob") as? Data)!
                        let decodeData:Data = Data(base64Encoded: backgroundData, options: .ignoreUnknownCharacters)!
                        background = UIImage(data:decodeData)!
                        
                    }
                    
                    let sDate: String = ((jsonEvent as AnyObject).value(forKey:"start_time") as! String)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let tdate = dateFormatter.date(from:sDate)
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .hour], from: tdate!)
                    let date = calendar.date(from:components)!
                    
                    let nowDate = Date()
                    if (date>nowDate){
                        let aevent = Event(eventID: eventID!, title: title, location: location, vendor: vendor, latlong: latlong, backgroundImage: background, date: date)
                        tempList.append(aevent!)
                    }else{
                        print("Event Discarded")
                    }
                }
                if (tempList.isEmpty){
                    exit(0)
                }else{
                eventList.append(contentsOf: tempList)
                }
            } catch let error as NSError {
                print(error)
            }
            
        }).resume()
        
        repeat{
            SharedData.sharedEvents = eventList
        }while(eventList.isEmpty)
        
    }

}

