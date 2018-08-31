//
//  UFSRecipeDetailTableViewSectionView.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSRecipeDetailTableViewSectionView: UIView {
  @IBOutlet weak var sectionTitleLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  class func instanceFromNib() -> UIView {
    return UINib(nibName: "UFSRecipeDetailTableViewSectionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }

}
