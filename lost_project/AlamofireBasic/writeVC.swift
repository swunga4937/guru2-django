//
//  writeVC.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 16/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit

import Alamofire
//
//class imageVC:UIImagePickerControllerDelegate {
//    
//}



class writeVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var write_board: UIPickerView!
    @IBOutlet weak var write_title: UITextField!
    @IBOutlet weak var write_product: UITextField!
    @IBOutlet weak var write_date: UITextField!
    @IBOutlet weak var write_text: UITextView!
    @IBOutlet weak var write_FNF: UISegmentedControl!
    @IBOutlet weak var write_image: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlusBtn()
        write_board.delegate = self
        write_board.dataSource = self
    }
    
    @IBAction func image_select(_ sender: Any) {
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
        self.write_image.image = image
    }
    
    var token = ""
    var board_array = ["제1과학관", "제2과학관", "누리관", "50주년기념관", "중앙도서관", "바롬교육관", "인문사회관", "샬롬하우스", "국제생활관", "대강당", "체육관", "조형예술관", "별관", "대학원", "평생교육관", "전문대학원관", "행정관"]
    var board_id = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "15", "16", "17", "18"]
    
    var selected_id:String = ""
    var fnfs:String = ""

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return board_array.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selected_id = board_id[row]
        return board_array[row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let attributes: [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.smallSystemFontSize
//        ]
//
//        return NSAttributedString(string: board_array[row], attributes: attributes)
//    }
//
    
    func showPlusBtn(){
        if navigationItem.rightBarButtonItems == nil || navigationItem.rightBarButtonItems?.count == 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    @objc func save() {
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else{
            print("token 없음")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization" : "Token \(token)",
            "Accept":"application/json"
        ]
        
        
        if write_FNF.selectedSegmentIndex == 0 {
            fnfs = "2"
        } else if write_FNF.selectedSegmentIndex == 1 {
            fnfs = "3"
        }
        
        guard let title = self.write_title.text, let title_data:Data = title.data(using: .utf8) else {
            return
        }

        guard let product = self.write_product.text, let product_data:Data = product.data(using: .utf8) else {
            return
        }

        guard let date = self.write_date.text, let date_data:Data = date.data(using: .utf8) else{
            return
        }
        
        guard let text = self.write_text.text, let text_data:Data = text.data(using: .utf8) else{
            return
        }
        var image_data:Data?
        
        if self.write_image.image != nil {
            image_data = self.write_image.image?.jpegData(compressionQuality: 1)
        }

        Alamofire.upload(multipartFormData: {
            (MultipartFormData) in

            MultipartFormData.append(title_data, withName: "title")
            MultipartFormData.append(product_data, withName: "item")
            MultipartFormData.append(date_data, withName: "whenGet")
            MultipartFormData.append(text_data, withName: "description")
            MultipartFormData.append("\(self.selected_id)".data(using: .utf8)!, withName: "category")
            MultipartFormData.append("\(self.fnfs)".data(using: .utf8)!, withName: "type")
            if image_data != nil {
                MultipartFormData.append(image_data!, withName: "image", fileName: "\(title)_profile.jpeg", mimeType: "image/jpeg")
            }
        }, to: "http://127.0.0.1:8000/lost/product/create/",headers:headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    print(response)
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print("errorafasdfasdfasdf")
                print(encodingError)
            }
        })
        
        
        
        let storyBoard = self.storyboard!
        let ProductLVC = storyBoard.instantiateViewController(withIdentifier: "map") as! map
        // writeViewController.delegate = self
        //present(writeViewController, animated: true)
        self.navigationController?.pushViewController(ProductLVC, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.write_title.resignFirstResponder()
        self.write_product.resignFirstResponder()
        self.write_date.resignFirstResponder()
        self.write_text.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
