//
//  WSProductDetailnformationTableViewCell.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 30/11/2017.
//

import UIKit

class WSPdNutritionTableViewCell: UITableViewCell {
  @IBOutlet weak var portionLabel: UILabel!
  @IBOutlet weak var allergyTextLabel: UILabel!
    
    @IBOutlet weak var nutriInfoTextLabel: UILabel!
    @IBOutlet weak var ingredientsTextLabel: UILabel!
    @IBOutlet weak var nutritionCollectionView: UICollectionView!
    @IBOutlet weak var nutritionTableView: UITableView!
    @IBOutlet weak var ingredientsValueLabel: UILabel!
    @IBOutlet weak var allergyValueLable: UILabel!
    @IBOutlet weak var NutrientsPerServingLabel: UILabel!
    
    @IBOutlet weak var nutrientsPerServingHight: NSLayoutConstraint!
    @IBOutlet weak var nutritionCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nutritionTableViewHeightConstraint: NSLayoutConstraint!
    
  var nutritionInfoArray = [[String:Any]]()
  var dachClaimInfoArray = [[String:Any]]()

  // Turkey alone
  var nutritionValueArray = [String]()
  var nutritionTypeArray = [String]()
  var nutritionPortionValuesArray = [String]()
  
  
 // let dackCliamImages = ["Alkoholfrei","Fettarm","Geeignet fÅr leichte Vollkost","Glutenfrei","Keine glutenhaltigen Zutaten lt. Rezeptur","Keine laktosehaltigen Zutaten lt. Rezeptur","Laktosefrei","Mit Jodsalz","Ohne deklarationspflichtige Allergene","Ohne deklarationspflichtige Zusatzstoffe","Ohne Farbstoffe","Ohne Konservierungsstoffe","Ohne MSG lt. Rezeptur","Vegan / Vegetabil","Vegetarisch  Ovo Lacto Vegetabil"]
   let dackCliamImagesAndTitle = ["Keine-glutenhaltigen-Zutaten-lt-Rezeptur":"Keine glutenhaltigen Zutaten lt. Rezeptur","Keine-laktosehaltigen-Zutaten-lt-Rezeptur":"Keine laktosehaltigen Zutaten lt. Rezeptur","Fettarm":"Fettarm","Ohne-MSG-lt-Rezeptur":"Ohne MSG lt. Rezeptur","Ohne-Farbstoffe":"Ohne Farbstoffe","Ohne-Konservierungsstoffe":"Ohne Konservierungsstoffe","Mit-Jodsalz":"Mit Jodsalz","Ohne-deklarationspflichtige-Zusatzstoffe":"Ohne deklarationspflichtige Zusatzstoffe","Ohne-deklarationspflichtige-Allergene":"Ohne deklarationspflichtige Allergene","Geeignet-fur-leichte-Vollkost":"Geeignet für leichte Vollkost","Vegan-Vegetabil":"Vegan / Vegetabil","Vegetarisch-Ovo-Lacto-Vegetabil":"Vegetarisch / Ovo Lacto Vegetabil","Alkoholfrei":"Alkoholfrei","Glutenfrei":"Glutenfrei","Laktosefrei":"Laktosefrei"]
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    NutrientsPerServingLabel.text = WSUtility.getlocalizedString(key: "Nutrients per serving", lang: WSUtility.getLanguage())
    nutritionTableView.register(UINib(nibName: "NutritionInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "NutritionInfoTableViewCell")
    nutritionTableView.register(UINib(nibName: "NutritionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "NutritionHeaderTableViewCell")
    nutritionCollectionView.register(UINib(nibName: "NutritionLogosCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "NutritionLogosCollectionViewCell")
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateCellContent(productDetail:[String:Any])  {
    
    if WSUtility.isLoginWithTurkey(){
        
        nutrientsPerServingHight.constant = 0
        if let nutritionValuearray = (productDetail["nutrientValues"] as? [String]){
            self.nutritionValueArray = nutritionValuearray
        }
        if let nutritionValuTypearray = (productDetail["nutrientTypes"] as? [String]){
            self.nutritionTypeArray = nutritionValuTypearray
        }
        if let nutritionPortionarray = (productDetail["nutrientPortionValues"] as? [String]){
            self.nutritionPortionValuesArray = nutritionPortionarray
        }
    }else{
        
        nutrientsPerServingHight.constant = 0
        ingredientsValueLabel.text = productDetail["ingredients"] as? String
        print(productDetail)
        if let nutritionArray = (productDetail["nutrients"] as? [[String:Any]]){
            nutritionInfoArray = nutritionArray
        }
    }
    
    ingredientsValueLabel.text = productDetail["ingredients"] as? String
    allergyTextLabel.text = WSUtility.getlocalizedString(key: "Allergy", lang: WSUtility.getLanguage(), table: "Localizable")
    if let allergene = productDetail["allergens"] as? [[String:Any]] {
        var allergeneString = ""
        for dict in allergene{
            if dict["yesNo"] as? Bool == true{
                if let name = dict["name"] as? String{
                    allergeneString += "• \(name) \n\n"
                }
            }
        }
        allergyValueLable.text = allergeneString
    }else{
        allergyValueLable.text = WSUtility.getTranslatedString(forString: "no information available")
    }
    ingredientsTextLabel.text = WSUtility.getlocalizedString(key: "Ingredients", lang: WSUtility.getLanguage(), table: "Localizable")
    nutriInfoTextLabel.text = WSUtility.getlocalizedString(key:"Nutritional Information", lang: WSUtility.getLanguage(), table: "Localizable")
    nutritionTableView.reloadData()
    
  }
  func updateCollectionView(with dachClaims:[[String:Any]])  {
        // nutritionLogos = ["NutritionIcon1","NutritionIcon2","NutritionIcon3","NutritionIcon4","NutritionIcon5","NutritionIcon6","NutritionIcon7"]
        dachClaimInfoArray = dachClaims
        self.nutritionCollectionView.reloadData()
  }
    
  func getDiplayValue(valueText : String) -> (String) {

    let fullNameArr = valueText.components(separatedBy: " ")
    if fullNameArr.count > 1 {
    var value  = fullNameArr[0] as String
    let mesure = fullNameArr[1] as String
    value = Float(value) == 0.00 ? "-" : value
    return "\(value) \(mesure)"
    }else{
    return valueText
    }
  }
}

extension WSPdNutritionTableViewCell:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if WSUtility.isLoginWithTurkey(){
            if section == 0{
                return 1
            }
            else{
                return nutritionTypeArray.count//Name
            }
        }else{
            if section == 0{
                return 1
            }
            else{
                return nutritionInfoArray.count
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionHeaderTableViewCell") as? NutritionHeaderTableViewCell
                cell?.backgroundColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)
                
                cell?.nameHebLb.text = WSUtility.getlocalizedString(key: "Name", lang: WSUtility.getLanguage(), table: "Localizable")
                cell?.quatityHedLb.text     = WSUtility.getlocalizedString(key:"100g", lang: WSUtility.getLanguage(), table: "Localizable")
                cell?.attributrHebLb.text      = WSUtility.getlocalizedString(key:"100ml", lang: WSUtility.getLanguage(), table: "Localizable")
              
                return cell!
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionInfoTableViewCell") as? NutritionInfoTableViewCell
                if indexPath.row % 2 == 0 {
                    cell?.backgroundColor = UIColor.white
                }else{
                     cell?.backgroundColor = UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1)
                }
                
                if WSUtility.isLoginWithTurkey(){
                 
                    if (nutritionTypeArray.count > indexPath.row){//name
//cell?.nutritionNameLabel.text = self.getDiplayValue(valueText: nutritionTypeArray[indexPath.row])
                        cell?.nutritionNameLabel.text = nutritionTypeArray[indexPath.row] as String
                        
                    }else{
                        cell?.nutritionNameLabel.text = ""
                    }
                    if (nutritionPortionValuesArray.count > indexPath.row){//mg
//                        cell?.nutritionUnitLabel.text = self.getDiplayValue(valueText: nutritionPortionValuesArray[indexPath.row])
                        
                        cell?.nutritionUnitLabel.text = nutritionPortionValuesArray[indexPath.row] as String
                        
                    }else{
                        cell?.nutritionUnitLabel.text = ""
                    }
                    if (nutritionValueArray.count > indexPath.row){//ml
//                        cell?.nutritionQuantityLabel.text = self.getDiplayValue(valueText: nutritionValueArray[indexPath.row])
                         cell?.nutritionQuantityLabel.text = nutritionValueArray[indexPath.row] as String
                    }else{
                        cell?.nutritionQuantityLabel.text = ""
                    }
                    return cell!
                    
                }else{
                    
                    let dictInfo = nutritionInfoArray[indexPath.row]
                    
                    if let nameLb = dictInfo["displayName"] as? String{
                        cell?.nutritionNameLabel.text = nameLb
                    } else {
                         cell?.nutritionNameLabel.text = ""
                    }
                    if let gmValue = dictInfo["per100gAsSoldDisplayValue"] as? String{
                        cell?.nutritionQuantityLabel.text = gmValue
                    } else {
                        cell?.nutritionQuantityLabel.text = ""
                    }
                    
                    if let mlValue = dictInfo["per100mlAsSoldDisplayValue"] as? String{
                        
                        cell?.nutritionUnitLabel.text = mlValue

                    } else {
                        cell?.nutritionUnitLabel.text = ""
                    }
                    
                    return cell!
                }
               
            }
    }
}

extension WSPdNutritionTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let cellSize = (UIScreen.main.bounds.width/3) - 20
    return CGSize(width: cellSize, height: (cellSize + 40))
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dachClaimInfoArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NutritionLogosCollectionViewCell", for: indexPath) as? NutritionLogosCollectionViewCell
    let dict = dachClaimInfoArray[indexPath.row]
    
    cell?.titleLable.text = dict["name"] as? String
    
    let keys = dackCliamImagesAndTitle.allKeys(forValue: (dict["name"] as? String)!)
    
    if keys.count > 0{
      cell?.nutritionLogoImageView.image = UIImage(named:keys[0])
    }else{
      cell?.nutritionLogoImageView.image = UIImage(named:"")
    }
    
    return cell!
  }
  
}

extension Dictionary where Value: Equatable {
  func allKeys(forValue val: Value) -> [Key] {
    return self.filter { $1 == val }.map { $0.0 }
  }
}
