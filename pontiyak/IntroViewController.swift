//
//  IntroViewController.swift
//  pontiyak
//
//  Created by Stephen Mercer on 15/7/17.
//  Copyright © 2017 Sudo. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginButton(_ sender: Any) {
        let photoCapture = UIImagePickerController()
        
        photoCapture.sourceType = .camera
        photoCapture.cameraCaptureMode = .photo
        photoCapture.cameraDevice = .front
        
        photoCapture.delegate = self
        present(photoCapture, animated: true,completion: nil)
        


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
