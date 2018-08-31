//
//  UFSSavedCardCollectionViewCell.swift
//  UFSDev
//
//  Created by Newlaptop on 25/07/18.
//

import UIKit

class UFSSavedCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var cardImgV: UIImageView!
    @IBOutlet weak var cardTitleLbl: UILabel!
    @IBOutlet weak var cardOwnerNameLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var continerV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Added border to the view
        self.continerV.layer.borderColor = UIColor(red:255/255, green:90/255, blue:0/255, alpha: 1).cgColor
        continerV.layer.borderWidth = 1.0
        radioBtn.layer.borderWidth = 1.0
        radioBtn.layer.borderColor = UIColor.lightGray.cgColor
        

    }
}
