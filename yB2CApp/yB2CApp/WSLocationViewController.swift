//
//  WSLocationViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit

class WSLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  var isFromMenu = false
  @IBOutlet weak var locationAndLanguageLabel: UILabel!
  @IBOutlet weak var selectLanguageTextLabel: UILabel!
  @IBOutlet weak var selectCountryTextLabel: UILabel!
  
  var languageList = [[String: Any]]()
  var countryList = [String]()
  var countryDetails = [[String:AnyObject]]()
  var selectedCountry : String = ""
  var selectedLanguage : String = ""
  
  var selectedCountryFlag : String = ""
  var sortedCountriesList = [[String: Any]]()
  @IBOutlet weak var countryTableView: UITableView!
  
  @IBAction func closeButtonLanguageTapped(_ sender: Any) {
    languageView.isHidden = true
    languageTableView.reloadData()
    translations()
  }
  @IBAction func goToBack(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  @IBOutlet var languageView: UIView!
  @IBOutlet weak var languageTableView: UITableView!
  @IBOutlet var countryView: UIView!
  @IBOutlet weak var locationTableView: UITableView!
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    countryView.isHidden = true
    locationTableView.reloadData()
    translations()
    
  }
  
  @IBAction func changeLanguagePressed(_ sender: Any) {
    
    self.getLanguagesForSelectedCountry()
    
    languageTableView.tableFooterView = UIView(frame: CGRect.zero)
    languageView.frame = UIScreen.main.bounds
    self.view.addSubview(languageView)
    languageView.isHidden = false
    languageTableView.isHidden = false
    
  }
  
  @IBAction func changeLocationPressed(_ sender: Any) {
    
    countryTableView.tableFooterView = UIView(frame: CGRect.zero)
    countryView.frame = UIScreen.main.bounds
    self.view.addSubview(countryView)
    countryView.isHidden = false
    countryTableView.isHidden = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    UISetUP()
    if let list = UserDefaults.standard.value(forKey: "CountryList") as? [[String : AnyObject]]{
        countryDetails = list
    }
    
    getSaveCountryAndLanguage()
    
    getCountryDetailFromCountry(CountryDetails: countryDetails)
    
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Location and Language Setting Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Location and Language Setting Screen")
    FireBaseTracker.ScreenNaming(screenName: "Location and Language Setting Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Location and Language Setting Screen")
  }
  //    override func viewWillAppear(_ animated: Bool) {
  //        WSUtility.addNavigationBarBackButton(controller: self)
  //    }
  func UISetUP()  {
    locationTableView.tableFooterView = UIView(frame: CGRect.zero)
    WSUtility.addNavigationBarBackButton(controller: self)
    translations()
  }
  func getSaveCountryAndLanguage(){
    for tmpDict in countryDetails{
      if let code1: String = UserDefaults.standard.value(forKey: "CountryCode") as? String, code1 != "" {
        if let code2 = tmpDict["country_code"] as? String, code1 == code2{
          selectedCountry = WSUtility.getlocalizedString(key:"\(tmpDict["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable")!
          selectedCountryFlag = "\(tmpDict["country_flag"]!)"
          var filterArray = [[String: Any]]()
          if let languageValue = tmpDict["language"] as? [[String: Any]]{
            let tpPredicate = NSPredicate(format: "language_code = %@ OR language_code = %@",UserDefaults.standard.value(forKey: "LanguageCode") as! String,"\(tmpDict["default_language_code"]!)")
            filterArray = languageValue.filter { tpPredicate.evaluate(with: $0) }
          }
          
          if filterArray.count > 0{
            print("Matched")
            for dict in filterArray{
                
                if dict["language_code"]as? String == UserDefaults.standard.value(forKey: "lang") as? String {
                    selectedLanguage = "\(dict["language_name"]!)"
                }
            }
          }
          break
        }
      }
    }
  }
  
  func getCountryDetailFromCountry(CountryDetails:[[String:AnyObject]]) {
    self.countryList.removeAll()
    //        for valuelist in CountryDetails
    //        {
    //            self.countryList.append(valuelist["country_name"] as! String)
    //        }
    translatedAndSortedListArray()
    //        if languageList.count == 0 {
    //            getLanguageDetailsFromCountry(CountryDetails: CountryDetails, Country: self.countryList.first!)
    //        }
    self.locationTableView.reloadData()
  }
  
  func getLanguageDetailsFromCountry(CountryDetails:[[String:AnyObject]],Country:String) {
    languageList.removeAll()
    
    for valuelist in sortedCountriesList
    {
      let cuntryName = valuelist["country_name"] as! String
      if cuntryName == Country {
        
        let languageValue = valuelist["language"] as! NSArray
        
        for values in languageValue {
          print("language value is \(values)")
          let value_dic = values as! NSDictionary
          //self.languageList.append(value_dic["language_name"] as! String)
        }
        self.languageTableView.reloadData()
        break
      }
      
    }
    self.languageTableView.reloadData()
  }
  
  func getLanguagesForSelectedCountry(){
    
    languageList.removeAll()
    var filterArray = [[String: Any]]()
    if let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String {
      let tpPredicate = NSPredicate(format: "country_code = %@",countryCode)
      filterArray = sortedCountriesList.filter { tpPredicate.evaluate(with: $0) }
    }
    
    if filterArray.count > 0{
      print("Matched")
      let dict = filterArray[0]
      if let list = dict["language"] as? [[String: Any]]{
        languageList = list
      }
    }
    self.languageTableView.reloadData()
  }
  func translatedAndSortedListArray(){
    
    var tmpArray = [[String: Any]]()
    for tdict in countryDetails{
      var tmpDict = tdict
      tmpDict["translatedCountryName"] = WSUtility.getlocalizedString(key:"\(tdict["country_name"]!)", lang:WSUtility.getLanguage(), table: "Localizable") as AnyObject
      tmpArray.append(tmpDict)
    }
    
    let sortedArray = tmpArray.sorted {($0["translatedCountryName"] as! String) < ($1["translatedCountryName"] as! String) }
    self.sortedCountriesList = sortedArray
  }
  
  func translations()  {
    locationAndLanguageLabel.text = WSUtility.getlocalizedString(key: "Location and Language", lang: WSUtility.getLanguage(), table: "Localizable")
    selectLanguageTextLabel.text = WSUtility.getlocalizedString(key: "Select language", lang: WSUtility.getLanguage(), table: "Localizable")
    selectCountryTextLabel.text = WSUtility.getlocalizedString(key: "Select a country", lang: WSUtility.getLanguage(), table: "Localizable")
    
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if(tableView == locationTableView )
    {
      if indexPath.row == 0 {
        let cell:WSLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLocationTableViewCell") as! WSLocationTableViewCell
        
        cell.textLabel?.font = UIFont(name:"DINPro-Regular", size: 16.0)
        cell.locationLabel.text = selectedCountry
        cell.updateCellContent()
        return cell
      }
      if indexPath.row == 1 {
        let cell:WSLanguageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WSLanguageTableViewCell") as! WSLanguageTableViewCell
        cell.textLabel?.font = UIFont(name:"DINPro-Regular", size: 16.0)
        cell.countryImage.sd_setImage(with: URL(string: selectedCountryFlag), placeholderImage: UIImage(named: ""))
        cell.languageLabel.text = selectedLanguage
        cell.updateCellContent()
        return cell
      }
    }
    if(tableView == countryTableView ){
      let notifyCell: NotificationCell = countryTableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
      
      let tmpDict = sortedCountriesList[indexPath.row]
      
      notifyCell.discriptionLabel.text = "\(tmpDict["translatedCountryName"]!)"
      
      if let code1: String = UserDefaults.standard.value(forKey: "CountryCode") as? String, code1 != "" {
        if let code2 = tmpDict["country_code"] as? String, code1 == code2{
          selectedCountryFlag = "\(tmpDict["country_flag"]!)"
          selectedCountry = "\(tmpDict["translatedCountryName"]!)"
          notifyCell.discriptionLabel.textColor = UIColor.init(red: 255/255.0, green: 90/255.0, blue: 0, alpha: 1.0)
          notifyCell.rightIndicatorImage.isHidden = false
        }
        else{
          notifyCell.discriptionLabel.textColor = UIColor.black
          notifyCell.rightIndicatorImage.isHidden = true
        }
      }
      else{
        notifyCell.discriptionLabel.textColor = UIColor.black
        notifyCell.rightIndicatorImage.isHidden = true
      }
      
      return notifyCell
    }
    if(tableView == languageTableView ){
      let notifyCell: NotificationCell = languageTableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
      
      let tmpDict = languageList[indexPath.row]
      
      notifyCell.discriptionLabel.text = "\(tmpDict["language_name"]!)"
      
      if let code1: String = UserDefaults.standard.value(forKey: "LanguageCode") as? String, code1 != "" {
        if let code2 = tmpDict["language_code"] as? String, code1 == code2{
          selectedLanguage = "\(tmpDict["language_name"]!)"
          notifyCell.discriptionLabel.textColor = UIColor.init(red: 255/255.0, green: 90/255.0, blue: 0, alpha: 1.0)
          notifyCell.rightIndicatorImage.isHidden = false
        }
        else{
          notifyCell.discriptionLabel.textColor = UIColor.black
          notifyCell.rightIndicatorImage.isHidden = true
        }
      }
      else{
        notifyCell.discriptionLabel.textColor = UIColor.black
        notifyCell.rightIndicatorImage.isHidden = true
      }
      
      return notifyCell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(tableView == countryTableView){
      return sortedCountriesList.count
    }
    else if(tableView == languageTableView){
      return languageList.count
    }
    return 2
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView == locationTableView{
      return 80
    }
    return 50
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if(tableView == countryTableView){
      
        if isFromMenu{
            let appDelegate = UIApplication.shared.delegate as! HYBAppDelegate
            let dc = AppSettingsViewController()
            dc.logOutPressed(self)
//            return
        }
        
      if let dict = sortedCountriesList[indexPath.row] as? [String: Any]{
        
        selectedCountry = "\(dict["translatedCountryName"]!)"
        selectedCountryFlag = "\(dict["country_flag"]!)"
        UserDefaults.standard.set("\(dict["country_name"]!)", forKey: "SelectedLocation")
        UserDefaults.standard.set("\(dict["country_code"]!)", forKey: "CountryCode")
        UserDefaults.standard.set("ufs-\(dict["country_code"]!)", forKey: "Site")
        
        AdjustTracking.configureAdjustForTurkey()
        let defalutLang: String = "\(dict["default_language_code"]!)"
        
        if checkLanguageWithAppLanguages(langCode: defalutLang){
          UserDefaults.standard.set(defalutLang, forKey: "lang")
          UserDefaults.standard.set(defalutLang, forKey: "LanguageCode")
        }
        else{
          UserDefaults.standard.set("en", forKey: "lang")
          UserDefaults.standard.set("en", forKey: "LanguageCode")
        }
        
        var filterArray = [[String: Any]]()
        if let languageValue = dict["language"] as? [[String: Any]]{
          let tpPredicate = NSPredicate(format: "language_code = %@",defalutLang)
          filterArray = languageValue.filter { tpPredicate.evaluate(with: $0) }
        }
        
        if filterArray.count > 0{
          let dict = filterArray[0]
          selectedLanguage = "\(dict["language_name"]!)"
        }
      }        
     
      self.getLanguagesForSelectedCountry()
      self.enableDisableFeature()
      self.translatedAndSortedListArray()
      UISetUP()
      countryTableView.reloadData()
        
    }
    
    if(tableView == languageTableView){
      
      if let dict = languageList[indexPath.row] as? [String: Any]{
        selectedLanguage = "\(dict["language_name"]!)"
        
        let selectedLangCode = "\(dict["language_code"]!)"
        if checkLanguageWithAppLanguages(langCode: selectedLangCode){
          UserDefaults.standard.set(selectedLangCode, forKey: "lang")
          UserDefaults.standard.set(selectedLangCode, forKey: "LanguageCode")
        }
        else{
          UserDefaults.standard.set("en", forKey: "lang")
          UserDefaults.standard.set("en", forKey: "LanguageCode")
        }
      }
        if let list = UserDefaults.standard.value(forKey: "CountryList") as? [[String : AnyObject]]{
            countryDetails = list
        }
        
        getSaveCountryAndLanguage()
        
        getCountryDetailFromCountry(CountryDetails: countryDetails)
        
      //languageTableView.reloadData()
        UISetUP()
      closeButtonLanguageTapped(sender: UIButton())
        countryTableView.reloadData()
    }
    closeButtonTapped(sender: UIButton())
    locationTableView.reloadData()
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


    func enableDisableFeature() {
        let webservice = WSWebServiceBusinessLayer()
        webservice.featureEnableDisableForcountries(success: { (response) in
          
        }) { (error) in
            //Error
        }
    }
    
}



