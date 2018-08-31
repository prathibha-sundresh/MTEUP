//
//  WSFavouriteWithOneProductTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 20/11/2017.
//

import UIKit

class WSFavouriteWithOneProductTableViewCell: UITableViewCell {
  @IBOutlet weak var addMoreProductTextLabel: UILabel!
  @IBOutlet weak var goToTextLabel: UILabel!
  @IBOutlet weak var shoppingListTextLabel: UILabel!
  @IBOutlet weak var easyOrderingTextLabel: UILabel!
  
  @IBOutlet weak var myListTextLabel: UILabel!
  @IBOutlet weak var gotoBtn: UIButton!
  @IBOutlet weak var productImageView: UIImageView!
  override func awakeFromNib() {
      super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func goToMyFavListAction(_ sender: UIButton) {
    let tabBarController = window?.rootViewController as? UITabBarController
    tabBarController?.selectedIndex = 1
  }
  
  func updateCellContent()  {
    addMoreProductTextLabel.text = WSUtility.getTranslatedString(forString: "Add more products to you favourites list")
    shoppingListTextLabel.text = WSUtility.getTranslatedString(forString: "Shopping list")
    easyOrderingTextLabel.text = WSUtility.getTranslatedString(forString: "Easy ordering via your lists!_one_product")
    gotoBtn.setTitle(WSUtility.getTranslatedString(forString: "Go to my list"), for: .normal)
//    goToTextLabel.text = WSUtility.getTranslatedString(forString: "Go to")
//    myListTextLabel.text = WSUtility.getTranslatedString(forString: "my list")
    
  }
}
