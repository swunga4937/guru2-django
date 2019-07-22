
//
//  CustomPickerView.swift
//  datetimepickerDemo
//
//  Created by  sparrow on 2018. 3. 8..
//  Copyright © 2018년  sparrow. All rights reserved.
//

import UIKit

@IBDesignable
class CustomPickerView: UIPickerView
{
    @IBInspectable var selectorColor: UIColor? = nil
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        if let color = selectorColor
        {
            if subview.bounds.height <= 1.0
            {
                subview.backgroundColor = color
            }
        }
    }
}
