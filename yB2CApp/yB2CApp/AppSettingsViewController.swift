//
//  AppSettingsViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/30/17.
//

import UIKit
import MessageUI
import UserNotifications

class AppSettingsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var settingTableView: UITableView!
  @IBOutlet weak var appVersionNumberLabel: UILabel!
  @IBOutlet weak var settingsLabel: UILabel!
  @IBOutlet weak var logOutButton: UIButton!
  
  var isFromMenu = false
  var isCollapsible = false
  //var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //addSlideMenuButton()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "App Settings Screen")
    UFSGATracker.trackScreenViews(withScreenName: "App Settings Screen")
    FireBaseTracker.ScreenNaming(screenName: "App Settings Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("App Settings Screen")
    
    settingTableView.register(UINib(nibName: "WSContactUsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "WSContactUsHeaderView")
    
    WSUtility.addNavigationBarBackButton(controller: self)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if !isFromMenu {
      self.navigationController?.popToRootViewController(animated: true)
    }
    else{
      isFromMenu = false
    }
    settingTableView.reloadData()
    
    settingsLabel.text = WSUtility.getlocalizedString(key: "Settings", lang: WSUtility.getLanguage(), table: "Localizable")
    logOutButton.setTitle(WSUtility.getlocalizedString(key: "Log Out", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
    let appVersionText = WSUtility.getlocalizedString(key: "Version ", lang: WSUtility.getLanguage(), table: "Localizable")
    //let someObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
    appVersionNumberLabel.text = appVersionText! + "\(fetchCurrentVersion())"
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let settingCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    settingCell.textLabel?.font = UIFont(name:"DINPro-Regular", size: 16.0)
    settingCell.textLabel?.numberOfLines = 0
    //settingCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    if(indexPath.section == 0){
      settingCell.textLabel?.text = WSUtility.getlocalizedString(key: "Location and Language", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    else  if(indexPath.section == 1){
      settingCell.textLabel?.text = WSUtility.getlocalizedString(key: "Change Password", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    else  if(indexPath.section == 2){
      //settingCell.textLabel?.text = WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable")
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "WSAppSettingContactUsTableViewCell") as? WSAppSettingContactUsTableViewCell
      cell?.callButton.addTarget(self, action: #selector(callButton_click), for: .touchUpInside)
      
      if WSUtility.getCountryCode() == "CH" && WSUtility.getLanguageCode() == "de"{
        cell?.callButton.setTitle(String(format: "  %@",WSUtility.getlocalizedString(key: "08 00 / 220 096 (free phone)-CH", lang: WSUtility.getLanguage(), table: "Localizable")!), for: .normal)
      }
      else if WSUtility.getCountryCode() == "DE" && WSUtility.getLanguageCode() == "de"{
        cell?.callButton.setTitle(String(format: "  %@",WSUtility.getlocalizedString(key: "08 00 / 220 096 (free phone)-DE", lang: WSUtility.getLanguage(), table: "Localizable")!), for: .normal)
      }
      else{
        cell?.callButton.setTitle(String(format: "  %@",WSUtility.getlocalizedString(key: "08 00 / 220 096 (free phone)", lang: WSUtility.getLanguage(), table: "Localizable")!), for: .normal)
      }
      
      
      cell?.sendMailButton.addTarget(self, action: #selector(sendMailButton_click), for: .touchUpInside)
      return cell!
      
    }else  if(indexPath.section == 3){
      settingCell.textLabel?.text = WSUtility.getlocalizedString(key: "Terms and Conditions", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    settingCell.selectionStyle = .none
    return settingCell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 2 {
      return 60
      //return 0
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 2{
      return isCollapsible == true ? UITableViewAutomaticDimension : 0
      //return 0
    }
    return 60
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 2 {
      if let headerView:WSContactUsHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WSContactUsHeaderView") as? WSContactUsHeaderView {
        
        headerView.headerTitleLabel.text = WSUtility.getlocalizedString(key: "Customer Support", lang: WSUtility.getLanguage(), table: "Localizable")
        headerView.section = section
        headerView.delegate = self // don't forget this line!!!
        return headerView
      }
    }
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if(indexPath.section == 0)
    {
        if WSUtility.isLoginWithTurkey(){
            return
        }
      performSegue(withIdentifier: "LocationSegue", sender: self)
    }
    if indexPath.section == 1 {
      performSegue(withIdentifier: "ChangePasswordSegue", sender: self)
    }
    if (indexPath.section == 3){
      performSegue(withIdentifier: "TermsSegue", sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "LocationSegue"{
      let locVC = segue.destination as! WSLocationViewController
      isFromMenu = true
      locVC.isFromMenu = isFromMenu
    }
    if segue.identifier == "ChangePasswordSegue"{
      let locVC = segue.destination as! WSChangePasswordViewController
      isFromMenu = true
      locVC.isFromMenu = isFromMenu
    }
  }
  @IBAction func callButton_click(_ sender: Any) {
    let phNumber = "0800220096"
    let trimmedCharacters = phNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    if let url = NSURL(string: "tel://\(trimmedCharacters ?? "")"), UIApplication.shared.canOpenURL(url as URL) {
      // UIApplication.shared.openURL(url as URL)
      if #available(iOS 10, *) {
        UIApplication.shared.open(url as URL)
      } else {
        UIApplication.shared.openURL(url as URL)
      }
    }
  }
  @IBAction func sendMailButton_click(_ sender: Any) {
    
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeViewController, animated: true, completion: nil)
    }
    else{
      
    }
  }
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    
    mailComposerVC.setToRecipients(["ufsservice@unilever.com"])
    //mailComposerVC.setCcRecipients([])
    //mailComposerVC.setBccRecipients([])
    mailComposerVC.setSubject("UFS")
    mailComposerVC.setMessageBody("", isHTML: false)
    return mailComposerVC
  }
  func updateLoginOrLogoutToAdmin() {
    WSWebServiceBusinessLayer().updateUserLoggedInOrLogoutToAdminPanel(statusValue: 2, successResponse: { (response) in
      
    }) { (errorMessage) in
      
    }
  }
  @IBAction func logOutPressed(_ sender: Any) {
    
    self.updateLoginOrLogoutToAdmin()
    WSUser().removeObjectsFromUserDefaults()
    //let appDelegate : HYBAppDelegate = self.getDelegate()
    let appDelegate = UIApplication.shared.delegate as! HYBAppDelegate
    UserDefaults.standard.set(false, forKey: USER_LOGGEDIN_KEY)
    UserDefaults.standard.removeObject(forKey: "UserEmailId")
    UserDefaults.standard.removeObject(forKey: LAST_AUTHENTICATED_USER_KEY)
    UserDefaults.standard.removeObject(forKey: IS_USER_HAS_PLACED_FIRST_ORDER)
    UserDefaults.standard.removeObject(forKey: USER_GOAL_DETAIL_KEY)
    UserDefaults.standard.removeObject(forKey: USER_LOYALTY_GOAL_ID_KEY)
    UserDefaults.standard.removeObject(forKey: LOYALTY_BALANCE_KEY)
    UserDefaults.standard.set(false, forKey: "callFirstTime")
    UserDefaults.standard.removeObject(forKey: TRADE_PARTNER_NAME)
    UserDefaults.standard.removeObject(forKey: TRADE_PARTNER_ID)
    UserDefaults.standard.removeObject(forKey: USER_ZIP_CODE)
    UserDefaults.standard.removeObject(forKey: Cart_Detail_Key)
    UserDefaults.standard.set("", forKey: TAX_NUMBER_KEY)
    UserDefaults.standard.removeObject(forKey: TAX_NUMBER_KEY)
    UserDefaults.standard.removeObject(forKey: "mobileNo")
    UFSHybrisUtility.cartData = ["":""]
    UFSHybrisUtility.uniqueCartId = ""
    UFSHybrisUtility.userId = ""
    UserDefaults.standard.set(false, forKey: DTO_OPERATOR)
    
    UserDefaults.standard.set(false, forKey: "IsbusinessPopUpShown_TR")
    
    UserDefaults.standard.removeObject(forKey: "vendorMOQ")
    UserDefaults.standard.set(0, forKey: "minOrderValue")
    UserDefaults.standard.set(false, forKey: "Is_First_Time_DTO_OPERATOR")
    UserDefaults.standard.set(true, forKey: "isFromLoginForDTO")
    UserDefaults.standard.set([String: Any](), forKey: "adminUserResponse")
    UserDefaults.standard.removeObject(forKey: "enableDisbleFeature")
    
    UserDefaults.standard.set(0, forKey: "First_Order_Incentive_amount")
    UserDefaults.standard.set([String: Any](), forKey: "First_Order_Incentive_Data")
    appDelegate.openRegularLoginScreen()
  }
  
  func fetchCurrentVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let shortVersion = dictionary["CFBundleShortVersionString"] as! String
    return shortVersion
  }
}

extension AppSettingsViewController:HeaderViewDelegate{
  func toggleSection(header: WSContactUsHeaderView, section: Int) {
    
    // Toggle collapse
    let collapsed = !isCollapsible
    isCollapsible = collapsed
    header.setCollapsed(collapsed: collapsed)
    // Adjust the number of the rows inside the section
    
    settingTableView.reloadSections(IndexSet(integer: 2), with: .automatic)
  }
  
}

extension AppSettingsViewController:MFMailComposeViewControllerDelegate{
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    switch result {
    case .cancelled:
      print("Mail cancelled")
    case .saved:
      print("Mail saved")
    case .sent:
      print("Mail sent")
    case .failed:
      print("Mail sent failure: \(String(describing: error?.localizedDescription))")
    default:
      break
    }
    controller.dismiss(animated: true, completion: nil)
  }
}
