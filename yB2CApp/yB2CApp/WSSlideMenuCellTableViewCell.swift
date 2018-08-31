
//
//  WSSlideMenuCellTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

class WSSlideMenuCellTableViewCell: UITableViewCell {
  @IBOutlet weak var itemImageView: UIImageView!
  
    @IBOutlet weak var notificationCountLabel: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
//    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//
//    itemNameLabel.addGestureRecognizer(tap)
//
//    itemNameLabel.isUserInteractionEnabled = true
    notificationCountLabel?.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    
    
    // function which is triggered when handleTap is called
//    func handleTap(_ sender: UITapGestureRecognizer) {
//        itemNameLabel.font = UIFont(name:"DINPro-Medium", size: 16.0)
//        itemNameLabel.textColor = UIColor.black
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
