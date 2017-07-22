//
//  IntroViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 15/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

//TODO Create landing page to determine if user exists

import UIKit

class IntroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    var user:User?
    var userImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if getUser(){
            self.performSegue( withIdentifier: "mainSegue", sender: self)
            
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Camera Functions
    
    @IBAction func getImage(){
        let photoCapture = UIImagePickerController()
        
        photoCapture.sourceType = .camera
        photoCapture.cameraCaptureMode = .photo
        photoCapture.cameraDevice = .front
        photoCapture.allowsEditing = true
        
        photoCapture.delegate = self
        present(photoCapture, animated: true,completion: nil)
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.userImage = selectedImage
        
        
        self.performSegue( withIdentifier: "imagePresent", sender: self)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //super.prepare(for: segue, sender: sender)
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "imagePresent":
            guard let addImage = segue.destination as? ConfirmViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            addImage.photo = self.userImage
            self.navigationController?.pushViewController(addImage, animated: true)
            break
        case "mainSegue":
            
            break
        case "tacs":
            
            break
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //Private Functions
    func getUser()->Bool{
        user = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
        if user == nil{
            return false
        } else{
            return true
        }
    }
    
}
