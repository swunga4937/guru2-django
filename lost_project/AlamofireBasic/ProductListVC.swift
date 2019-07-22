//
//  ProductListVC.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 16/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit
import Alamofire

class ProductListVC:UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var product_list:[Product] = []
    var product_place = 0
    
    func showPlusBtn(){
        if navigationItem.rightBarButtonItems == nil || navigationItem.rightBarButtonItems?.count == 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(changeToWrite))
        }
    }
    
    @objc func changeToWrite(){
        let storyBoard = self.storyboard!
        let writeViewController = storyBoard.instantiateViewController(withIdentifier: "write") as! writeVC
        // writeViewController.delegate = self
        //present(writeViewController, animated: true)
        self.navigationController?.pushViewController(writeViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.title = UIImage(named: "basic")
        
        self.getProductData()
        showPlusBtn()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(getProductData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func getProductData() {
        if product_place == 0 {
            printTable()
        } else {
            printSelectedTable(id: product_place)
        }
    }
    
    // 전체 게시판 출력
    func printTable() {
        self.tableView.refreshControl?.beginRefreshing()
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization":"Token \(token)",
            "Accept":"application/json"
        ]
        
        let url = "http://127.0.0.1:8000/lost/product/"
        
        Alamofire.request(url, method: .get, headers: headers).responseData{
            response in
            switch response.result{
            case .failure:
                print("분실물 목록 조회 오류")
            case .success:
                print("목록 조회 성공")
                
                guard let data = response.result.value else {
                    return
                }
                let decorder = JSONDecoder()
                do {
                    self.product_list = try decorder.decode([Product].self, from: data)
                    self.tableView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // 특정 게시판 출력
    // id 값을 받아서 출력
    func printSelectedTable(id:Int) {
        self.tableView.refreshControl?.beginRefreshing()
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization":"Token \(token)",
            "Accept":"application/json"
        ]
        print(token)
        let url = "http://127.0.0.1:8000/lost/product/?search=\(id)"
        
        Alamofire.request(url, method: .get, headers: headers).responseData{
            response in
            switch response.result{
            case .failure:
                print("분실물 목록 조회 오류")
            case .success:
                print("목록 조회 성공")
                
                guard let data = response.result.value else {
                    return
                }
                
                let decorder = JSONDecoder()
                
                do {
                    print(String(data:data, encoding: .utf8))
                    self.product_list = try decorder.decode([Product].self, from: data)
                    
                    self.tableView.reloadData()
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for :indexPath) as! ProductCell
        let row = indexPath.row
        
        if self.product_list[row].type == 1 {
            cell.lostFind.text = "--"
            
        }
        else if self.product_list[row].type == 2 {
            cell.lostFind.text = "분실"
        } else{
            cell.lostFind.text = "습득"
        }
        
        cell.product_title.text = self.product_list[row].title
        
        if self.product_list[row].active {
            
        } else {
            cell.findNotFind.image = nil
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductDetailVC, let index = tableView.indexPathForSelectedRow?.row{
            destination.product_id = self.product_list[index].id
        }
    }
}
