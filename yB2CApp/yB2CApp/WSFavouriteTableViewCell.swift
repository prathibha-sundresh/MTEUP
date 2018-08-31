//
//  WSFavouriteTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

class WSFavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var createYourListButton: WSDesignableButton!
    @IBOutlet weak var easyOrderingLabel: UILabel!
    @IBOutlet weak var favouriteListLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      createYourListButton.titleLabel!.numberOfLines = 0
      createYourListButton.titleLabel!.adjustsFontSizeToFitWidth = true
      createYourListButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
      createYourListButton.titleLabel!.textAlignment = .center
    }

    func setUI(){
        favouriteListLabel.attributedText = favouriteListLabel.imageIconWithLabel(text: WSUtility.getlocalizedString(key: "Shopping List", lang: WSUtility.getLanguage(), table: "Localizable")!, imageName: "TabBar-ShoppingList")
        easyOrderingLabel.text = WSUtility.getlocalizedString(key: "See a product you like? Then favourite it", lang: WSUtility.getLanguage(), table: "Localizable")
        createYourListButton.setTitle(WSUtility.getlocalizedString(key: "Start building your list", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        favouriteListLabel.sizeToFit()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func createListAction(_ sender: WSDesignableButton) {
    let tabBarController = window?.rootViewController as? UITabBarController
    tabBarController?.selectedIndex = 2
  }
}
