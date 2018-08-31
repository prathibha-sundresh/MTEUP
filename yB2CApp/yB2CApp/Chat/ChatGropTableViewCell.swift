//
//  ChatGropTableViewCell.swift
//  UFSDev
//
//  Created by Abbut John on 4/13/18.
//

import UIKit

class ChatGropTableViewCell: UITableViewCell {

    @IBOutlet weak var chatNameLb: UILabel!
    @IBOutlet weak var chatHeadImgV: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
