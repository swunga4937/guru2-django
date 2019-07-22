//
//  SignupVC.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 11/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit
import Alamofire

class SignupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var id_field: UITextField!
    @IBOutlet weak var pwd_field: UITextField!
    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var profile_image: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func selectProfileImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.dismiss(animated: true)
        self.profile_image.image = image
    }
    
    @IBAction func doSignup(_ sender: Any) {
        guard let username = self.id_field.text, let id_data:Data = username.data(using: .utf8) else {
            return
        }
        
        guard let password = self.pwd_field.text, let pwd_data:Data = password.data(using: .utf8) else {
            return
        }
        
        guard let email = self.email_field.text, let email_data:Data = email.data(using: .utf8) else{
            return
        }
        
        guard let profile_data:Data = self.profile_image.image!.jpegData(compressionQuality: 1) else{
            return
        }
        
        Alamofire.upload(multipartFormData: {
            (MultipartFormData) in
            MultipartFormData.append(id_data, withName: "username")
            MultipartFormData.append(pwd_data, withName: "password")
            MultipartFormData.append(email_data, withName: "email")
            MultipartFormData.append(profile_data, withName: "profile", fileName: "\(username)_profile.jpeg", mimeType: "image/jpeg")
        }, to: "http://127.0.0.1:8000/accounts/signup/", encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
        let storyBoard = self.storyboard!
        let signUp = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
        // writeViewController.delegate = self
        //present(writeViewController, animated: true)
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.id_field.resignFirstResponder()
        self.pwd_field.resignFirstResponder()
        self.email_field.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}
