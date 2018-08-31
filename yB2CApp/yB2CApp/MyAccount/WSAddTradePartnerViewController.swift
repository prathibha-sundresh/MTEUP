//
//  WSAddTradePartnerViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/29/17.
//

import UIKit

protocol WSAddTradePartnerViewControllerDelegate {
    func reloadTradePartnerAPI(isDefalut: Bool)
}
class WSAddTradePartnerViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var addTradepartnerButton: UIButton!
    @IBOutlet weak var makeThisDefaultLabel: UILabel!
    @IBOutlet weak var entertradepartnerAccNumberLabel: UILabel!
    @IBOutlet weak var addanotherTradePartnerLabel: UILabel!
    @IBOutlet weak var tradePartnerCityTF: UITextField!
    @IBOutlet weak var tradePartnerName: UITextField!
    @IBOutlet weak var tradePartnerLocation: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var makeDefaultButton: UIButton!
    
    @IBOutlet weak var tradePartnerCityH: NSLayoutConstraint!
    @IBOutlet weak var tradePartnerNameY: NSLayoutConstraint!
    
    @IBOutlet weak var dropDown_TradePartnerCityButton: UIButton!
    @IBOutlet weak var dropDown_TradePartnerNameButton: UIButton!
    @IBOutlet weak var dropDown_TradePartnerLocationButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var vendorListArray:[[String: Any]] = []
    var TPListArray:[[String: Any]] = []
    var pickerArray:[[String: Any]] = []
    var TPLocationArray:[[String: Any]] = []
    var TpOrLocationFlag = 0
    var selectedIndexForTP: Int = 0
    var selectedIndexForLocation: Int = 0
    var ecomUserID: String = ""
    var isFromLocationPicker: Bool = false
    var isUpdateMode: Bool = false
    var updateDict: [String: Any] = [:]
    var userTradePartnerResponse: [String: Any] = [:]
    var pickerCityList: [String] = []
    var delegate: WSAddTradePartnerViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tradePartnerCityTF.placeholder = WSUtility.getlocalizedString(key: "Trade Partner City", lang: WSUtility.getLanguage())
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        self.hideKeyboardWhenTappedAround()
      
        // Do any additional setup after loading the view.
        addanotherTradePartnerLabel.text = WSUtility.getlocalizedString(key: "Add another Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        addTradepartnerButton.setTitle(WSUtility.getlocalizedString(key: "Add new Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        makeThisDefaultLabel.text = WSUtility.getlocalizedString(key: "Make this my default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        entertradepartnerAccNumberLabel.text = WSUtility.getlocalizedString(key: "Enter Your Trade Partner Account Number", lang: WSUtility.getLanguage(), table: "Localizable")
        
        cancelButton.setTitle("\(WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage(), table: "Localizable")!) X", for: .normal)
        
        tradePartnerName.placeholder = WSUtility.getlocalizedString(key: "Trade partner name", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        tradePartnerLocation.placeholder = WSUtility.getlocalizedString(key: "Trade partner location", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        accountNumber.placeholder = WSUtility.getlocalizedString(key: "Trade Partner's Account Number", lang: WSUtility.getLanguage(), table: "Localizable")?.uppercased()
        self.setUI()
        
        if WSUtility.isLoginWithTurkey(){
            // for time being purpose: Ram
            if self.isUpdateMode{
                WSUtility.UISetUpForTextField(textField: tradePartnerCityTF, withBorderColor: UIColor.clear.cgColor)
                WSUtility.UISetUpForTextField(textField: tradePartnerName, withBorderColor: UIColor.clear.cgColor)
                WSUtility.UISetUpForTextField(textField: tradePartnerLocation, withBorderColor: UIColor.clear.cgColor)
                dropDown_TradePartnerCityButton.isHidden = true
                dropDown_TradePartnerNameButton.isHidden = true
                dropDown_TradePartnerLocationButton.isHidden = true
            }
        }
        
      print("Viewdidload")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func makeDefaultButton_Click(_ sender: Any) {
        if !makeDefaultButton.isSelected{
            makeDefaultButton.isSelected = true
        }
        else{
            makeDefaultButton.isSelected = false
        }
    }
    func setUI(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        
        if WSUtility.isLoginWithTurkey(){
            self.getVendorCitesList()
        }
        else{
            businessLayer.getTradePartenersList(successResponse: { (response) in
                if let array = response as? [[String: Any]]{
                    self.TPListArray = array
                    self.pickerArray = array
                    if self.isUpdateMode{
                        var checkTpIsThere: Bool = false
                        for index in 0 ..< self.TPListArray.count {
                            let tmpDict = self.TPListArray[index]
                            if tmpDict["id"] as? Int == self.updateDict["parentTradePartnerId"] as? Int {
                                self.selectedIndexForTP = index
                                checkTpIsThere = true
                                break
                            }
                            else{
                                checkTpIsThere = false
                            }
                        }
                        if !checkTpIsThere{
                            let defalutTradePartnerID = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID)
                            let tpIds = self.TPListArray.map({$0["id"]! as! Int})
                            if let index = tpIds.index(of: Int(defalutTradePartnerID)!){
                                self.selectedIndexForTP = index
                            }
                        }
                    }
                    
                    UFSProgressView.stopWaitingDialog()
                }
            }) { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
            }
        }
        self.view.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.7)
        tradePartnerCityTF.setLeftPaddingPoints(10)
        tradePartnerName.setLeftPaddingPoints(10)
        tradePartnerLocation.setLeftPaddingPoints(10)
        accountNumber.setLeftPaddingPoints(10)
        
        WSUtility.UISetUpForTextField(textField: tradePartnerCityTF, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        WSUtility.UISetUpForTextField(textField: tradePartnerName, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        WSUtility.UISetUpForTextField(textField: tradePartnerLocation, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        WSUtility.UISetUpForTextField(textField: accountNumber, withBorderColor: UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor)
        makeDefaultButton.layer.borderWidth = 1.0
        makeDefaultButton.layer.borderColor = UIColor(red: 183.0/255.0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1.0).cgColor
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        if isUpdateMode{
            makeDefaultButton.isUserInteractionEnabled = false
            addTradepartnerButton.tag = 101
            addTradepartnerButton.setTitle(WSUtility.getlocalizedString(key: "Save Changes", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            
            
            if WSUtility.isLoginWithTurkey(){
                let infoDict: [String: Any] = updateDict
                accountNumber.text = "\(infoDict["customerNumber"] ?? "")"
                
                if let dict = infoDict["assignedVendor"] as? [String: Any]{
                    tradePartnerName.text = "\(dict["name"] ?? "")"
                }
                
                if let tradePartnerDict = infoDict["assignedVendorAddress"] as? [String: Any]{
                    tradePartnerLocation.text = "\(tradePartnerDict["locationName"] ?? "")"
                    tradePartnerCityTF.text = "\(tradePartnerDict["town"] ?? "")"
                }
                self.ecomUserID = "\(infoDict["code"] ?? "")"
            }
            else{
                
                if let ptpTmpDict = updateDict["parentTradePartner"] as? [String: Any]{
                    tradePartnerName.text = "\(ptpTmpDict["name"]!)"
                }
                else{
                    tradePartnerName.text = WSUtility.getValueFromString(stringValue: UserDefaults.standard.value(forKey: "tradePartnerName"))
                }
                if let tpTmpDict = updateDict["tradePartner"] as? [String: Any]{
                    tradePartnerLocation.text = "\(tpTmpDict["name"]!)"
                }
                
                if let clientNo = updateDict["clientNumber"] as? String{
                    accountNumber.text = "\(clientNo)"
                }
                if let Id = updateDict["parentTradePartnerId"] as? Int{
                    getTPLocation(parentTPID: Id, isShowHide: true)
                }
                
                let userProfile_clientNumber = updateDict["clientNumber"] as? Int
                let userProfile_parentTradePartnerId = updateDict["parentTradePartnerId"] as? Int
                let userProfile_TradePartnerId = updateDict["tradePartnerId"] as? Int
                
                if let array = updateDict["userProfileTradePartners"] as? [[String : Any]]{
                    for infoDict in array{
                        if infoDict["parentTradePartnerId"]as? Int == userProfile_parentTradePartnerId{
                            if infoDict["tradePartnerId"]as? Int == userProfile_TradePartnerId{
                                if userProfile_clientNumber == infoDict["clientNumber"] as? Int{
                                    self.ecomUserID = "\(infoDict["id"]!)"
                                }
                            }
                        }
                    }
                    
                }
                
            }
            if isUpdateMode{
                makeDefaultButton.isSelected = true
            }
            serviceBussinessLayer.trackingScreens(screenName: "Update Trade Partner Screen")
            UFSGATracker.trackScreenViews(withScreenName: "Update Trade Partner Screen")
            FireBaseTracker.ScreenNaming(screenName: "Update Trade Partner Screen", ScreenClass: String(describing: self))
            FBSDKAppEvents.logEvent("Update Trade Partner Screen")
            
        }
        else{
            
            serviceBussinessLayer.trackingScreens(screenName: "Add Trade Partner Screen")
            UFSGATracker.trackScreenViews(withScreenName: "Add Trade Partner Screen")
            FireBaseTracker.ScreenNaming(screenName: "Add Trade Partner Screen", ScreenClass: String(describing: self))
            FBSDKAppEvents.logEvent("Add Trade Partner Screen")
            makeDefaultButton.isUserInteractionEnabled = true
            addTradepartnerButton.tag = 100
        }
        
        if !WSUtility.isLoginWithTurkey(){
            tradePartnerCityH.constant = 0
            tradePartnerNameY.constant = 0
        }
        else{
            tradePartnerCityH.constant = 50
            tradePartnerNameY.constant = 14
        }
    }

    /* Add,get,update user vendor details for turkey
     1. get vendor cities
     2. creating vendor for user
     3. update UserProfileVendor
     */
    func getVendorCitesList(){
        UFSProgressView.showWaitingDialog("")
        let businesslayer =  WSWebServiceBusinessLayer()
        businesslayer.getVendorsList(successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            
            if let vendorList = response["vendorList"] as? [[String: Any]]{
                
                var filteredArray: [[String: Any]] = []
                for dict in vendorList{
                    if let tmpArry = dict["vendorAddress"] as? [[String: Any]], tmpArry.count > 0{
                        filteredArray.append(dict)
                    }
                }
                self.vendorListArray = filteredArray
                var cityListArray:[String] = []
                
                for dict in filteredArray{
                    if let array = dict["vendorAddress"] as? [[String: Any]], array.count > 0{
                        let cities = array.map({$0["town"] as! String})
                        let upperCaseCities = cities.map { $0.uppercased()}
                        cityListArray.append(contentsOf: upperCaseCities)
                    }
                }
                let unique = Array(Set(cityListArray))
                let sortedArray = unique.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                self.pickerCityList = sortedArray

            }
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func createVendorToUserForTurkey(dict: [String: Any]){
        
        UFSProgressView.showWaitingDialog("")
        let businesslayer =  WSWebServiceBusinessLayer()
        businesslayer.addVendorToUser(params: dict, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            self.delegate?.reloadTradePartnerAPI(isDefalut: self.makeDefaultButton.isSelected)
            self.dismiss(animated: true, completion: nil)
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func updateUserVendorProfile_Turkey(){
        UFSProgressView.showWaitingDialog("")
        let reqestDict:[String: Any] = ["makeDefalut": true,"accountNumber":accountNumber.text!,"myProfileVendorCode" : self.ecomUserID]
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.updateUserProfileVendorToUser(params: reqestDict, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            self.delegate?.reloadTradePartnerAPI(isDefalut: self.makeDefaultButton.isSelected)
            self.dismiss(animated: true, completion: nil)
        }, failureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    @IBAction func closeButton_click(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTPAndLocationButtonAction(sender: UIButton){
        if WSUtility.isLoginWithTurkey(){
            // for time being purpose: Ram
            if isUpdateMode{
                return
            }
        }
        
        accountNumber.resignFirstResponder()
        
        if self.TPListArray.count == 0{
            return
        }
        
        if sender.tag == 1000{
            
            isFromLocationPicker = false
            self.pickerArray = self.TPListArray
            TpOrLocationFlag = 0
            self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
        }
        else{
            
            isFromLocationPicker = true
            
            if TpOrLocationFlag == 0{
                
                let dict = TPListArray[selectedIndexForTP]
                if WSUtility.isLoginWithTurkey(){
                    tradeLocationFromVendorList_TR(isShowHide: false)
                }
                else{
                    getTPLocation(parentTPID: dict["id"] as! Int, isShowHide: false)
                }
                
            }
            else{
              print("picker data removed")
                pickerArray.removeAll()
                pickerArray = TPLocationArray
                self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
            }
        }
    
    }
    
    @IBAction func selectVendorCityButtonAction(sender: UIButton){
        if WSUtility.isLoginWithTurkey(){
            // for time being purpose: Ram
            if isUpdateMode{
                return
            }
        }
        TpOrLocationFlag = 2
        pickerArray.removeAll()
        self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
    }
    
    func getTPLocation(parentTPID: Int,isShowHide: Bool){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.gettradepartnersLocationListRequest(parentTPID:"\(parentTPID)", successResponse: { (response) in
            if let array = response as? [[String: Any]]{
              
              print("picker data removed")
                self.TPLocationArray.removeAll()
                self.pickerArray.removeAll()
                self.TPLocationArray = array
                self.pickerArray = self.TPLocationArray
                self.TpOrLocationFlag = 1
                if !isShowHide{
                    self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
                }
                for index in 0 ..< self.TPLocationArray.count {
                    let tmpDict = self.TPLocationArray[index]
                    if tmpDict["id"] as? Int == self.updateDict["tradePartnerId"] as? Int {
                        self.selectedIndexForLocation = index
                        break
                    }
                }
            }
            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func tradeLocationFromVendorList_TR(isShowHide: Bool){
        
        self.TPLocationArray.removeAll()
        self.pickerArray.removeAll()
        self.TpOrLocationFlag = 1
        
        if let dict = TPListArray[selectedIndexForTP] as? [String: Any]{
            if let locations = dict["vendorAddress"] as? [[String: Any]]{
                var tmpArray: [[String: Any]] = []
                for tmpDict in locations{
                    if let valueStr = tmpDict["town"] as? String, valueStr.uppercased() == self.tradePartnerCityTF.text!{
                        tmpArray.append(tmpDict)
                    }
                }
                self.TPLocationArray = tmpArray
                self.pickerArray = self.TPLocationArray
            }
        }
        if !isShowHide{
            self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
        }
    }
    
    @IBAction func addTradePartnerClick(sender: UIButton){
        
        var isFieldsEmpty: Bool = false
        
        
        let tpName: String? = tradePartnerName.text
        let tpLocation : String? = tradePartnerLocation.text
        let tpAccount : String? = accountNumber.text
        
        if WSUtility.isLoginWithTurkey(){
            let tpCity: String? = tradePartnerCityTF.text
            if tpCity == "" {
                
                UISetUpForTextFieldWithImage(textField: tradePartnerCityTF, boolValue: true)
                isFieldsEmpty = true
            }
        }

        if tpName == "" {
            
            UISetUpForTextFieldWithImage(textField: tradePartnerName, boolValue: true)
            //tradePartnerName.rightView?.isHidden = true
            isFieldsEmpty = true
        }
        
        if tpLocation == "" {
            
            UISetUpForTextFieldWithImage(textField: tradePartnerLocation, boolValue: true)
            //tradePartnerLocation.rightView?.isHidden = true
            isFieldsEmpty = true
        }
        if tpAccount == "" {
            
            UISetUpForAccountNoTextFieldWithImage(textField: accountNumber, boolValue: true)
            isFieldsEmpty = true
        }
        
        if !isFieldsEmpty{
            
            
            if WSUtility.isLoginWithTurkey(){
                if isUpdateMode{
                    self.updateUserVendorProfile_Turkey()
                }
                else{
                    let dict1 = TPListArray[selectedIndexForTP]
                    let dict2 = TPLocationArray[selectedIndexForLocation]
                    let requestDict = ["parentTpId": "\(dict1["code"] ?? "")","tplocationID": "\(dict2["locationId"] ?? "")","accountNumber": accountNumber.text!,"makeDefalut": makeDefaultButton.isSelected] as [String : Any]
                    self.createVendorToUserForTurkey(dict: requestDict)
                }
                return
            }
            
            
            let dict1 = TPListArray[selectedIndexForTP]
            let dict2 = TPLocationArray[selectedIndexForLocation]
            // this is for to check existing TradeParnter
            var parentTPId: Int = 0
            var childTPId: Int = 0
            if let id = dict1["id"] as? Int{
                parentTPId = id
            }
            if let id = dict2["id"] as? Int{
                childTPId = id
            }
            if self.checkExistingTradeParnter(parentTPId: parentTPId, childTPId: childTPId, accountNumber: accountNumber.text!){
                return
            }
            
            let reqestDict:[String: Any] = ["makeDefalut": makeDefaultButton.isSelected,"parentTpId":"\(dict1["id"]!)","tplocationID":"\(dict2["id"]!)","accountNumber":accountNumber.text!,"ecomUserTPId": isUpdateMode ? ecomUserID: ""]
            
            UFSProgressView.showWaitingDialog("")
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.createOrUpdateOrMakeDefalutTradePartner(parameter: reqestDict, methodName: "", successResponse: { (response) in
                UFSProgressView.stopWaitingDialog()
                self.delegate?.reloadTradePartnerAPI(isDefalut: self.makeDefaultButton.isSelected)
                self.dismiss(animated: true, completion: nil)
            }, faliureResponse: { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func checkExistingTradeParnter(parentTPId: Int,childTPId: Int, accountNumber: String)->Bool{
        // this is for to check existing TradeParnter
        let tpPredicate = NSPredicate(format: "parentTradePartnerId = %d AND tradePartnerId = %d AND clientNumber = %@",parentTPId,childTPId,accountNumber)
        var isBool: Bool = false
        if let array = userTradePartnerResponse["userProfileTradePartners"] as? [[String : Any]]{
            let filterArray = array.filter { tpPredicate.evaluate(with: $0) }
            if filterArray.count > 0{
                print("Matched")
                WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "This trade partner is already on your list!", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
                isBool = true
            }
            else{
                print("Not matched")
                isBool = false
            }
        }
        return isBool
    }
    
    func UISetUpForTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: -60, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text != "" {
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
            }
            
            rightView.addSubview(checkedImage)
            textField.rightView = rightView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        else{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
        
    }
    func UISetUpForAccountNoTextFieldWithImage(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            if textField.text?.count == 12{
                checkedImage.image = #imageLiteral(resourceName: "checked_Icon")
                textField.layer.borderColor = unselectedTextFieldBorderColor
            }
            else{
                checkedImage.image = #imageLiteral(resourceName: "error_icon")
                textField.layer.borderColor = selectedTextFieldBorderColor
            }
            
            rightView.addSubview(checkedImage)
            textField.rightView = rightView
            textField.rightViewMode = UITextFieldViewMode.always
        }
        else{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is UFSPopUpViewController {
            
            let popUpVC = segue.destination as! UFSPopUpViewController
            
            popUpVC.titleString = (TpOrLocationFlag == 0) ? "Select tradepartner" : "Select tradepartner location"
            popUpVC.isSearchBarHidden = true //(sender as! UITextField) == workInTextField ? true : false
            
            var names:[String] = []
            if WSUtility.isLoginWithTurkey(){
                if TpOrLocationFlag == 1 {
                    names = pickerArray.map({$0["locationName"]! as! String})
                }
                else if TpOrLocationFlag == 2{
                    names = pickerCityList
                }
                else{
                    names = pickerArray.map({$0["name"]! as! String})
                }
                
            }
            else{
                names = pickerArray.map({$0["name"]! as! String})
            }
            
            popUpVC.arrayItems = names
            popUpVC.selectedItem = (TpOrLocationFlag == 0)  ? tradePartnerName.text! : tradePartnerLocation.text!
            
            if TpOrLocationFlag == 2 {
                popUpVC.titleString =  "Select a city"
                popUpVC.arrayItems = self.pickerCityList
                popUpVC.selectedItem = tradePartnerCityTF.text!
            }
            
            popUpVC.callBack = { selectedItemValue in
                if self.TpOrLocationFlag == 0{
                    if self.tradePartnerName.text != selectedItemValue{
                        self.selectedIndexForLocation = 0
                        self.tradePartnerLocation.text = ""
                        self.tradePartnerLocation.rightViewMode = .never
                    }
                    self.tradePartnerName.text = selectedItemValue
                    self.selectedIndexForTP = names.index(of: selectedItemValue)!
                    
                    self.UISetUpForTextFieldWithImage(textField: self.tradePartnerName, boolValue: true)
                }
                else if self.TpOrLocationFlag == 2{
                    if self.tradePartnerCityTF.text != selectedItemValue{
                        self.tradePartnerName.text = ""
                        self.tradePartnerLocation.text = ""
                        self.tradePartnerName.rightViewMode = .never
                        self.tradePartnerLocation.rightViewMode = .never
                        self.selectedIndexForTP = 0
                        self.selectedIndexForLocation = 0
                    }
                    self.tradePartnerCityTF.text = selectedItemValue
                    self.UISetUpForTextFieldWithImage(textField: self.tradePartnerCityTF, boolValue: true)
                    var tpVendorList:[[String: Any]] = []
                    for dict in self.vendorListArray{
                        if let array = dict["vendorAddress"] as? [[String: Any]], array.count > 0{
                            let cities = array.map({$0["town"] as! String})
                            let upperCaseCities = cities.map { $0.uppercased()}
                            if upperCaseCities.contains(selectedItemValue){
                                tpVendorList.append(dict)
                            }
                        }
                    }
                    var set = Set<String>()
                    let arraySet: [[String : Any]] = tpVendorList.flatMap {
                        guard let name = $0["name"] as? String else {return nil }
                        return set.insert(name).inserted ? $0 : nil
                    }
                    self.TPListArray = arraySet
                }
                else{
                    self.tradePartnerLocation.text = selectedItemValue
                    self.selectedIndexForLocation = names.index(of: selectedItemValue)!
                    self.UISetUpForTextFieldWithImage(textField: self.tradePartnerLocation, boolValue: true)
                }
            }
        }
    
    }
}
extension WSAddTradePartnerViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case accountNumber:
            WSUtility.UISetUpForTextFieldWithImage(textField: accountNumber, boolValue: true)
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedLength: Int?
        switch textField {
        case accountNumber:
            allowedLength = 12
        default:
            return true
        }
        let nsString = NSString(string: textField.text!)
        if nsString.length >= allowedLength! && range.length == 0 {
            return false
        }
        else{
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountNumber{
            //UISetUpForAccountNoTextFieldWithImage(textField: accountNumber, boolValue: true)
        }
    }
}
extension WSAddTradePartnerViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        self.view.endEditing(true)
    }
}
