//
//  MoneyTransferCustomCell.swift
//  UFS
//
//  Created by Rajesh Reddy on 13/06/18.
//

import UIKit

class MoneyTransferCustomCell: UITableViewCell {
    var isCellSelected = false
    @IBOutlet weak var lblBankBold: UILabel!
    @IBOutlet weak var ivAcc: UIImageView!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var ivRadio: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwBase.layer.borderWidth = 1.0
        vwBase.layer.borderColor = UIColor.lightGray.cgColor
        vwBase.layer.cornerRadius = 5.0
        
        ivRadio.layer.borderWidth = 1.0
        ivRadio.layer.borderColor = UIColor.lightGray.cgColor
        ivRadio.layer.cornerRadius = 7.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
