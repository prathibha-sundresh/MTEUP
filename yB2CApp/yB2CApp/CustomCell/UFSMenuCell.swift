//
//  UFSMenuCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 9/29/17.
//

import UIKit

let MENU_CELL_ID     = "MENU_CELL_ID"

let MENU_TITLE       = "MENU_TITLE"
let MENU_ICON        = "MENU_ICON"
let MENU_ACCESSID    = "MENU_ACCESSID"
let MENU_ACTION_TAG  = "MENU_ACTION_TAG"

@objc class UFSMenuCell: UITableViewCell {
    
    @IBOutlet weak var menuIconView: UIImageView!
    @IBOutlet weak var menuLeftIconView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithParams(params: [String : Any]){
        
        menuIconView.image = UIImage(named: params[MENU_ICON] as! String)
        menuLabel.text = params[MENU_TITLE] as? String
    }
    
}
