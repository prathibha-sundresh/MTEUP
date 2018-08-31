//
//  SampleOrderStepOneViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/10/17.
//

import UIKit

class SampleOrderStepOneViewController: UIViewController {
    @IBOutlet weak var firstNameTextfield: FloatLabelTextField!
    @IBOutlet weak var lastNameTextfield: FloatLabelTextField!
    @IBOutlet weak var emailTextfield: FloatLabelTextField!
    @IBOutlet weak var mobileTextfield: FloatLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerlabel:UILabel!
    @IBOutlet weak var headerProductNameLabel: UILabel!
    
    @IBOutlet weak var freeSampleTextLabel: UILabel!
    @IBOutlet weak var myDetailsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var myDetailProcessLbl: UILabel!
    @IBOutlet weak var deliveryProcessLbl: UILabel!
    @IBOutlet weak var summaryProcessLbl: UILabel!
    
    var prodDetailsDict: [String: Any] = [:]
    var summaryArray: [[String: Any]] = []
    var recentOrderDictInfo: [String: Any] = [:]
    var sampleOrderDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getOrderHistoryList()
        WSWebServiceBusinessLayer().trackingScreens(screenName: "Sample Order screen")
        UFSGATracker.trackScreenViews(withScreenName: "Sample Order screen")
        FireBaseTracker.ScreenNaming(screenName: "Sample Order screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Sample Order screen")
        
        headerProductNameLabel.text = "\(prodDetailsDict["name"] as! String)"
        freeSampleTextLabel.text = WSUtility.getlocalizedString(key: "Free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        
        headerlabel.text = WSUtility.getlocalizedString(key: "Fill in your details below and get your free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        myDetailsLabel.text = WSUtility.getlocalizedString(key: "My details", lang: WSUtility.getLanguage(), table: "Localizable")
        nextButton.setTitle(WSUtility.getlocalizedString(key: "Next", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

    func setUI(){
        let email_id = UserDefaults.standard.value(forKey: LAST_AUTHENTICATED_USER_KEY)!
        emailTextfield.text =  "\(email_id)"
        WSUtility.UISetUpForTextFieldWithImage(textField: emailTextfield, boolValue: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addBorderColor(textfiled: firstNameTextfield)
        addBorderColor(textfiled: lastNameTextfield)
        addBorderColor(textfiled: emailTextfield)
        addBorderColor(textfiled: mobileTextfield)
        WSUtility.addNavigationBarBackButton(controller: self)
        
        if let pictures = prodDetailsDict["pictures"] as? [AnyObject]{
            if pictures.count > 0{
                let picDict = pictures[0] as! [String : Any]
                if let imageURL = picDict["imageUrl"] as? String {
                    let urlComponents = NSURLComponents(string: imageURL)
                    urlComponents?.user =  "ufsstage"
                    urlComponents?.password = "emakina"
                    pImage.sd_setImage(with: URL(string:(urlComponents?.string)!), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            else{
                if let variants = self.prodDetailsDict["variantOptions"] as? [[String:Any]],variants.count > 0{
                    
                    let picDict = variants[0] 
                    if let imageURL = picDict["thumbnailUrl"] as? String {
                        let urlComponents = NSURLComponents(string: imageURL)
                        urlComponents?.user =  "ufsstage"
                        urlComponents?.password = "emakina"
                        pImage.sd_setImage(with: URL(string:(urlComponents?.string)!), placeholderImage: UIImage(named: "placeholder.png"))
                    }
            }
            }
            //pImage.sd_setImage(with: URL(string:picDict["picName"] as! String), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .allowInvalidSSLCertificates)
            
            myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
            deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
            summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
            firstNameTextfield.placeholder = WSUtility.getlocalizedString(key: "First Name", lang: WSUtility.getLanguage(), table: "Localizable")
            lastNameTextfield.placeholder = WSUtility.getlocalizedString(key: "Surname", lang: WSUtility.getLanguage(), table: "Localizable")
            mobileTextfield.placeholder = WSUtility.getlocalizedString(key: "Mobile Phone", lang: WSUtility.getLanguage(), table: "Localizable")
            emailTextfield.placeholder = WSUtility.getlocalizedString(key: "Email", lang: WSUtility.getLanguage(), table: "Localizable")
            // firstNameTextfield.text = WSUtility.getValueFromUserDefault(key: "FirstName")
            // lastNameTextfield.text = WSUtility.getValueFromUserDefault(key: "LastName")
            firstNameTextfield.text = WSUtility.getValueFromUserDefault(key: "FirstName")
            lastNameTextfield.text = WSUtility.getValueFromUserDefault(key: "LastName")
            mobileTextfield.text = WSUtility.getValueFromUserDefault(key: "mobileNo")
            
        }
    }
    func getOrderHistoryList() {
        
        UFSProgressView.showWaitingDialog("")
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeOrderHistoryRequest(methodName: ORDER_HISTORY_API, successResponse: { (response) in
            //print(response)
            UFSProgressView.stopWaitingDialog()
            if response.count > 0{
                if let dict = response.first as? [String: Any]{
                    self.recentOrderDictInfo = dict
                    self.updateUserDetails(Dict: self.recentOrderDictInfo)
                }
                
            }
        }, faliureResponse: { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        })
    }
    func updateUserDetails(Dict: [String: Any]){
        
        if var tmpDict = Dict["orderInfo"] as? [String: Any]{
            if let name = tmpDict["firstName"] as? String{
                firstNameTextfield.text = "\(name)"
            }
            if let name = tmpDict["lastName"] as? String{
                lastNameTextfield.text = "\(name)"
            }
            if let email = tmpDict["email"] as? String{
                emailTextfield.text = "\(email)"
            }
            if let name = tmpDict["mobilePhone"] as? String{
                mobileTextfield.text = "\(name)"
            }
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addBorderColor(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sample2ndVC"{
            let sampleOrder2VC = segue.destination as! SampleOrderStepTwoViewController
            sampleOrder2VC.delegate = self
            sampleOrder2VC.myDetailsDict["email"] = emailTextfield.text
            sampleOrder2VC.myDetailsDict["firstName"] = firstNameTextfield.text
            sampleOrder2VC.myDetailsDict["lastName"] = lastNameTextfield.text
            sampleOrder2VC.myDetailsDict["mobileNumber"] = mobileTextfield.text
            sampleOrder2VC.prodDetailsDict = self.prodDetailsDict
            if WSUtility.isLoginWithTurkey(){
                sampleOrder2VC.orderDictInfo = WSUser().getUserProfile().defaultAddress
            }
            else{
                if let tmpDict = recentOrderDictInfo["orderInfo"] as? [String: Any]{
                    sampleOrder2VC.orderDictInfo = tmpDict
                }
            }
            sampleOrder2VC.summaryArray = summaryArray
            sampleOrder2VC.sampleOrderDict = self.sampleOrderDict
        }
    }
    
    @IBAction func nextBtn(sender: UIButton){
        var isFieldsEmpty: Bool = false
        let firstName: String? = firstNameTextfield.text
        let lastName: String? = lastNameTextfield.text
        let mobileNumber: String? = mobileTextfield.text
        
        if firstName == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: firstNameTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        
        if lastName == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: lastNameTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        
        if mobileNumber == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: mobileTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if !isFieldsEmpty{
            self.performSegue(withIdentifier: "sample2ndVC", sender: self)
        }
    }
    @IBAction func unwindToStep1(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SampleOrderStepThreeViewController {
            if sourceViewController.summaryArray.count > 0{
                let tmpDict = sourceViewController.summaryArray[0]
                summaryArray = sourceViewController.summaryArray
                if let name = tmpDict["firstName"] as? String{
                    firstNameTextfield.text = "\(name)"
                }
                if let name = tmpDict["lastName"] as? String{
                    lastNameTextfield.text = "\(name)"
                }
                if let email = tmpDict["email"] as? String{
                    emailTextfield.text = "\(email)"
                }
                if let name = tmpDict["mobileNumber"] as? String{
                    mobileTextfield.text = "\(name)"
                }
            }
        }
    }
}
extension SampleOrderStepOneViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            //        case emailTextfield:
        //            firstNameTextfield.becomeFirstResponder()
        case firstNameTextfield:
            lastNameTextfield.becomeFirstResponder()
        case lastNameTextfield:
            mobileTextfield.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
            //        case emailTextfield:
        //            WSUtility.UISetUpForTextFieldWithImage(textField: emailTextfield, boolValue: true)
        case firstNameTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: firstNameTextfield, boolValue: true)
        case lastNameTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: lastNameTextfield, boolValue: true)
        case mobileTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: mobileTextfield, boolValue: true)
        default:
            break
        }
    }
}
extension SampleOrderStepOneViewController: SampleOrderStepTwoViewControllerDelegate{
    func sendArray(array: [[String: Any]]){
        summaryArray = array
    }
}
