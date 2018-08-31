//
//  WSFavouriteWithThreeProductTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 20/11/2017.
//

import UIKit

class WSFavouriteWithThreeProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var easyOrderingLabel: UILabel!
    @IBOutlet weak var goToMyListButton: UIButton!
    @IBOutlet weak var shoppingListLabel: UILabel!
    @IBOutlet weak var productImageView3: UIImageView!
    @IBOutlet weak var productImageView2: UIImageView!
    @IBOutlet weak var productImageView1: UIImageView!
    
  @IBOutlet weak var myListLabel: UILabel!
  @IBOutlet weak var gotoLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setUI(){
        shoppingListLabel.text = WSUtility.getlocalizedString(key: "Shopping list", lang: WSUtility.getLanguage(), table: "Localizable")
        
        easyOrderingLabel.text = WSUtility.getlocalizedString(key: "Easy ordering via your lists!_multiple_products", lang: WSUtility.getLanguage(), table: "Localizable")
        
        goToMyListButton.setTitle(WSUtility.getlocalizedString(key: "Go to my list", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
      
//      gotoLabel.text = WSUtility.getTranslatedString(forString: "Go to")
//      myListLabel.text = WSUtility.getTranslatedString(forString: "my list")
    }
  @IBAction func goToMyFavListAction(_ sender: UIButton) {
    let tabBarController = window?.rootViewController as? UITabBarController
    tabBarController?.selectedIndex = 1
  }
}
