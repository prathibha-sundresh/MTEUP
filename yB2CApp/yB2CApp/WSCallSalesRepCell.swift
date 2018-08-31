//
//  WSCallSalesRepCell.swift
//  yB2CApp
//
//  Created by Anandita on 11/15/17.
//

import UIKit

class WSCallSalesRepCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var callSalesRepName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
