//
//  RoundedTextField.swift
//  TaskManagerApp
//
//  Created by Volodymyr Matukh on 3/4/19.
//  Copyright © 2019 Vmatiukh. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    @IBInspectable var borderColor:UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var horisontalPadding:CGFloat = 0.0 
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:bounds.origin.x + horisontalPadding, y:bounds.origin.y, width:bounds.size.width - horisontalPadding * 2, height:bounds.size.height);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds);
    }
    
}
