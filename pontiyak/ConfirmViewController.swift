//
//  ConfirmViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 16/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit
import os.log

class ConfirmViewController:UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameView: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    var save:UIBarButtonItem?
    var photo:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameView.delegate = self
        
        //Make circular image
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        
        // Do any additional setup after loading the view.
        imageView.image = photo
        
        //Add save button to navigation bar
        let saveButton = UIBarButtonItem.init(
            title:"Save",
            style: .done,
            target:self,
            action:#selector(saveUserData(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.title = "User Details"
        save = saveButton
        updateSaveButtonState()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        save?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    //MARK: UIPickerViewDelegate
    
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
        let photo = imageView.image
        let name = nameView.text ?? ""
    
        saveUser(user: User(name: name, image: photo!)!)
        
        self.performSegue( withIdentifier: "mainSegue", sender: self)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameView.text ?? ""
        save?.isEnabled = !text.isEmpty
    }
    
    private func saveUser(user:User){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: User.ArchiveURL.path)
        
        if isSuccessfulSave{
            if #available(iOS 10.0, *) {
                os_log("User successfully saved.",log:OSLog.default,type:.debug)
            } else {
                // Fallback on earlier versions
            }
        }else{
            if #available(iOS 10.0, *) {
                os_log("Failed to save user...",log:OSLog.default,type:.error)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}
