//
//  OrderSummaryTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 29/12/2017.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {

  @IBOutlet weak var orderNumberLabel: UILabel!
  @IBOutlet weak var loyaltyPointEarnedLabel: UILabel!
  @IBOutlet weak var tradePartnerLabel: UILabel!
  @IBOutlet weak var myLoyaltyPointLabel: UILabel!
  @IBOutlet weak var orderSuccessTextLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
