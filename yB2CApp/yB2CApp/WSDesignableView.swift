
//
//  WSDesignableView.swift
//  yB2CApp
//
//  Created by Lakshminarayana on 05/12/17.
//

import Foundation
@IBDesignable class WSDesignableView: UIView {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    
}
