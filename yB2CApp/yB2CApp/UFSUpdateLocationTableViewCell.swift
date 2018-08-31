//
//  UFSUpdateLocationTableViewCell.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 23/06/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSUpdateLocationTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rightImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func hideOrShowRightIndicatorViewForCell(cell:UFSUpdateLocationTableViewCell, state isHidden:Bool) {
    if isHidden {
      cell.nameLabel.textColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0 , blue: 51.0/255.0, alpha: 1)
      cell.rightImageView.isHidden = true
      
    }else{
       cell.nameLabel.textColor = UIColor(red: 250.0 / 255.0, green: 90.0 / 255.0 , blue: 0, alpha: 1)
      cell.rightImageView.isHidden = false
    }
  }

}
