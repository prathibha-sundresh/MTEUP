//
//  CartTableViewCell.swift
//  yB2CApp
//
//  Created by Ajay on 15/11/17.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tfQty: UITextField!
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pName: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!{
        didSet{
            deleteBtn.setTitle(WSUtility.getlocalizedString(key: "delete", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        }
    }
    
  @IBOutlet weak var QuantityBox: UIView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    QuantityBox.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
