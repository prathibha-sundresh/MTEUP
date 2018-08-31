//
//  WSDesignableButton.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 08/11/17.
//

import UIKit

@IBDesignable class WSDesignableButton: UIButton {

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
