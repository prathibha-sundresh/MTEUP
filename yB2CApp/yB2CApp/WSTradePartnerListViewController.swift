//
//  WSTradePartnerListViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/29/17.
//

import UIKit
protocol WSTradePartnerListViewControllerDelegate {
    func reloadTPAPI(isDefalut: Bool)
    func updateTPName()
}
class WSTradePartnerListViewController: UIViewController {
    var delegate: WSTradePartnerListViewControllerDelegate?
    @IBOutlet weak var slectTPLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    var selectedDefalutIndex: Int = 0
    @IBOutlet weak var TPListCollectionView: UICollectionView!
    var editIndexesArray :[Int] = []
    var TPListArray:[[String: Any]] = []
    var TPLocationArray:[[String: Any]] = []
    var userTradeParnersArray :[[String: Any]] = []
    var responseDict :[String: Any] = [:]
    
    var vendorListArray:[[String: Any]] = []
    var pickerCityList: [String] = []
    var adminDict: [String: Any] = [:]
    var isFromUPdate: Bool = false
    var selectedTradeId = 0
    var selectedTradelocationId = 0
    @IBOutlet weak var tPListCollectionViewH: NSLayoutConstraint!
    var callBack: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Change Trade Partner Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Change Trade Partner Screen")
        FireBaseTracker.ScreenNaming(screenName: "Change Trade Partner Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Change Trade Partner Screen")
        
        self.view.backgroundColor = UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 0.9)
        self.tabBarController?.tabBar.isHidden = true
        if WSUtility.isLoginWithTurkey(){
            self.getUserProfileVendors_Turkey()
            self.getVendorCitesList()
        }
        else{
            self.getUserTradePartnersList()
            getradePartners()
        }
        
        slectTPLabel.text = WSUtility.getlocalizedString(key: "Select a Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        cancelButton.setTitle(WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage(), table: "Localizable")! + "  X", for: .normal)
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(WSTradePartnerListViewController.tapGestureAction(_:)))
        //tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.getUserDetailsFromAdmin()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if !WSUtility.isLoginWithTurkey(){
            tPListCollectionViewH.constant = 410
        }
        else{
            tPListCollectionViewH.constant = 450
        }
        slectTPLabel.text = WSUtility.getlocalizedString(key: "Select a Trade Partner", lang: WSUtility.getLanguage(), table: "Localizable")
        
        cancelButton.setTitle(WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage(), table: "Localizable")! + "  X", for: .normal)
    }
    func getUserDetailsFromAdmin(){
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getUserDetailsFromAdmin(successResponse: { (response) in
            let tempDictResponse = response["data"] as! [Any]
            self.adminDict = tempDictResponse[0] as! [String:Any]
            
        }) { (errorMessage) in
            
        }
    }
    func updateTradeParnterToUserToAdmin(){
        
        if !adminDict.isEmpty{
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.addUserToAdminPanel(params: ["firstName": "\(adminDict["first_name"] ?? "")","lastName": "\(adminDict["last_name"] ?? "")","bt_id": "\(adminDict["business_code"] ?? "")","pin_code":"\(adminDict["pin_code"] ?? "")","deviceToken":WSUtility.getValueFromUserDefault(key: "DeviceToken"),"business_name":"\(adminDict["business_name"] ?? "")","business_code":"\(adminDict["business_code"] ?? "")"], actionType: "update", successResponse: { (response) in
                
            }, faliureResponse: { (errorMessage) in
                
            })
        }
    }
    func getradePartners(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getTradePartenersList(successResponse: { (response) in
            if let array = response as? [[String: Any]]{
                self.TPListArray = array
                UFSProgressView.stopWaitingDialog()
            }
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    func getUserTradePartnersList()  {
        let bussinessLayer:WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        UFSProgressView.showWaitingDialog("")
        bussinessLayer.getUserTradepartnersList(parameter: [String : Any](), methodName: GET_USER_TRADEPARTNERS, successResponse: { (response) in
            self.responseDict = response as! [String : Any]
            
            if let array = response["userProfileTradePartners"] as? [[String : Any]]{
                self.userTradeParnersArray.removeAll()
                self.userTradeParnersArray = array
                self.TPListCollectionView.reloadData()
            }
            self.updateTradeParnterToUserToAdmin()
            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    /* Add,get,update user vendor details for turkey
     1. creating vendor for user
     2. get UserProfileVendors
     3. update UserProfileVendor
     4. get vendor cities
     */
    
    func createVendorToUserForTurkey(dict: [String: Any], addtpCell: WSAddTPCollectionViewCell){
        
        UFSProgressView.showWaitingDialog("")
        let businesslayer =  WSWebServiceBusinessLayer()
        businesslayer.addVendorToUser(params: dict, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            
            addtpCell.emptyAllFeilds()
            self.selectedTradeId = 0
            self.selectedTradelocationId = 0
            self.getUserProfileVendors_Turkey()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            if errorMessage == "Vendor already exists in your profile"{
                WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "Vendor already exists in your profile", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
            }
        }
        
    }
    func getUserProfileVendors_Turkey(){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getUserProfileVendorsList(successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            
            self.responseDict = response as! [String : Any]
            
            if let array = response["myProfileVendors"] as? [[String : Any]]{
                UserDefaults.standard.set(array, forKey: "myProfileVendorsList")
                self.userTradeParnersArray.removeAll()
                self.userTradeParnersArray = array
                self.TPListCollectionView.reloadData()
            }
            self.updateTradeParnterToUserToAdmin()
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func updateUserVendorProfile_Turkey(dict :[String: Any]){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.updateUserProfileVendorToUser(params: dict, successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            self.editIndexesArray.removeAll()
            self.getUserProfileVendors_Turkey()
        }, failureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    
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
    
    @IBAction func tapGestureAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func closeButton_Click(_ sender: Any) {
        delegate?.reloadTPAPI(isDefalut: true)
        delegate?.updateTPName()
        self.dismiss(animated: true, completion: {
            if let callBackBlock = self.callBack {
                callBackBlock()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "CoustomPopUP"{
            
            if !isFromUPdate{
                let popUpVC = segue.destination as! UFSPopUpViewController
                
                popUpVC.isSearchBarHidden = true
                
                let addtpCell: WSAddTPCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: userTradeParnersArray.count, section: 0)) as! WSAddTPCollectionViewCell
                
                var names:[String] = []
                if sender as? Int == 100{
                    names = TPListArray.map({$0["name"]! as! String})
                    popUpVC.selectedItem = addtpCell.tradePartnerName.text!
                    popUpVC.titleString = "Select tradepartner"
                   
                }
                else if sender as? Int == 102{
                    popUpVC.titleString =  "Select a city"
                    names = self.pickerCityList
                    popUpVC.selectedItem = addtpCell.tradePartnerCity.text!
                }
                else{
                    if WSUtility.isLoginWithTurkey(){
                        names = TPLocationArray.map({$0["locationName"]! as! String})
                    }
                    else{
                        names = TPLocationArray.map({$0["name"]! as! String})
                    }
                    popUpVC.selectedItem = addtpCell.tradePartnerLocation.text!
                    popUpVC.titleString = "Select tradepartner location"
                }
                popUpVC.arrayItems = names
                
                popUpVC.callBack = { selectedItemValue in
                    
                    if sender as? Int == 100{
                        addtpCell.tradePartnerName.text = selectedItemValue
                        addtpCell.textDidchange(addtpCell.tradePartnerName)
                        addtpCell.tradePartnerLocation.text = ""
                        self.selectedTradelocationId = 0
                        addtpCell.tradePartnerLocation.text = ""
                        addtpCell.tradePartnerLocation.rightViewMode = .never
                        let index = names.index(of: selectedItemValue)
                        if WSUtility.isLoginWithTurkey(){
                            let dict = self.TPListArray[index!]
                            if let parentTPId = dict["code"]{
                                addtpCell.tradePartnerName.tag = Int("\(parentTPId)")!
                                self.selectedTradeId = addtpCell.tradePartnerName.tag
                            }
                        }
                        else{
                            let dict = self.TPListArray[index!]
                            if let id = dict["id"] as? Int {
                                self.selectedTradeId = id
                                addtpCell.tradePartnerName.tag = id
                            }
                        }
                    }
                    else if sender as? Int == 102{
                        if addtpCell.tradePartnerCity.text != selectedItemValue{
                            addtpCell.tradePartnerName.text = ""
                            addtpCell.tradePartnerLocation.text = ""
                            addtpCell.tradePartnerName.rightViewMode = .never
                            addtpCell.tradePartnerLocation.rightViewMode = .never
                            self.selectedTradeId = 0
                            self.selectedTradelocationId = 0
                        }
                        addtpCell.tradePartnerCity.text = selectedItemValue
                        addtpCell.UISetUpForTextFieldWithImage(textField: addtpCell.tradePartnerCity, boolValue: true)
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
                        addtpCell.tradePartnerLocation.text = selectedItemValue
                        addtpCell.textDidchange(addtpCell.tradePartnerLocation)
                        let index = names.index(of: selectedItemValue)
                        
                        if WSUtility.isLoginWithTurkey(){
                            let dict = self.TPLocationArray[index!]
                            
                            if let childId = dict["locationId"]{
                                addtpCell.tradePartnerLocation.tag = Int("\(childId)")!
                                self.selectedTradelocationId = addtpCell.tradePartnerLocation.tag
                            }
                        }
                        else{
                            let dict = self.TPLocationArray[index!]
                            if let id = dict["id"] as? Int {
                                self.selectedTradelocationId = id
                            }
                        }
                        
                    }
                    
                }
            }
            else{
                let popUpVC = segue.destination as! UFSPopUpViewController
                popUpVC.titleString = (sender as? Int == 100) ? "Select tradepartner" : "Select tradepartner location";
                popUpVC.isSearchBarHidden = true
                
                let tpListCell: WSTPListCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: editIndexesArray[0], section: 0)) as! WSTPListCollectionViewCell
                var names:[String] = []
                if sender as? Int == 100{
                    names = TPListArray.map({$0["name"]! as! String})
                    popUpVC.selectedItem = tpListCell.tradePartnerName.text!
                }
                else{
                    names = TPLocationArray.map({$0["name"]! as! String})
                    popUpVC.selectedItem = tpListCell.tradePartnerLocation.text!
                }
                popUpVC.arrayItems = names
                
                popUpVC.callBack = { selectedItemValue in
                    
                    if sender as? Int == 100{
                        tpListCell.tradePartnerName.text = selectedItemValue
                        tpListCell.textDidchange(tpListCell.tradePartnerName)
                        tpListCell.tradePartnerLocation.text = ""
                        tpListCell.tradePartnerLocation.rightViewMode = .never
                        let index = names.index(of: selectedItemValue)
                        let dict = self.TPListArray[index!]
                        if let id = dict["id"] as? Int {
                            tpListCell.tradePartnerName.tag = id
                        }
                    }
                    else{
                        tpListCell.tradePartnerLocation.text = selectedItemValue
                        tpListCell.textDidchange(tpListCell.tradePartnerLocation)
                        let index = names.index(of: selectedItemValue)
                        let dict = self.TPLocationArray[index!]
                        if let id = dict["id"] as? Int {
                            tpListCell.tradePartnerLocation.tag = id
                        }
                    }
                    
                }
            }
        }
     }
    
    @IBAction func addTradePartnerClick(sender: UIButton){
        
        let addtpCell: WSAddTPCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: userTradeParnersArray.count, section: 0)) as! WSAddTPCollectionViewCell
        
        var isFieldsEmpty: Bool = false
        
        let tpName: String? = addtpCell.tradePartnerName.text
        let tpLocation : String? = addtpCell.tradePartnerLocation.text
        let tpAccount : String? = addtpCell.accountNumber.text
        
        if WSUtility.isLoginWithTurkey(){
            let tpCity: String? = addtpCell.tradePartnerCity.text
            if tpCity == "" {
                addtpCell.textDidchange(addtpCell.tradePartnerCity)
                isFieldsEmpty = true
            }
        }
        
        if tpName == "" {
            addtpCell.textDidchange(addtpCell.tradePartnerName)
            isFieldsEmpty = true
        }
        
        if tpLocation == "" {
            addtpCell.textDidchange(addtpCell.tradePartnerLocation)
            isFieldsEmpty = true
        }
        if tpAccount == "" {
            
            addtpCell.UISetUpForAccountNoTextFieldWithImage(textField: addtpCell.accountNumber, boolValue: true)
            isFieldsEmpty = true
        }
        
        if !isFieldsEmpty{
            
            if WSUtility.isLoginWithTurkey(){
                
                let requestDict = ["parentTpId": "\(selectedTradeId)","tplocationID": "\(selectedTradelocationId)","accountNumber": addtpCell.accountNumber.text!,"makeDefalut": addtpCell.makeDefaultButton.isSelected] as [String : Any]
                self.createVendorToUserForTurkey(dict: requestDict, addtpCell: addtpCell)
                return
            }
            
            if self.checkExistingTradeParnter(parentTPId: selectedTradeId, childTPId: selectedTradelocationId, accountNumber: addtpCell.accountNumber.text!){
                return
            }
            
            let reqestDict:[String: Any] = ["makeDefalut": addtpCell.makeDefaultButton.isSelected,"parentTpId":selectedTradeId,"tplocationID":selectedTradelocationId,"accountNumber":addtpCell.accountNumber.text!,"ecomUserTPId": ""]
            
            UFSProgressView.showWaitingDialog("")
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.createOrUpdateOrMakeDefalutTradePartner(parameter: reqestDict, methodName: "", successResponse: { (response) in
                UFSProgressView.stopWaitingDialog()
                
                addtpCell.emptyAllFeilds()
                
                self.selectedTradeId = 0
                self.selectedTradelocationId = 0
                self.getUserTradePartnersList()
            }, faliureResponse: { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
            })
        }
    }
    
    func checkExistingTradeParnter(parentTPId: Int,childTPId: Int, accountNumber: String)->Bool{
        // this is for to check existing TradeParnter
        let tpPredicate = NSPredicate(format: "parentTradePartnerId = %d AND tradePartnerId = %d AND clientNumber = %@",parentTPId,childTPId,accountNumber)
        var isBool: Bool = false
        if let array = responseDict["userProfileTradePartners"] as? [[String : Any]]{
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
    @IBAction func updateTradePartnerClick(sender: UIButton){
        
        let updatetpListCell: WSTPListCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! WSTPListCollectionViewCell
        
        var isFieldsEmpty: Bool = false
        
        let tpName: String? = updatetpListCell.tradePartnerName.text
        let tpLocation : String? = updatetpListCell.tradePartnerLocation.text
        let tpAccount : String? = updatetpListCell.accountNumber.text
        
        if WSUtility.isLoginWithTurkey(){
            let tpCity: String? = updatetpListCell.tradePartnerCity.text
            if tpCity == "" {
                updatetpListCell.textDidchange(updatetpListCell.tradePartnerCity)
                isFieldsEmpty = true
            }
        }
        
        if tpName == "" {
            updatetpListCell.textDidchange(updatetpListCell.tradePartnerName)
            isFieldsEmpty = true
        }
        
        if tpLocation == "" {
            updatetpListCell.textDidchange(updatetpListCell.tradePartnerLocation)
            isFieldsEmpty = true
        }
        if tpAccount == "" {
            
            updatetpListCell.UISetUpForAccountNoTextFieldWithImage(textField: updatetpListCell.accountNumber, boolValue: true)
            isFieldsEmpty = true
        }
        
        if !isFieldsEmpty{
            
            if WSUtility.isLoginWithTurkey(){
                let tmpDict:[String: Any] = userTradeParnersArray[sender.tag]
                let reqestDict:[String: Any] = ["makeDefalut": updatetpListCell.makeDefaultButton.isSelected,"accountNumber":updatetpListCell.accountNumber.text!,"myProfileVendorCode" : "\(tmpDict["code"] ?? "")"]
                self.updateUserVendorProfile_Turkey(dict: reqestDict)
                return
            }
            
            if self.checkExistingTradeParnter(parentTPId: updatetpListCell.tradePartnerName.tag, childTPId: updatetpListCell.tradePartnerLocation.tag, accountNumber: updatetpListCell.accountNumber.text!){
                return
            }
            
            let selectedDict:[String: Any] = userTradeParnersArray[sender.tag]
            let reqestDict:[String: Any] = ["makeDefalut": updatetpListCell.makeDefaultButton.isSelected,"parentTpId":updatetpListCell.tradePartnerName.tag,"tplocationID":updatetpListCell.tradePartnerLocation.tag,"accountNumber":updatetpListCell.accountNumber.text!,"ecomUserTPId": "\(selectedDict["id"]!)"]
            
            UFSProgressView.showWaitingDialog("")
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.createOrUpdateOrMakeDefalutTradePartner(parameter: reqestDict, methodName: "", successResponse: { (response) in
                updatetpListCell.emptyAllFeilds()
                self.editIndexesArray.removeAll()
                UFSProgressView.stopWaitingDialog()
                self.getUserTradePartnersList()
            }, faliureResponse: { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
            })
        }
    }
}

extension WSTradePartnerListViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  /*
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let screenWidth = UIScreen.main.bounds.width
     if userTradeParnersArray.count > 0 {
      return CGSize(width: screenWidth - 50, height: 370)
     }
    return CGSize(width: screenWidth - 20, height: 370)
  }
 */
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if indexPath.item == userTradeParnersArray.count {
            TPListCollectionView.register(UINib(nibName: "WSAddTPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddTPcell")
            let addTPcell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddTPcell", for: indexPath) as! WSAddTPCollectionViewCell
            addTPcell.dropDown_TpCityButton.addTarget(self, action: #selector(selectVendorCityButtonAction), for: .touchUpInside)
            addTPcell.tpButton.addTarget(self, action: #selector(tradePartnerButton), for: .touchUpInside)
            addTPcell.tplocationButton.addTarget(self, action: #selector(tradePartnerLocationButton), for: .touchUpInside)
            addTPcell.addNewTradepartnerButton.addTarget(self, action: #selector(addTradePartnerClick(sender:)), for: .touchUpInside)
            addTPcell.translateUI()
            cell = addTPcell
        }
        else{
            let tpListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TPcell", for: indexPath) as! WSTPListCollectionViewCell
            
           
            tpListCell.editTradePartnerButton.tag = indexPath.row
            tpListCell.delegate = self
            tpListCell.selectTradePartnerButton.tag = indexPath.row
            tpListCell.selectTradePartnerButton.addTarget(self, action: #selector(makeDefault), for: .touchUpInside)
            tpListCell.editTradePartnerButton.tag = indexPath.row
            tpListCell.setDataForTradePartnerCell(infoDict: userTradeParnersArray[indexPath.row],response: responseDict)
            tpListCell.dropDown_TradePartnerNameButton.addTarget(self, action: #selector(updateTradePartnerButton(sender:)), for: .touchUpInside)
            tpListCell.dropDown_TradePartnerLocationButton.addTarget(self, action: #selector(updateTradePartnerLocationButton(sender:)), for: .touchUpInside)
            
            if editIndexesArray.contains(indexPath.row){
                tpListCell.setUI(editModeForCell: true)
            }
            else{
                tpListCell.setUI(editModeForCell: false)
            }
            
            cell = tpListCell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userTradeParnersArray.count > 0{
            return userTradeParnersArray.count + 1
        }
        return 1
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if userTradeParnersArray.count == 0 {
            return UIEdgeInsetsMake(0, (UIScreen.main.bounds.size.width - 290 - 30)/2, 0, 0)
        }
        else{
            return UIEdgeInsetsMake(0, 5, 0, 0)
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !WSUtility.isLoginWithTurkey(){
            return CGSize(width: 290, height: 400)
        }
        else{
            return CGSize(width: 290, height: 440)
        }
        
        
    }
    @objc func selectVendorCityButtonAction(sender: UIButton){
        isFromUPdate = false
        self.performSegue(withIdentifier: "CoustomPopUP", sender: sender.tag)
    }
    @objc func tradePartnerButton(sender: UIButton){
        if WSUtility.isLoginWithTurkey(){
            if TPListArray.count == 0{
                return
            }
        }
        isFromUPdate = false
        self.performSegue(withIdentifier: "CoustomPopUP", sender: sender.tag)
    }
    @objc func tradePartnerLocationButton(sender: UIButton){
        isFromUPdate = false
        if selectedTradeId > 0{
            if WSUtility.isLoginWithTurkey(){
                self.tradeLocationFromVendorList_TR()
            }
            else{
                getTPLocation(parentTPID: selectedTradeId, tag: sender.tag)
            }
            
        }
    }
    @objc func updateTradePartnerButton(sender: UIButton){
        isFromUPdate = true
        self.performSegue(withIdentifier: "CoustomPopUP", sender: sender.tag)
    }
    @objc func updateTradePartnerLocationButton(sender: UIButton){
        isFromUPdate = true
        let tpListCell: WSTPListCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: editIndexesArray[0], section: 0)) as! WSTPListCollectionViewCell
        if tpListCell.tradePartnerName.tag > 0{
            getTPLocation(parentTPID: tpListCell.tradePartnerName.tag, tag: sender.tag)
        }
    }
    func getTPLocation(parentTPID: Int, tag: Int){
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.gettradepartnersLocationListRequest(parentTPID:"\(parentTPID)", successResponse: { (response) in
            if let array = response as? [[String: Any]]{
                
                self.TPLocationArray.removeAll()
                self.TPLocationArray = array
                self.performSegue(withIdentifier: "CoustomPopUP", sender: tag)
            }
            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func tradeLocationFromVendorList_TR(){
        
        self.TPLocationArray.removeAll()
        
        for dict in vendorListArray{
            if let tradeId = dict["code"]{

                if "\(tradeId)" == "\(selectedTradeId)"{
                    if let locations = dict["vendorAddress"] as? [[String: Any]]{
                        
                        var tmpArray: [[String: Any]] = []
                        let addtpCell: WSAddTPCollectionViewCell = TPListCollectionView.cellForItem(at: IndexPath(row: userTradeParnersArray.count, section: 0)) as! WSAddTPCollectionViewCell
                        let tpCity: String? = addtpCell.tradePartnerCity.text!
                        
                        for tmpDict in locations{
                            
                            if let valueStr = tmpDict["town"] as? String, valueStr.uppercased() == tpCity{
                                tmpArray.append(tmpDict)
                            }
                        }
                        
                        self.TPLocationArray = tmpArray
                    }
                    break;
                }
            }
        }
        self.performSegue(withIdentifier: "CoustomPopUP", sender: self)
    }
    
    @objc func makeDefault(sender: UIButton){
        
        let tmpdict = userTradeParnersArray[sender.tag]
        
        if WSUtility.isLoginWithTurkey(){
            let isMakeDefalt: Bool = (tmpdict["isDefault"] as? Bool) ?? false
            if !isMakeDefalt{
                let reqestDict:[String: Any] = ["makeDefalut": true,"accountNumber":"\(tmpdict["customerNumber"] ?? "")","myProfileVendorCode" : "\(tmpdict["code"] ?? "")"]
                self.updateUserVendorProfile_Turkey(dict: reqestDict)
            }
            else{
                WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "This is your default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
            }
        }
        else{
        var strTP = ""
        var strParentTP = ""
        if let tmpdictTP = tmpdict["tradePartner"] as? [String:Any]{
            if let str = tmpdictTP["name"] as? String{
                strTP = str
            }
        }
        if let tmpdictParentTP = tmpdict["parentTradePartner"] as? [String:Any]{
            if let str = tmpdictParentTP["name"] as? String{
                strParentTP = str
            }
        }
        let cell: WSTPListCollectionViewCell? = (sender.superview?.superview?.superview as? WSTPListCollectionViewCell) //track your view hierarchy

//        let cell = sender.superview?.superview as! WSTPListCollectionViewCell
        let strAccNum = cell?.accountNumber.text
        let strChildTP = cell?.tradePartnerLocation.text
        let strParentTPTF = cell?.tradePartnerName.text
        if strAccNum == ""{
            return
        }
        var isAlreadyDefalt: Bool = false
        var userProfile_parentTradePartnerId = 0
        let userProfile_clientNumber = responseDict["clientNumber"] as? String

        if let profileTPId = responseDict["parentTradePartnerId"] as? Int{
            userProfile_parentTradePartnerId = profileTPId
        }
        let userProfile_TradePartnerId = responseDict["tradePartnerId"] as? Int

        if tmpdict["parentTradePartnerId"]as? Int == userProfile_parentTradePartnerId{
            if tmpdict["tradePartnerId"]as? Int == userProfile_TradePartnerId{
                let strClientNum = tmpdict["clientNumber"] as? String
                if Int(userProfile_clientNumber!) == Int(strClientNum!) && userProfile_clientNumber == strAccNum && strTP == strChildTP && strParentTPTF == strParentTP{
                    isAlreadyDefalt = true
                }
            }
        }
        
        if isAlreadyDefalt{
            WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "This is your default trade partner", lang: WSUtility.getLanguage(), table: "Localizable")!, title: "", forController: self)
            return
        }
        else{
            let reqestDict:[String: Any] = ["makeDefalut": true,"parentTpId":"\(String(describing: cell!.tradePartnerName.tag))","tplocationID":"\(String(describing: cell!.tradePartnerLocation.tag))","accountNumber":"\(strAccNum!)","ecomUserTPId" : ""]
            //            let reqestDict:[String: Any] = ["makeDefalut": true,"parentTpId":"\(tmpdict["parentTradePartnerId"]!)","tplocationID":"\(tmpdict["tradePartnerId"]!)","accountNumber":"\(strAccNum!)","ecomUserTPId" : ""]

            UFSProgressView.showWaitingDialog("")
            let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
            businessLayer.createOrUpdateOrMakeDefalutTradePartner(parameter: reqestDict, methodName: "", successResponse: { (response) in
                UFSProgressView.stopWaitingDialog()
                self.editIndexesArray.removeAll()
                self.getUserTradePartnersList()
            }, faliureResponse: { (errorMessage) in
                UFSProgressView.stopWaitingDialog()
                self.dismiss(animated: true, completion: {
                    if let callBackBlock = self.callBack {
                        callBackBlock()
                    }
                })
            })
            }
        }
    }
}
extension WSTradePartnerListViewController: WSTPListCollectionViewCellDelegate{
    func selectedIndex(index: Int){
        selectedDefalutIndex = index
        TPListCollectionView.reloadData()
    }
    func changeEditForCell(sender: UIButton){
        
        if sender.titleLabel?.text == WSUtility.getlocalizedString(key: "Edit Trade Partner Details", lang: WSUtility.getLanguage(), table: "Localizable") {
            
            editIndexesArray.removeAll()
            editIndexesArray.append(sender.tag)
            TPListCollectionView.reloadData()
        }
        else{
            self.updateTradePartnerClick(sender: sender)
        }
        
    }

    func editBeforeUpdatingDefaultTradePartner(sender: UIButton){
            editIndexesArray.removeAll()
            editIndexesArray.append(sender.tag)
            TPListCollectionView.reloadData()
    }

    
}

