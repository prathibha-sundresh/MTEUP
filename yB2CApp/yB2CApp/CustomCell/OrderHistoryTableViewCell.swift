//
//  OrderHistoryTableViewCell.swift
//  yB2CApp
//
//  Created by Sahana Rao on 06/12/17.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewAndReorderLabel: UILabel!{
        didSet{
            reviewAndReorderLabel.numberOfLines = 0
            reviewAndReorderLabel.sizeToFit()
        }
    }
    @IBOutlet weak var myOrderHistoryLabel: UILabel!
    @IBOutlet weak var orderNumberAndDateLabel: UILabel!
    @IBOutlet weak var orderPointsDetailsLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderDetailsLabel: UILabel!
    var orderNumber : String = ""
    var tradePartnerName : String = ""
    var clientNumber : String = ""
    var orderStatus : String = ""
    var orderDate : String = ""
    var totalItems : String = ""
    var pointsEarned : String = ""
    var pointsSpent : String = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
////        orderNumber = "000102"
//        tradePartnerName = "Knorr"
//        clientNumber = "17635353"
//        orderStatus = "Completed"
//        orderDate = "6/7/17"
//        totalItems = "30 items"
//        pointsEarned = "1500"
//        pointsSpent = "0"
       
        
    }
    func translateUI(){
        let string1 = WSUtility.getlocalizedString(key: "Review and reorder your previous items.", lang: WSUtility.getLanguage(), table: "Localizable")
        let string2 = WSUtility.getlocalizedString(key: "You can adjust product quantities in the cart.", lang: WSUtility.getLanguage(), table: "Localizable")
        reviewAndReorderLabel.text = string1! + string2!
        myOrderHistoryLabel.text = WSUtility.getlocalizedString(key: "My Order History", lang: WSUtility.getLanguage(), table: "Localizable")

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUI(dict:[String:Any]){
//      if let ordernumber = dict["id"] as? Int{
//        orderNumber = "\(ordernumber)"
//      }
        orderNumber = "\(dict["id"] ?? "")"
        if WSUtility.isLoginWithTurkey() {
            orderDate = "\(dict["createdDateTime"] ?? "")"
        }
        else{
            if let createdDateTime = dict["createdDateTime"] as? String{
                var myStringArr = createdDateTime.components(separatedBy: " ")
                //orderDate = "\(myStringArr[0])"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let date = dateFormatter.date(from: myStringArr[0])
                dateFormatter.dateFormat = "MM/dd/yy"
                orderDate = "\(dateFormatter.string(from: date!))"
            }
        }

      if let quantity = dict["orderLineItemCount"] as? Int{
        totalItems = "\(quantity)" + " " + "\(WSUtility.getlocalizedString(key: "Items", lang: WSUtility.getLanguage(), table: "Localizable")!)"

      }
      if let loyaltyPoints = dict["totalLoyaltyPoints"] as? Int{
        pointsEarned = "\(loyaltyPoints)"
      }
      if let rewardPoint = dict["totalLoyaltyRewardPoints"] as? Int{
        pointsSpent = "\(rewardPoint)"
      }
      
      
        if let status = dict["status"] as? String{
            
            if(status.caseInsensitiveCompare("COMPLETED") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Completed", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            }
            else if (status.caseInsensitiveCompare("CANCELLED") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Cancelled", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("processing") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"processing", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("Migrated") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Migrated", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("Shipped") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Shipped", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("Delivered") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Delivered", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("Partially cancelled") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Partially cancelled", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if (status.caseInsensitiveCompare("Refunded") == ComparisonResult.orderedSame){
                orderStatus = "\(WSUtility.getlocalizedString(key:"Refunded", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            }
            else{
                orderStatus = status
            }

        }
        if let tradePartner = dict["parentTradePartner"] as? NSDictionary{
            if let tradepartnername = tradePartner["name"] as? String{
                tradePartnerName = "\(tradepartnername)"
            }
            if WSUtility.isLoginWithTurkey() {
            if let arrAddress = tradePartner["vendorAddress"] as? [[String:Any]]{
                if let obj = arrAddress[0] as? [String:Any]{
                    clientNumber = "\(obj["phone1"] ?? "")"
                }
            }
            }
        }
        
        if let valueStr = dict["clientNumber"] as? String {
            clientNumber = "\(valueStr)"
        }
//        if WSUtility.isLoginWithTurkey() {
//            if let obj = dict["parentTradePartner"] as? [String:Any]{
//
//        }
//        }
        //Setting Order Number and Date
        var stringLocation = 0
        let orderNumberText = WSUtility.getlocalizedString(key: "Order Number:", lang: WSUtility.getLanguage(), table: "Localizable")?.appending(" ")
        
        let dateOrderedText = WSUtility.getlocalizedString(key: "Date Ordered:", lang: WSUtility.getLanguage(), table: "Localizable")?.appending(" ")
        
        var orderString = orderNumberText! + "\(orderNumber)\n" + dateOrderedText! + "\(orderDate)"
        var attributedString = NSMutableAttributedString(string: orderString, attributes:[NSFontAttributeName:
            UIFont(name: "DinPro-Regular", size: 14.0)!])
        let str = NSString(string:orderString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 18.0)!, range: str.range(of: "\(orderNumberText! + orderNumber)"))
        
        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 0
//        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        orderNumberAndDateLabel.attributedText = attributedString

        //Setting Order Points
        let pointsEarnedText = WSUtility.getlocalizedString(key: "Points earned:", lang: WSUtility.getLanguage(), table: "Localizable")?.appending(" ")
        let pointsSpentText = WSUtility.getlocalizedString(key: "Points spent:", lang: WSUtility.getLanguage(), table: "Localizable")?.appending(" ")
        let totalText = WSUtility.getlocalizedString(key: "Total:", lang: WSUtility.getLanguage())
        orderString = totalText! + "\(totalItems) \n" + pointsEarnedText! + "\(pointsEarned) \n" + pointsSpentText! + "\(pointsSpent)"

        attributedString = NSMutableAttributedString(string: orderString, attributes:[NSFontAttributeName:
            UIFont(name: "DinPro-Regular", size: 14.0)!])
        stringLocation = 0
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 14.0)!, range: NSRange(location: stringLocation, length: totalText!.count))
        stringLocation = "\(totalText!)".count + "\(totalItems) \n".count
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 14.0)!, range: NSRange(location: stringLocation, length: (pointsEarnedText?.count)!))
        stringLocation = stringLocation + (pointsEarnedText!.count) + pointsEarned.count + "\n".count
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 14.0)!, range: NSRange(location: stringLocation, length: pointsSpentText!.count))
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        orderPointsDetailsLabel.attributedText = attributedString
        
        //Setting Order Status
        stringLocation = 0
        let statusText = WSUtility.getlocalizedString(key: "Status:", lang: WSUtility.getLanguage(), table: "Localizable")
        let tradePartnerText = "\(WSUtility.getlocalizedString(key: "Trade Partner:", lang: WSUtility.getLanguage(), table: "Localizable")!) "
      let orderStatusValue = WSUtility.getTranslatedString(forString: "\(self.orderStatus)")
        orderString = statusText! + "\(orderStatusValue) \n" + tradePartnerText + "\(self.tradePartnerName)"
        
        attributedString = NSMutableAttributedString(string: orderString, attributes:[NSFontAttributeName:
            UIFont(name: "DinPro-Regular", size: 14.0)!])
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 14.0)!, range: NSRange(location: stringLocation, length: 6))
        stringLocation = (statusText! + "\(orderStatusValue) \n").count
      
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 14.0)!, range: NSRange(location: stringLocation, length: tradePartnerText.count))
        orderStatusLabel.attributedText = attributedString
        
      orderString = String(format:WSUtility.getTranslatedString(forString:"Your order <order number> has been passed to your trade partner <trade partner name> with your client number <client number>"),"\(self.orderNumber)","\(self.tradePartnerName)","\(self.clientNumber)") + "\n\n" + String(format:WSUtility.getTranslatedString(forString: "For further questions about handling of this order please contact <trade partner name>"),"\(self.tradePartnerName)")
      
      let attributedString2 = NSMutableAttributedString(string: orderString, attributes: [
        NSFontAttributeName: UIFont(name: "DINPro-Regular", size: 12.0)!,
        NSForegroundColorAttributeName: UIColor(white: 51.0 / 255.0, alpha: 1.0)
        ])
      
      
      let range = attributedString2.mutableString.range(of: "\(self.orderNumber)", options: .caseInsensitive)
      if range.location != NSNotFound {
        
        attributedString2.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range)
      }
      
      let range2 = attributedString2.mutableString.range(of: "\(self.tradePartnerName)", options: .caseInsensitive)
      if range2.location != NSNotFound {
        
        attributedString2.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range2)
      }
      
      let range3 = attributedString2.mutableString.range(of: "\(self.clientNumber)", options: .caseInsensitive)
      if range3.location != NSNotFound {
        
        attributedString2.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range3)
      }
      let range4 = attributedString2.mutableString.range(of: "\(self.tradePartnerName)", options: .caseInsensitive, range: NSMakeRange(orderString.count - "\(self.tradePartnerName)".count, "\(self.tradePartnerName)".count))
       if range4.location != NSNotFound {
         attributedString2.addAttributes([NSFontAttributeName: UIFont(name: "DINPro-Medium", size: 12.0)!], range: range4)
        }
      
       orderDetailsLabel.attributedText = attributedString2
      
    }
  
    func setOrderDetails () {

       // var orderString:String = ""

    }
    
}

