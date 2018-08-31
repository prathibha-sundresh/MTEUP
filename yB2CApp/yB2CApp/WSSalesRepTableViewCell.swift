//
//  WSSalesRepTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 16/11/2017.
//

import UIKit

protocol SalesRepoDelegate {
  func reloadSaleRepoSection(isExpandedCell:Bool)
  
}

class WSSalesRepTableViewCell: UITableViewCell {
  
  var delegate : SalesRepoDelegate?
  var isCellExpanded = true
  
  @IBOutlet weak var callButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var callSalesRepImage: UIImageView!
  @IBOutlet weak var callButtonTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var expandAndCollapseButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var callButton: WSDesignableButton!
  @IBOutlet weak var chatBtn: WSDesignableButton!
  
  @IBOutlet weak var chatBtnHightConstraint: NSLayoutConstraint!
  @IBOutlet weak var chatBtnTopConstraint: NSLayoutConstraint!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    chatBtn.setTitle(WSUtility.getlocalizedString(key: "chat", lang: WSUtility.getLanguage()), for: UIControlState.normal)
    
  }
  
  @IBAction func performCall(_ sender: Any) {
    
    let phNumber = UserDefaults.standard.string(forKey: "salesrepnumber")
    let trimmedCharacters = phNumber?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    if let url = NSURL(string: "tel://\(trimmedCharacters ?? "")"), UIApplication.shared.canOpenURL(url as URL) {
      // UIApplication.shared.openURL(url as URL)
      if #available(iOS 10, *) {
        UIApplication.shared.open(url as URL)
      } else {
        UIApplication.shared.openURL(url as URL)
      }
    }
  }
  
  @IBAction func performChat(_ sender: Any) {
    
  }
  @IBAction func chatButton_click(_ sender: Any) {
  
    LiveChat.presentChat()
    
  }
  
  func setSaleRepName(name:String, message:String)  {
    
    callSalesRepImage.layer.masksToBounds = true;
    callSalesRepImage.layer.cornerRadius = callSalesRepImage.frame.size.height / 2
    // let needsalesText = WSUtility.getlocalizedString(key: "Need Help, Call your sales rep", lang: WSUtility.getLanguageCode(), table: "Localizable")! + "\(name)"
    var needsalesText = ""
    if message.contains(find: name) {
        needsalesText = String(format: WSUtility.getlocalizedString(key: "Need Help, Call your sales rep", lang: WSUtility.getLanguage())!, name)
    } else {
      needsalesText = WSUtility.getlocalizedString(key: message, lang: WSUtility.getLanguageCode(), table: "Localizable")! + "\(name)"
    }
    let attributedString = NSMutableAttributedString(string: needsalesText)
    attributedString.setColorForText(name, with: UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1), with: UIFont(name: "DINPro-Medium", size: 13.0))
    titleLabel.attributedText = attributedString
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func expandAndCollapseAction(_ sender: UIButton) {
    
    delegate?.reloadSaleRepoSection(isExpandedCell: isCellExpanded)
    isCellExpanded = !isCellExpanded
  }
  
  func updateCellContent(isNeedToHideAllViews:Bool, salesRepDetails:[[String:Any]],cellExpandingStatus:Bool) {
    for view in self.contentView.subviews {
      view.isHidden = isNeedToHideAllViews
    }
    
    /// Logic to hide/show Sale Rep calling feature
    if WSUtility.isFeatureEnabled(feature: featureId.Sales_Rep_Call.rawValue) {
      
      self.callButton.isHidden = !cellExpandingStatus
      if salesRepDetails.count > 0 {
        let dict = salesRepDetails.first!
        if let imageurl = dict["slrep_image"] {
          self.callSalesRepImage.sd_setImage(with: URL(string:imageurl as! String))
        }else{
          self.callSalesRepImage.image = UIImage()
        }
        
        UserDefaults.standard.set(dict["phone_number"] as? String, forKey: "salesrepnumber")
        
        if let firstName = dict["slrep_name"] as? String{
          let salePersonFistName = firstName.components(separatedBy: " ")
          if salePersonFistName.count > 0 {
            
            let buttonTitle = String(format:WSUtility.getTranslatedString(forString: "Call your sales representative"),salePersonFistName[0])
            self.callButton.setTitle(buttonTitle, for: .normal)
            
             self.setSaleRepName(name: salePersonFistName[0], message: String(format: WSUtility.getlocalizedString(key: "Need Help, Call your sales rep", lang: WSUtility.getLanguage())!, salePersonFistName[0]))
            
//            self.setSaleRepName(name: salePersonFistName[0], message: WSUtility.getlocalizedString(key: "Need Help, Call your sales rep", lang: WSUtility.getLanguage())!)
          }
          
        }
        
      }
      
    }else{
      self.callButton.isHidden = true
      self.callButton.setTitle("", for: .normal)
      self.setSaleRepName(name: "", message: "")
      
    }
    
    /// Logic to show/Hide Sale Rep Chat feature
    if  WSUtility.isFeatureEnabled(feature: featureId.Sales_rep_chat_feature.rawValue) {
      
      if salesRepDetails.count > 0 {
        let dict = salesRepDetails.first!
        if let firstName = dict["slrep_name"] as? String{
          let salePersonFistName = firstName.components(separatedBy: " ")
          if salePersonFistName.count > 0 {
            let chatbuttonTitle = String(format:WSUtility.getTranslatedString(forString: "Chat with your sales representative"),salePersonFistName[0])
            self.chatBtn.isHidden = !cellExpandingStatus
            self.chatBtn.setTitle(chatbuttonTitle, for: .normal)
          }
        }
        
      }
    }else if  WSUtility.isFeatureEnabled(feature: featureId.Live_Chat_Chef.rawValue) {
      
        if let dict = salesRepDetails.first as? [String : Any]{
            if let imageurl = dict["chefimage"] {
                self.callSalesRepImage.sd_setImage(with: URL(string:imageurl as! String))
            }
        }
        else{
            self.callSalesRepImage.image = #imageLiteral(resourceName: "bubbleIcon")
        }
      
      self.setSaleRepName(name: "", message: WSUtility.getlocalizedString(key: "Need help? Chat with our chef.", lang: WSUtility.getLanguage())!)
      self.chatBtn.isHidden = !cellExpandingStatus
      
      self.chatBtn.addTarget(self, action: #selector(chatButton_click), for: .touchUpInside)
      
    }else{
      self.chatBtn.isHidden = true
      
      
    }
    
    self.callButtonHeightConstraint.constant = self.callButton.isHidden ? 0 : 35
    self.callButtonTopConstraint.constant = self.callButton.isHidden ? 0 : 10
    
    self.chatBtnHightConstraint.constant = self.chatBtn.isHidden ? 0 : 35
    self.chatBtnTopConstraint.constant = self.chatBtn.isHidden ? 0 : 10

    
    
  }
  
  
}
