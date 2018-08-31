//
//  WSSelectCountry.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 08/11/17.
//

import UIKit
import Adjust

class WSSelectCountry: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var mTableView: UITableView!
  @IBOutlet weak var mCountryView: UIView!
  @IBOutlet weak var mCountryTF: UITextField!
  
  @IBOutlet weak var whereDoLiveLabel: UILabel!
  @IBOutlet weak var selectCountryLabel: UILabel!
  @IBOutlet weak var requiredLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var selectpopUpLabel: UILabel!
  
  @IBOutlet weak var rightIconImageView: UIImageView!
  
  var currentLanguage = ""
    var DeviceCountryName = ""
  
  var countryListResonse: [String: Any] = [:]
  
  var sortedCountriesList = [[String: Any]]()
  //  var countryList = [WSUtility.getTranslatedString(forString: "Austria")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
    
    
    
    if let lang: String = UserDefaults.standard.value(forKey: "lang") as? String, lang != "" {
      currentLanguage = lang
    } else{
      if let Devicelang = UserDefaults.standard.value(forKey: "DeviceLanguage"){
        currentLanguage = Devicelang as! String
      }
    }
    
    DeviceCountryName = NSLocale.current.regionCode!
    
    
    
    mTableView.tableFooterView = UIView(frame: CGRect.zero)
    mCountryView.frame = UIScreen.main.bounds
    self.view.addSubview(mCountryView)
    mCountryView.isHidden = true
    
    WSUtility.UISetUpForTextField(textField: mCountryTF, withBorderColor:UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor)
    mCountryTF.setLeftPaddingPoints(10)
  
    self.updateUIForSelectingLanguage()
    // Do any additional setup after loading the view.


  }
  
  override func viewDidAppear(_ animated: Bool) {
    FetchLanguageAndCountry()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func getCountryList() -> String {
    let localIdentifier = Locale.current.identifier //returns identifier of your telephones country/region settings
    
    let locale = NSLocale(localeIdentifier: localIdentifier)
    //if u want a special identifier use that
    //let locale = NSLocale(localeIdentifier: "en_US")
    if let countryCode = locale.object(forKey: .countryCode) as? String {
      
      if let country:String = locale.displayName(forKey: .countryCode, value: countryCode) {
        print(country)
        return country
      }
    }
    
    return ""
  }
  
  func updateUIForSelectingLanguage(){
    requiredLabel.text = WSUtility.getlocalizedString(key:"Country selector", lang:WSUtility.getLanguage(), table: "Localizable")
    selectpopUpLabel.text = WSUtility.getlocalizedString(key:"Country selector", lang:WSUtility.getLanguage(), table: "Localizable")
    
    mCountryTF.placeholder = WSUtility.getlocalizedString(key: "Select your country", lang: WSUtility.getLanguage(), table: "Localizable")
    nextButton.setTitle(WSUtility.getlocalizedString(key:"Continue", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
    let tmpDict = sortedCountriesList[indexPath.row]
    
    cell.discriptionLabel.text = "\(tmpDict["translatedCountryName"]!)"
    
    if let code1: String = UserDefaults.standard.value(forKey: "CountryCode") as? String, code1 != "" {
      if let code2 = tmpDict["country_code"] as? String, code1 == code2{
        cell.discriptionLabel.textColor = UIColor.init(red: 255/255.0, green: 90/255.0, blue: 0, alpha: 1.0)
        cell.rightIndicatorImage.isHidden = false
      }
      else{
        cell.discriptionLabel.textColor = UIColor.black
        cell.rightIndicatorImage.isHidden = true
      }
    }
    else{
      cell.discriptionLabel.textColor = UIColor.black
      cell.rightIndicatorImage.isHidden = true
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedCountriesList.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let dict = sortedCountriesList[indexPath.row] as? [String: Any]{
      self.currentLanguage = "\(dict["default_language_code"]!)"
      
      UserDefaults.standard.set("\(dict["country_name"]!)", forKey: "SelectedLocation")
      UserDefaults.standard.set("\(dict["country_code"]!)", forKey: "CountryCode")
      UserDefaults.standard.set("ufs-\(dict["country_code"]!)", forKey: "Site")
      
      if checkLanguageWithAppLanguages(langCode: self.currentLanguage){
        UserDefaults.standard.set(self.currentLanguage, forKey: "lang")
        UserDefaults.standard.set(self.currentLanguage, forKey: "LanguageCode")
      }
      else{
        UserDefaults.standard.set("en", forKey: "lang")
        UserDefaults.standard.set("en", forKey: "LanguageCode")
      }
      self.mCountryTF.text = WSUtility.getlocalizedString(key:"\(dict["translatedCountryName"]!)", lang:WSUtility.getLanguage(), table: "Localizable")
    }
    
    self.translatedAndSortedListArray()
    
    self.updateUIForSelectingLanguage()
    closeButtonAction(sender: UIButton())
    
    self.nextButton.isEnabled = true
    mTableView.reloadData()
  }
  
  func checkLanguageWithAppLanguages(langCode: String)-> Bool{
    var isFound: Bool = false
    let appLanguages:[String] = Bundle.main.localizations
    let foundLanguages = appLanguages.filter() { $0 == langCode }
    if foundLanguages.count > 0{
      isFound = true
    }
    else{
      isFound = false
    }
    return isFound
  }
  @IBAction func selectCountryButtonAction(sender: UIButton){
    if self.countryListResonse.count == 0{
      FetchLanguageAndCountry()
    }
    mCountryView.isHidden = false
  }
  
  @IBAction func nextButtonAction(sender: UIButton){
    // save country value
    
    UFSGATracker.gaIntializer()
    FireBaseTracker.firebaseTrackerConfig()
    
    AdjustTracking.configureAdjustForTurkey()
    
    if mCountryTF.text != ""{
      UserDefaults.standard.set(true, forKey: "CountryAndLanguageSelected")
      // let appdelegte = UIApplication.shared.delegate as!HYBAppDelegate
      // appdelegte.moveToLoginScreen()
      
      self.performSegue(withIdentifier: "SignInVC", sender: self)
    }
    else{
      // UFSUtility.showAlertWith(message:UFSUtility.getlocalizedString(key:"Select a country", lang:UFSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
    }
    
  }
  
  @IBAction func closeButtonAction(sender: UIButton){
    mCountryView.isHidden = true
    if let code1: String = UserDefaults.standard.value(forKey: "CountryCode") as? String, code1 != "" {
      let tpPredicate = NSPredicate(format: "country_code = %@",code1)
      let filterArray = sortedCountriesList.filter { tpPredicate.evaluate(with: $0) }
      if filterArray.count > 0{
        let dict = filterArray[0]
        self.mCountryTF.text = WSUtility.getlocalizedString(key:"\(dict["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable")
      }
    }
    
    rightIconImageView.image = UIImage(named:"checked_Icon")
    
    if self.mCountryTF.text != ""{
      rightIconImageView.isHidden = false
    }
    else{
      rightIconImageView.isHidden = true
    }
    
  }
  
  func FetchLanguageAndCountry() {

    UFSProgressView.showWaitingDialog("")
    let webservice = WSWebServiceBusinessLayer()
    webservice.getCountryAndLanguage(success: {(respone) in
      
      UFSProgressView.stopWaitingDialog()
      guard let _ = respone["data"] as? [String: Any] else{
        return
      }
      
      self.countryListResonse = respone["data"] as! [String: Any]
      let  county  = self.countryListResonse["country_list"] as! [[String:Any]]
      
       UserDefaults.standard.set(county, forKey: "CountryList")
        var isCountryEqualsToDeviceLocation = false
         let CountryCodeList = county.map({$0["country_code"] as! String})
        if CountryCodeList.contains(self.DeviceCountryName.lowercased()) {
            isCountryEqualsToDeviceLocation = true
        }

        var count = 0
      for valuelist in county {
        var filterArray = [[String: Any]]()
        if let languageValue = valuelist["language"] as? [[String: Any]]{
          let tpPredicate = NSPredicate(format: "language_code = %@",self.currentLanguage)
          filterArray = languageValue.filter { tpPredicate.evaluate(with: $0) }
        }
        
        if filterArray.count > 0{
            
            if isCountryEqualsToDeviceLocation == true {
                if ("\(valuelist["country_code"]!)" == self.DeviceCountryName.lowercased()) {
                self.mCountryTF.text = WSUtility.getlocalizedString(key:"\(valuelist["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable")
                self.nextButton.isEnabled = true
                
                UserDefaults.standard.set("\(valuelist["country_name"]!)", forKey: "SelectedLocation")
                UserDefaults.standard.set("\(valuelist["country_code"]!)", forKey: "CountryCode")
                UserDefaults.standard.set("ufs-\(valuelist["country_code"]!)", forKey: "Site")
                
                if self.checkLanguageWithAppLanguages(langCode: self.currentLanguage){
                    UserDefaults.standard.set(self.currentLanguage, forKey: "lang")
                    UserDefaults.standard.set(self.currentLanguage, forKey: "LanguageCode")
                } else {
                    UserDefaults.standard.set("en", forKey: "lang")
                    UserDefaults.standard.set("en", forKey: "LanguageCode")
                    }
                    break;
                }
            } else {
                print("Matched")
                self.mCountryTF.text = WSUtility.getlocalizedString(key:"\(valuelist["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable")
                self.nextButton.isEnabled = true
                
                UserDefaults.standard.set("\(valuelist["country_name"]!)", forKey: "SelectedLocation")
                UserDefaults.standard.set("\(valuelist["country_code"]!)", forKey: "CountryCode")
                UserDefaults.standard.set("ufs-\(valuelist["country_code"]!)", forKey: "Site")
                
                if self.checkLanguageWithAppLanguages(langCode: self.currentLanguage){
                    UserDefaults.standard.set(self.currentLanguage, forKey: "lang")
                    UserDefaults.standard.set(self.currentLanguage, forKey: "LanguageCode")
                }
                else{
                    UserDefaults.standard.set("en", forKey: "lang")
                    UserDefaults.standard.set("en", forKey: "LanguageCode")
                }
                break
            }
            
          
        }
        else{
          UserDefaults.standard.set("en", forKey: "lang")
          UserDefaults.standard.set("en", forKey: "LanguageCode")
        }
        
        count = count+1
      }
      
      self.translatedAndSortedListArray()
      self.closeButtonAction(sender: UIButton())
      if self.mCountryTF.text != ""{
        self.nextButton.isEnabled = true
      }
      
      self.updateUIForSelectingLanguage()
      self.mTableView.reloadData()
      
    }, failure:{(failure) in
      UFSProgressView.stopWaitingDialog()
    })
  }
  
  func translatedAndSortedListArray(){
    
    var tmpArray = [[String: Any]]()
    let county  = self.countryListResonse["country_list"] as! [[String:Any]]
    
  //  let languageDict = [["language_code":"de","language_country":"Duitsland","language_name":"German"]]
    
   // county = [["country_code":"at","country_flag":"https://techstage.nl/ufsapp_global/assets/images/country_flag/at.png","country_name":"Austria","default_language_code":"de","language":languageDict]]
    
    for tdict in county{
      var tmpDict = tdict
      tmpDict["translatedCountryName"] = WSUtility.getlocalizedString(key:"\(tdict["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable")
      tmpArray.append(tmpDict)
    }
    
    let sortedArray = tmpArray.sorted {($0["translatedCountryName"] as! String) < ($1["translatedCountryName"] as! String) }
    self.sortedCountriesList = sortedArray
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}


