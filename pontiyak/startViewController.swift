//
//  startViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 22/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
class startViewController: UIViewController {
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        
        checkUser()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "skipSegue":
            let vc = storyboard?.instantiateViewController(withIdentifier: "defaultView")
            self.present(vc!, animated: false, completion: nil)
            break
        case "startSegue":
            let vc = storyboard?.instantiateViewController(withIdentifier:"startView")
            self.present(vc!, animated: false, completion: nil)
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Functions
    private func getUser()->Bool{
        user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        if user == nil{
            return false
        } else{
            return true
        }
    }
    private func getOnlineUser() -> Bool{
        //TODO Add code to check user from API
        return true
    }
    
    private func checkUser(){
        if getUser(){
            self.performSegue( withIdentifier: "skipSegue", sender: self)
        } else{
            if Reachability.isConnectedToNetwork(){
                if getOnlineUser(){
                    self.performSegue( withIdentifier: "skipSegue", sender: self)
                }else{
                    self.performSegue(withIdentifier: "startSegue", sender: self)
                }
            }
            else{
                alert(message: "Internet connection is required on first run.", title: "No Internet Connection Detected")
            }
        }
    }
    
    private func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default){(_) in
            self.checkUser()
        }
        let cancelAction = UIAlertAction(title: "Quit", style: .default) { (_) in
            exit(0)
        }
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
