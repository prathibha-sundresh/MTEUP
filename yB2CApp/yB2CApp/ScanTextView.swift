//
//  ScanTextView.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 24/11/2017.
//

import UIKit

class ScanTextView: UIView {

    @IBOutlet weak var scanTextLabel: UILabel!{
        didSet{
            scanTextLabel.text = WSUtility.getlocalizedString(key: "Scan UFS product barcode", lang: WSUtility.getLanguage(), table: "Localizable")
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
