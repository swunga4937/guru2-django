//
//  ViewController.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 11/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
// python 에서 서버와의 통신을 통해 requests를 썼던 것처럼 Swift에서 서버 통신을 위해 Alamofire을 사용한다.
// 두 언어 모두 request라는 기본 모듈이 존재한다.
import Alamofire
class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var id_field: UITextField!
    @IBOutlet weak var pwd_field: UITextField!
    @IBOutlet weak var token_field: UILabel!
    
    var my_info:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token")
            else {
                print("토큰 없음")
                return
        }
        guard let vc =
            self.storyboard?.instantiateViewController(withIdentifier: "mapView") else {
                return
        }
        self.present(vc, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.id_field.resignFirstResponder()
        self.pwd_field.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    


    @IBAction func doLogin(_ sender: Any) {
        if let id = id_field.text, let pwd = pwd_field.text{
            if id != "" && pwd != "" {
                print(id)
                print(pwd)
                self.getToken(id: id, pwd: pwd)
                token_field.text = "Now Login..."
            } else {
                print("null data")
            }
        }
    }
    func getToken(id: String, pwd:String ){
        let parameters:Parameters = [
            "username":id,
            "password":pwd
        ]
        
        let login_url = "http://127.0.0.1:8000/api/get_token/"
        /*
         data = requests.get(url)
         */
        
        
        Alamofire.request(login_url, method:  .post, parameters: parameters).responseData{
            response in
            
            switch response.result {
            case .success:
                print("접속 성공")
                if let data = response.data, let utf8Text = String(data:data, encoding: .utf8){
                    
                    let decoder = JSONDecoder()
                    do {
                        let token_data = try decoder.decode(Token.self, from: data)
                        // id, pwd 일치
                        self.token_field.text = token_data.token
                        self.saveToken(token: token_data.token)
                        
                        guard let vc =
                            self.storyboard?.instantiateViewController(withIdentifier: "mapView") else {
                                return
                        }
                        self.present(vc, animated: false)
                    } catch{
                        // id, pwd 불일치
                        print(error.localizedDescription)
                    }
                }
            case .failure:
                print("접속 실패")
            }
        }
    }
    
    func saveToken(token: String) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(token, forKey: "token")
        userDefault.synchronize()
    }
    
    func getSavedToken() -> String {
        let userDefault = UserDefaults.standard
        if let token = userDefault.string(forKey: "token"){
            return token
        }
        return ""
    }
    
    func getMyInfo() {
        let token = self.getSavedToken()
        if token == ""{
            return
        }
        
     let url = "http://127.0.0.1:8000/accounts/MyInfo/"
        let headers: HTTPHeaders = [
            "Authorization" : "Token \(token)",
            "Accept":"application/json"
        ]
        Alamofire.request(url, method: .get, headers: headers).responseData {
            response in
            switch response.result {
            case .success:
                print("접속 성공")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                    print("Data", utf8Text)
                    
                    let decoder = JSONDecoder()
                    
                    do{
                        self.my_info = try decoder.decode(UserInfo?.self, from: data)
                        print(self.my_info!.id)
                        print(self.my_info!.username)
                        print(self.my_info!.message)
                        print(self.my_info!.profile)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure:
                print("접속 실패")
            }
        }
    }
    
    @IBAction func doGetMyInFo(_ sender: Any) {
        self.getMyInfo()
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

