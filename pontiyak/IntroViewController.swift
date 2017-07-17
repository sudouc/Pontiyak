//
//  IntroViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 15/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        userImage = selectedImage
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        self.performSegue( withIdentifier: "customImage", sender: self)
        
        // TODO Get this to work
        let vc = ConfirmViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //         Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "customImage"{
            let addImage = segue.destination as! ConfirmViewController
            addImage.userImage = userImage
            
        }
    }
    
}
