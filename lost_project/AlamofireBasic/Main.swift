//
//  Main.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 22/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit

class Main: UIViewController{
    override func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.showFullView()
        }
    }
    
    
    func showFullView() {
        let storyBoard = self.storyboard!
        let signUp = storyBoard.instantiateViewController(withIdentifier: "login") as! ViewController
        // writeViewController.delegate = self
        //present(writeViewController, animated: true)
        self.navigationController?.pushViewController(signUp, animated: true)
    }
}
