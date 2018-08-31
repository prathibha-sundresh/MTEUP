//
//  WSPromotionTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 14/11/2017.
//

import UIKit

class WSPromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var shopNowButton:UIButton!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var subHeaderTitleLabel: UILabel!
  @IBOutlet weak var promotionLabel: UILabel!
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var bannerTransparentView: UIView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    bannerTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }
  func updateCellContent(dict:[String:Any])  {
    setUI()
    if let bannerImage = dict["banner_image"] as? String{
      bannerImageView.sd_setImage(with: URL(string:bannerImage), placeholderImage: UIImage(named: "placeholder.png"))
      
    }
    
    if let bannerTitle = dict["title"] as? String {
      bannerLabel?.text = bannerTitle
    }
   
  }
  
    func setUI(){
        promotionLabel?.text = WSUtility.getlocalizedString(key: "Your deal", lang: WSUtility.getLanguage(), table: "Localizable")
        subHeaderTitleLabel?.text = WSUtility.getlocalizedString(key: "Careful these are hot 🔥", lang: WSUtility.getLanguage(), table: "Localizable")
       // bannerLabel?.text = WSUtility.getlocalizedString(key: "20% off all dairy alternative products", lang: WSUtility.getLanguage(), table: "Localizable")
        shopNowButton?.setTitle(WSUtility.getlocalizedString(key: "Shop now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        shopNowButton.titleLabel?.adjustsFontSizeToFitWidth = true

    }

}
