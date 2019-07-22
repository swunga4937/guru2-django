//
//  ProductDetailVC.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 16/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ProductDetailVC:UIViewController, UITableViewDataSource, UITextFieldDelegate {
    var product_id:Int = 0
    var product_data:Product!
    
    @IBOutlet weak var user_whenget: UILabel!
    @IBOutlet weak var comment_table: UITableView!
    @IBOutlet weak var user_title: UILabel!
    @IBOutlet weak var user_date: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_item: UILabel!
    @IBOutlet weak var user_text: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    
    @IBOutlet weak var write_comment: UITextField!
    
    var comment_list:[Comment] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProductDetail()
        self.getCommentList(id: product_id)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(tableLoad), for: .valueChanged)
        self.comment_table.refreshControl = refreshControl
    }
    
    @objc func tableLoad() {
        getCommentList(id: product_id)
    }
    
    func getProductDetail() {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        
       let headers:HTTPHeaders = [
            "Authorization":"Token \(token)",
            "Accept":"application/json"
        ]
        
        let url = "http://127.0.0.1:8000/lost/detail/\(product_id)/"
        
        Alamofire.request(url, method: .get, headers: headers).responseData{
            response in
            switch response.result{
            case .failure:
                print("제품 목록 조회 오류")
            case .success:
                print("목록 조회 성공")
                
                guard let data = response.result.value else {
                    return
                }
                
                let decorder = JSONDecoder()
                
                do {
                    self.product_data = try decorder.decode(Product.self, from: data)
                    self.user_item.text = self.product_data.item
                    self.user_title.text = self.product_data.title
                    self.user_date.text = self.product_data.created
                    self.user_name.text = self.product_data.owner.username
                    self.user_whenget.text = self.product_data.whenGet
                    self.user_text.text = self.product_data.description
                    self.user_image.kf.setImage(with: self.product_data.image)
                    self.comment_table.reloadData()
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func getCommentList(id: Int) {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization":"Token \(token)",
            "Accept":"application/json"
        ]
        
        let url = "http://127.0.0.1:8000/lost/comment/?search=\(id)"
        
        Alamofire.request(url, method: .get, headers: headers).responseData{
            response in
            switch response.result{
            case .failure:
                print("댓글 목록 조회 오류")
            case .success:
                print("목록 조회 성공")
                
                guard let data = response.result.value else {
                    return
                }
                
                let decorder = JSONDecoder()
                
                do {
                    self.comment_list = try decorder.decode([Comment].self, from: data)
                    print(self.comment_list)
                    self.comment_table.reloadData()
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            
            self.comment_table.refreshControl?.endRefreshing()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for :indexPath) as! CommentCell
        let row = indexPath.row
        
        cell.comment_user.text = self.comment_list[row].writer.username
        cell.comments.text = self.comment_list[row].text
        
        return cell
    }
    
    @IBAction func save_Comments(_ sender: Any) {
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else{
            print("token 없음")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization" : "Token \(token)",
            "Accept":"application/json"
        ]
        
        guard let text = self.write_comment.text, let text_data:Data = text.data(using: .utf8) else {
            return
        }
        
        Alamofire.upload(multipartFormData: {
            (MultipartFormData) in
            
            MultipartFormData.append(text_data, withName: "text")
            MultipartFormData.append("\(self.product_id)".data(using: .utf8)!, withName: "post")
        }, to: "http://127.0.0.1:8000/lost/comment/create/",headers:headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    print(response.result)
                    print("댓글 남기기 성공")
                    self.getCommentList(id: self.product_id)
                    self.write_comment.text = ""
                }
            case .failure(let encodingError):
                print("errorafasdfasdfasdf")
                print(encodingError)
            }
        })
        
        self.comment_table.refreshControl?.endRefreshing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.write_comment.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

