//
//  User.swift
//  pontiyak
//
//  Created by Stephen Mercer on 19/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding {
    //MARK: Properties
    var name:String
    var image:UIImage
    
    //MARK: Types
    struct keys{
        static let name = "name"
        static let image = "image"
    }
    
    //MARK: Initalise
    init? (name:String, photo:UIImage, deviceID:UUID) {
        //Name must not be empty
        guard !name.isEmpty else{
            return nil
        }
        
        //Initalise Stored Properties
        self.name = name
        self.image = image
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey:keys.name)
        aCoder.encode(image,forKey:keys.image)
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        guard let name = aDecoder.decodeObject(forKey: keys.name) as? String
            else{
                if #available(iOS 10.0, *){
                    os_log("Unable to decode the name for a User Object",log: .default,type:.debug)
                }else{
                    //Fallback to earlier versions
                }
                return nil
        }
        
        guard let image = aDecoder.decodeObject(forKey:keys.image) as? UIImage else {
            if #available(iOS 10.0, *){
                os_log("Unable to decode the image for a User Object",log:.default,type:.debug)
            }else{
                //Fallback to earlier versions
            }
            return nil
        }
        
        self.init(name:name, image:image)
    }
    
    //Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
}
