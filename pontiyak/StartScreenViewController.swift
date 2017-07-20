//
//  StartScreenViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 19/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    //TODO Fix error
    // var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if getUser(){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "defaultView")
            self.present(vc!, animated: true, completion: nil)
            
        } else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "welcomeView")
            self.present(vc!, animated: true, completion: nil) //Causes Error
            
            // Do any additional setup after loading the view.
        }
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
    /* private func getUser()->Bool{
        
        let user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        
        if user != nil{
            return true
        }
        else{
            return false
        }
    
    } */

}
