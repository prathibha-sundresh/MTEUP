//
//  UFSCardView.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 17/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSCardView: UIView {
  @IBOutlet weak var receipeImageView: UIImageView!
  @IBOutlet weak var recepieTitle: UILabel!
  @IBOutlet weak var titleLabelWidthConstraints: NSLayoutConstraint!
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
  class func instanceFromNib() -> UIView {
    return UINib(nibName: "UFSCardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }
  
}
