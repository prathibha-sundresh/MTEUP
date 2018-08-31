//
//  MyOrderHistoryTableViewCell.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/7/17.
//

import UIKit

@objc protocol MyOrderHistoryCellDelegate{
  func reOrderButtonAction(selectedIndex:Int)
}

class MyOrderHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateOrderedHeaderLabel:UILabel!
    @IBOutlet weak var statusHeaderLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var reOrderAllButton: UIButton!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var tradePartnernameLabel: UILabel!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderCreatedDateLabel: UILabel!
    @IBOutlet weak var orderHeaderlabel: UILabel!
    @IBOutlet weak var traderpartnerHeaderLabel: UILabel!
    @IBOutlet weak var pointsEarnedHeaderLabel: UILabel!
    @IBOutlet weak var fullOrderHistoryButton: UIButton!{
        didSet{
            
            fullOrderHistoryButton.setTitle(WSUtility.getlocalizedString(key: "See full order details", lang: WSUtility.getLanguage(), table: "Localizable"), for: UIControlState.normal)
        }
    }
    
    @IBOutlet weak var totalPriceHeaderLabel: UILabel!
    @IBOutlet weak var myOrderHIstoryLabel:UILabel!
    @IBOutlet weak var subHeaderOrderHistoryLabel:UILabel!{
        didSet{
            subHeaderOrderHistoryLabel.numberOfLines = 0
            subHeaderOrderHistoryLabel.sizeToFit()
        }
    }
  
 weak var delegate:MyOrderHistoryCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//
//        subHeaderOrderHistoryLabel.text = (WSUtility.getlocalizedString(key: "Review and reorder your previous items", lang: WSUtility.getLanguageCode(), table: "Localizable")) + (WSUtility.getlocalizedString(key: "You can adjust product quantities in the cart", lang: WSUtility.getLanguageCode(), table: "Localizable"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(){
        totalPriceHeaderLabel.text = WSUtility.getlocalizedString(key: "Total price", lang: WSUtility.getLanguage(), table: "Localizable")
        orderHeaderlabel.text = WSUtility.getlocalizedString(key: "Order Number:", lang: WSUtility.getLanguage(), table: "Localizable")
        dateOrderedHeaderLabel.text = WSUtility.getlocalizedString(key: "Date Ordered:", lang: WSUtility.getLanguage(), table: "Localizable")
        statusHeaderLabel.text = WSUtility.getlocalizedString(key: "Status:", lang: WSUtility.getLanguage(), table: "Localizable")
        traderpartnerHeaderLabel.text = WSUtility.getlocalizedString(key: "Trade Partner:", lang: WSUtility.getLanguage(), table: "Localizable")
        pointsEarnedHeaderLabel.text = WSUtility.getlocalizedString(key: "Points earned:", lang: WSUtility.getLanguage(), table: "Localizable")
        reOrderAllButton.setTitle(WSUtility.getlocalizedString(key: "Re-order all", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        reOrderAllButton.titleLabel?.adjustsFontSizeToFitWidth = true
        myOrderHIstoryLabel.text = WSUtility.getlocalizedString(key: "My Order History", lang: WSUtility.getLanguage(), table: "Localizable")
        
        subHeaderOrderHistoryLabel.text = "\(String(describing: (WSUtility.getlocalizedString(key: "Review and reorder your previous items.", lang: WSUtility.getLanguageCode(), table: "Localizable"))!))\n\(String(describing: (WSUtility.getlocalizedString(key: "You can adjust product quantities in the cart.", lang: WSUtility.getLanguageCode(), table: "Localizable"))!))"

    }
    func setUI(dict:[String:Any]){
        self.updateUI()
        var currencyCode:String = ""
        if WSUtility.isLoginWithTurkey() {
            if let orderNumber = dict["code"]{
                orderNumberLabel.text = "\(orderNumber)"
            }
            if let orderCreated = dict["placed"] as? String{
                var myStringArr = orderCreated.components(separatedBy: " ")
                
                let dateFormatter = DateFormatter()
                let tempLocale = dateFormatter.locale // save locale temporarily
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

//                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: myStringArr[0])
                dateFormatter.dateFormat = "MM/dd/yy"
                
                
                orderDateLabel.text = "\(dateFormatter.string(from: date!))"
            }

            if let orderStatus = dict["statusDisplay"] as? String{
                
                if(orderStatus.caseInsensitiveCompare("COMPLETED") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = WSUtility.getlocalizedString(key:"Completed", lang: WSUtility.getLanguage(), table: "Localizable")
                }
                else if (orderStatus.caseInsensitiveCompare("CANCELLED") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = WSUtility.getlocalizedString(key:"Cancelled", lang: WSUtility.getLanguage(), table: "Localizable")
                } else if (orderStatus.caseInsensitiveCompare("processing") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"processing", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                } else if (orderStatus.caseInsensitiveCompare("Migrated") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Migrated", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                } else if (orderStatus.caseInsensitiveCompare("Shipped") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Shipped", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                } else if (orderStatus.caseInsensitiveCompare("Delivered") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Delivered", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                } else if (orderStatus.caseInsensitiveCompare("Partially cancelled") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Partially cancelled", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                } else if (orderStatus.caseInsensitiveCompare("Refunded") == ComparisonResult.orderedSame){
                    orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Refunded", lang: WSUtility.getLanguage(), table: "Localizable")!)"
                }
                else{
                    orderStatusLabel.text = orderStatus
                }
  
            }
            if let orderInfo = dict["total"] as? NSDictionary{

            if let totalPrice = orderInfo["formattedValue"] as? String{
                        totalPriceLabel.text = "\(totalPrice)"
            }
            }
            
            if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
                tradePartnernameLabel.isHidden = true
                traderpartnerHeaderLabel.isHidden =  true
            }
            tradePartnernameLabel.text = ""
            if let tradePartner = dict["vendorData"] as? NSDictionary{
                if let name = tradePartner["name"] as? String{
                    tradePartnernameLabel.text = "\(name)"
                }
            }
            if let pointsEarned = dict["totalLoyaltyPointsForOrder"] as? Int{
                pointsEarnedLabel.text = "\(pointsEarned)"
            }
            return
        }
        if let orderInfo = dict["orderInfo"] as? NSDictionary{
            if let orderNumber = orderInfo["ecomOrderId"] as? Int{
                orderNumberLabel.text = "\(orderNumber)"
            }
            if let orderCreated = orderInfo["createdDateTime"] as? String{
                var myStringArr = orderCreated.components(separatedBy: " ")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let date = dateFormatter.date(from: myStringArr[0])
                dateFormatter.dateFormat = "MM/dd/yy"
                

                orderDateLabel.text = "\(dateFormatter.string(from: date!))"
            }
        }
        
        if let orderStatus = dict["status"] as? String{
            if("\(orderStatus)" == "COMPLETED"){
            orderStatusLabel.text = WSUtility.getlocalizedString(key:"Completed", lang: WSUtility.getLanguage(), table: "Localizable")
            }
            else if ("\(orderStatus)" == "CANCELLED"){
                orderStatusLabel.text = WSUtility.getlocalizedString(key:"Cancelled", lang: WSUtility.getLanguage(), table: "Localizable")
            } else if ("\(orderStatus)" == "processing"){
                orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"processing", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            } else if ("\(orderStatus)" == "Migrated"){
                orderStatusLabel.text = "\(WSUtility.getlocalizedString(key:"Migrated", lang: WSUtility.getLanguage(), table: "Localizable")!)"
            }
            else{
                orderStatusLabel.text = orderStatus
            }
        }
        if let pointsEarned = dict["totalLoyaltyPoints"] as? Int{
            pointsEarnedLabel.text = "\(pointsEarned)"
        }
        if let totalPrice = dict["totalPrice"] as? Double{
            
            if let currencycode = dict["currencyCode"] as? String{
                currencyCode = currencycode
            }
            if WSUtility.getCountryCode() == "CH"{
                totalPriceLabel.text = "CHF \(totalPrice)"
            }
            else if WSUtility.getCountryCode() == "TR"{
                totalPriceLabel.text = "\(totalPrice) ₺"
            }
            else{
                if currencyCode == "EUR"{
                    totalPriceLabel.text = "€\(totalPrice)"
                }else{
                    totalPriceLabel.text = "\(totalPrice)"
                    
                }
            }
            totalPriceLabel.text = totalPriceLabel.text?.replacingOccurrences(of: ".", with: ",")
        }
        tradePartnernameLabel.text = ""
        if let tradePartner = dict["parentTradePartner"] as? NSDictionary{
            if let name = tradePartner["name"] as? String{
                tradePartnernameLabel.text = "\(name)"
            }
        }
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            tradePartnernameLabel.isHidden = true
            traderpartnerHeaderLabel.isHidden =  true
        }
    }
  @IBAction func reOrderButtonAction(_ sender: UIButton) {
    delegate?.reOrderButtonAction(selectedIndex: sender.tag)
  }
  
}
extension MyOrderHistoryTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imagescell", for: indexPath) as! WSRecommendationProdCollectionViewCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
}
