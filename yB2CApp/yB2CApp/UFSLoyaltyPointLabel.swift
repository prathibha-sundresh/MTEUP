//
//  UFSLoyaltyPointLabel.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 11/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSLoyaltyPointLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.roundCorners([.topRight, .bottomRight], radius: 2)
  }
  
}

extension UILabel {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
