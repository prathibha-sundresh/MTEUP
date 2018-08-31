//
//  WSProductDetailUseTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 05/01/2018.
//

import UIKit

class WSProductDetailUseTableViewCell: UITableViewCell {

  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var AllergyTableView: UITableView!
  
  @IBOutlet weak var productDescriptionTextLabel: UILabel!
  @IBOutlet weak var fourthDescriptionValueLabel: UILabel!
  @IBOutlet weak var fourthDescriptionLabel: UILabel!
  @IBOutlet weak var thirdDescriptionValueLabel: UILabel!
  @IBOutlet weak var thirdDescriptionLabel: UILabel!
  @IBOutlet weak var secondDescriptionBoxLabel: UILabel!
  @IBOutlet weak var firstDescriptionLabel: UILabel!
  @IBOutlet weak var firstDescriptionValueLabel: UILabel!
  @IBOutlet weak var fifthDescriptionLabel: UILabel!
  @IBOutlet weak var fifthDescriptionValueLabel: UILabel!
  
   var allergeneArray = [[String:Any]]()
   var yieldComponent = [String]()
//  var productDetailArray = [String:Any]()

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    //WSAllergyInfoTableViewCell
    
    AllergyTableView.register(UINib(nibName: "WSAllergyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "WSAllergyInfoTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateCellContent(detail:[String:Any])  {
    
    if let allergene = detail["yields"] as? [[String : Any]]{
      allergeneArray = allergene
    }
    
    if let component = detail["yieldCaptionComponents"] as? [String]{
      yieldComponent = component
    }
    
    
    tableViewHeightConstraint.constant = CGFloat(allergeneArray.count > 0 ? (44*(allergeneArray.count + 1)) : 0)
    AllergyTableView.reloadData()
    
    let noInformationLocalizedString = WSUtility.getTranslatedString(forString: "no information available")
    
    firstDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Preparation")//"Preparation"
    if let preparations = detail["preparation"] as? String{
      let formattedString = preparations.replacingOccurrences(of: "\\n", with: "\n")
      firstDescriptionValueLabel.text = preparations.count > 0 ? formattedString : noInformationLocalizedString
    }else{
       firstDescriptionValueLabel.text =  WSUtility.getTranslatedString(forString: "no information available")
      
    }
    
    secondDescriptionBoxLabel.text =  allergeneArray.count > 0 ? WSUtility.getTranslatedString(forString: "Yield") : ""
    
    
    thirdDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Benefits")//"Benefits"
    if let benefits = detail["benefits"] as? String{
      var formattedString = benefits.replacingOccurrences(of: "\\n", with: "\n")
      formattedString = formattedString.replacingOccurrences(of: "\\r", with: "\n")
      //formattedString = benefits.replacingOccurrences(of: "\\n*", with: "\n")
      thirdDescriptionValueLabel.text = benefits.count > 0 ? formattedString : noInformationLocalizedString
    }
    
    fourthDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Shelf Life")//"Shelf Life"
    if let shelfLife = detail["shelflife"] as? String{
      fourthDescriptionValueLabel.text = shelfLife.count > 0 ? "\(shelfLife) \(WSUtility.getTranslatedString(forString: "days"))" : noInformationLocalizedString
    }
    
    fifthDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Storage")//"Storage"
    if let storage = detail["storage"] as? String{
      var formattedString = storage.replacingOccurrences(of: "\\n", with: "\n")
      formattedString = formattedString.replacingOccurrences(of: "\\r", with: "\n")
      
      fifthDescriptionValueLabel.text = storage.count > 0 ? formattedString : noInformationLocalizedString
    }else{
      fifthDescriptionValueLabel.text =  noInformationLocalizedString
    }
    
  }
}

extension WSProductDetailUseTableViewCell:UITableViewDelegate,UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allergeneArray.count + 1
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WSAllergyInfoTableViewCell") as? WSAllergyInfoTableViewCell
    
    if indexPath.row == 0{
      cell?.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1)
      
     
      /*
      cell?.productQuantityLabel.text = yieldComponent.count > 0 ? yieldComponent[0] : ""
      cell?.waterLabel.text = yieldComponent.count > 1 ? yieldComponent[1] : ""
      cell?.thirdComponentLabel.text = yieldComponent.count > 2 ? yieldComponent[2] : ""
      cell?.fourthComponentLabel.text = yieldComponent.count > 3 ? yieldComponent[3] : ""
      */
      
      cell?.productQuantityLabel.text =  WSUtility.getTranslatedString(forString: "product Quantity")
      cell?.waterLabel.text = WSUtility.getTranslatedString(forString: "Water")
      
      cell?.yieldLabel.text = WSUtility.getTranslatedString(forString: "Yield in liters")
      cell?.yieldPerServingLabel.text = WSUtility.getTranslatedString(forString: "Yield per serving")
    }else{
      let dictInfo = allergeneArray[indexPath.row - 1]
    
    if indexPath.row % 2 == 0 {
      
       cell?.backgroundColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)
    }else{
     cell?.backgroundColor = UIColor.white
    }
    
    
      if let component1 = dictInfo["component1"] as? String{
        cell?.productQuantityLabel.text = component1
      }else{
        cell?.productQuantityLabel.text = ""
      }
      
      if let component2 = dictInfo["component2"] as? String{
        cell?.waterLabel.text = component2
      }else{
        cell?.waterLabel.text = ""
      }
      
      if let component3 = dictInfo["component3"] as? String{
        cell?.thirdComponentLabel.text = component3
      }else{
        cell?.thirdComponentLabel.text = ""
      }
      
      if let component4 = dictInfo["component4"] as? String{
        cell?.fourthComponentLabel.text = component4
      }else{
        cell?.fourthComponentLabel.text = ""
      }
        
      if let productYieldInLiters = dictInfo["productYieldInLiters"] as? String{
        cell?.yieldLabel.text = productYieldInLiters == "null" ? "-" : productYieldInLiters
      }else{
        cell?.yieldLabel.text = ""
      }
      if let productYieldInPortions = dictInfo["productYieldInPortions"] as? String{
         cell?.yieldPerServingLabel.text =   productYieldInPortions == "null" ? "-" : productYieldInPortions
      }else{
         cell?.yieldPerServingLabel.text = ""
       }
      }
      return cell!
  }
  
}
