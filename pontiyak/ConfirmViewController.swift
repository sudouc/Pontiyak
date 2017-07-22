//
//  ConfirmViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 16/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit

class ConfirmViewController:UIViewController,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameView: UITextField!
    
    var photo:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageView.image = photo
        
        let saveButton = UIBarButtonItem.init(
            title:"Save",
            style: .done,
            target:self,
            action:#selector(saveUserData(sender:))
        )

        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func rightButtonAction(sender:UIBarButtonItem){
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch (segue.identifier ?? ""){
        case "mainSegue":
            self.navigationController?.isNavigationBarHidden = true
            break
        default:
            break
        }
    }
    
    //MARK: Private Functions
    @objc private func saveUserData(sender:UIBarButtonItem){
        self.performSegue( withIdentifier: "mainSegue", sender: self)
    }
    
    
}
