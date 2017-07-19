//
//  FeedData.swift
//  pontiyak
//
//  Created by Stephen Mercer on 19/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class Event: NSObject, NSCoding{
    
    //MARK: Properties
    var title:String
    var location:String
    var vendor:String
    var latlong:[Float]
    var backgroundImage:UIImage
    
    //MARK: Types
    struct keys{
        static let title = "title"
        static let location = "location"
        static let vendor = "vendor"
        static let backgroundImage = "backgroundImage"
        static let latlong = "latlong"
    }
    
    //MARK: Intialise
    init? (title:String, location:String,vendor:String, latlong:[Float],backgroundImage:UIImage){
        //No value is allowed to be empty
        guard !title.isEmpty else{
            return nil
        }
        guard !location.isEmpty else{
            return nil
        }
        guard !vendor.isEmpty else{
            return nil
        }
        guard !latlong.isEmpty else{
            return nil
        }
        
        //Intialise Stored Properties
        self.title = title
        self.location = location
        self.vendor = vendor
        self.backgroundImage = backgroundImage
        self.latlong = latlong
    }
    
    //MARK: NSCoding
    func encode (with aCoder:NSCoder){
        aCoder.encode(title, forKey: keys.title)
        aCoder.encode(location, forKey: keys.location)
        aCoder.encode(vendor, forKey: keys.vendor)
        aCoder.encode(backgroundImage, forKey: keys.backgroundImage)
        aCoder.encode(latlong, forKey: keys.latlong)
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        //Everything is required
        guard let title = aDecoder.decodeObject(forKey: keys.title) as? String
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the title for a Event Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        guard let location = aDecoder.decodeObject(forKey: keys.location) as? String
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the location for a Event Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        guard let vendor = aDecoder.decodeObject(forKey: keys.vendor) as? String
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the vendor for a Event Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        guard let backgroundImage = aDecoder.decodeObject(forKey: keys.backgroundImage) as? UIImage
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the backgroundImage for a Event Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        guard let latlong = aDecoder.decodeObject(forKey: keys.latlong) as? [Float]
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the latlong for a Event Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        
        //Must call desginated initaliser
        self.init(title:title,location:location, vendor:vendor, latlong:latlong,backgroundImage:backgroundImage)
    }
    
    //Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("event")
}
