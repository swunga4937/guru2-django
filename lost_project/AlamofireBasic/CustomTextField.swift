//
//  CustomTextField.swift
//  AlamofireBasic
//
//  Created by swuad_12 on 22/07/2019.
//  Copyright © 2019 swuad_12. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
