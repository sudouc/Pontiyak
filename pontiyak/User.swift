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
    var photo: UIImage?
    
    //MARK: Types
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
    }
    
    //MARK: Initalise
    init? (name:String, photo:UIImage){
        //Name must not be empty
        guard !name.isEmpty else{
            return nil
        }
        
        
        //Initalise Stored Properties
        self.name = name
        self.photo = photo
    }
    
    //MARK: NSCoding
    func encode (with aCoder:NSCoder){
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
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
        
        //Because photo is optional
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage

        
        //Must call designated initalizer.
        self.init(name:name,photo:photo!)
    }
    
    //Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
}
