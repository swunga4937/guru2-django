//
//  lostListVC.swift
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Product List"
        self.getProductData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(getProductData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    
    
    @objc func getProductData() {
        self.tableView.refreshControl?.beginRefreshing()
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        let headers:HTTPHeaders = [
            "Authorization":"Token \(token)",
            "Accept":"application/json"
        ]
        let url = "http://127.0.0.1:8000/shop/product/"
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
                    self.product_list = try decorder.decode([Product].self, from: data)
                    self.tableView.reloadData()
                } catch {
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
        
        cell.product_title.text = self.product_list[row].title
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductDetailVC, let index = tableView.indexPathForSelectedRow?.row{
            destination.product_id = self.product_list[index].id
        }
    }
}
