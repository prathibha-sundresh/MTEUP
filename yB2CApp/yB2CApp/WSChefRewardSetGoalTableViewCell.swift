//
//  WSChefRewardSetGoalTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit

@objc protocol ChefRewardSetGoalDelegate {
  
  func reloadTableViewAfterSetGoal(cell:WSChefRewardSetGoalTableViewCell)
}

class WSChefRewardSetGoalTableViewCell: UITableViewCell {
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productLoyaltyPointLabel: UILabel!
  
  @IBOutlet weak var setGoalHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var setGoalButton: WSDesignableButton!
  var goalProductID = ""
  weak var delegate:ChefRewardSetGoalDelegate?
  
  @IBOutlet weak var goalSetDisplayLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func setLoyaltyPoint(loyaltyPoint:String)  {
    let attributedString = NSMutableAttributedString(string: WSUtility.getTranslatedString(forString: "Loyalty Points") + " \(loyaltyPoint)")
    attributedString.setColorForText(loyaltyPoint, with: UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 0, alpha: 1), with: nil)
    productLoyaltyPointLabel.attributedText = attributedString
  }
  
    func setUI(){
        setGoalButton.setTitle(WSUtility.getlocalizedString(key: "Set as a goal", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    }
  @IBAction func setGoalButtonAction(_ sender: WSDesignableButton) {
    
  UFSProgressView.showWaitingDialog("")
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.setGoalForProduct(productID: goalProductID, successResponse: { (response) in
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }

            UFSGATracker.trackEvent(withCategory: "Set-up Loyalty Goal", action: "Loyalty", label: self.goalProductID, value: nil)
        FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Set-up Loyalty Goal", Action: "Loyalty", Label: "Reward ID Loyalty Goal")
        WSUtility.sendTrackingEvent(events: "Other", categories: "Set-up Loyalty Goal",actions:"Loyalty",labels: self.goalProductID)
      UserDefaults.standard.set(self.goalProductID, forKey: USER_LOYALTY_GOAL_ID_KEY)
      UFSProgressView.stopWaitingDialog()
      self.delegate?.reloadTableViewAfterSetGoal(cell: self)
    }) { (errorMessage) in
      UFSProgressView.stopWaitingDialog()
    }
  }
}
