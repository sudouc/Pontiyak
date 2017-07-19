//
//  User.swift
//  pontiyak
//
//  Created by Stephen Mercer on 19/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding{
    //MARK: Properties
    var name: String
    var photo: UIImage
    var deviceID: UUID?
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let deviceID = "deviceID"
    }
    
    //MARK: Initalise
    init? (name:String, photo:UIImage, deviceID:UUID){
        //Name must not be empty
        guard !name.isEmpty else{
            return nil
        }
        
        
        //Initalise Stored Properties
        self.name = name
        self.photo = photo
        self.deviceID = deviceID
    }
    
    //MARK: NSCoding
    func encode (with aCoder:NSCoder){
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(deviceID, forKey: PropertyKey.deviceID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decode a name string, the initalizer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else{
                if #available(iOS 10.0, *) {
                    os_log("Unable to decode the name for a User Object.",log:OSLog.default, type:.debug)
                } else {
                    // Fallback on earlier versions
                }
                return nil
        }
        
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let deviceID = aDecoder.decodeObject(forKey: PropertyKey.deviceID) as? UUID

        
        //Must call designated initalizer.
        self.init(name:name, photo:photo!, deviceID:deviceID!)
    }
    
    //Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
}
