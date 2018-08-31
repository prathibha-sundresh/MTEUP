//
//  NotificationCell.swift
//  UnileverFoodSolution
//
//  Created by Ramakrishna on 7/20/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var notificationTypeButton: UIButton!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var readUnreadLineLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var rightIndicatorImage: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
