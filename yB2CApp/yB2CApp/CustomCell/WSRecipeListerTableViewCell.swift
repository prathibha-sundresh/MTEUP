//
//  WSRecipeListerTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 30/11/17.
//

import UIKit

class WSRecipeListerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var removeFavButton: UIButton!
    @IBOutlet weak var addRemoveFavButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func setUI(){
//        if(removeFavButton.isHidden == false){
//        removeFavButton.setTitle(WSUtility.getlocalizedString(key:"Remove", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
//        }
        
    }
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

