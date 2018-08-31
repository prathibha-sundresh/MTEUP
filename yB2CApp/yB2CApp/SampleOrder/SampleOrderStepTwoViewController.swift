//
//  SampleOrderStepTwoViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/10/17.
//

import UIKit

protocol SampleOrderStepTwoViewControllerDelegate {
    func sendArray(array: [[String: Any]])
}
class SampleOrderStepTwoViewController: UIViewController {
    
    var delegate: SampleOrderStepTwoViewControllerDelegate?
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var myDetailsLabel: UILabel!
    @IBOutlet weak var businessNameTextfield: UITextField!
    @IBOutlet weak var buildingNoTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var postalTextfield: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fillSampleLbl: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var myDetailProcessLbl: UILabel!
    @IBOutlet weak var deliveryProcessLbl: UILabel!
    @IBOutlet weak var summaryProcessLbl: UILabel!
    @IBOutlet weak var freeSampleTextLabel: UILabel!
    
    @IBOutlet weak var headerProductNameLabel: UILabel!
    
    @IBOutlet weak var backToDetailsLabel: UILabel!
    var myDetailsDict: [String: Any] = [:]
    var prodDetailsDict: [String: Any] = [:]
    var orderDictInfo: [String: Any] = [:]
    var summaryArray: [[String: Any]] = []
    var sampleOrderDict = [String:Any]()
    @IBOutlet weak var previousButton: UIButton!{
        didSet{
            previousButton.layer.borderWidth = 1.0
            previousButton.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
            previousButton.layer.cornerRadius = 5.0
            previousButton.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addBorderColor(textfiled: businessNameTextfield)
        addBorderColor(textfiled: buildingNoTextfield)
        addBorderColor(textfiled: streetTextfield)
        addBorderColor(textfiled: cityTextfield)
        addBorderColor(textfiled: postalTextfield)
        WSUtility.addNavigationBarBackButton(controller: self)
        // Do any additional setup after loading the view.
        myDetailsLabel.text = WSUtility.getlocalizedString(key: "myDetailsLabel", lang: WSUtility.getLanguage(), table: "Localizable")
        nextButton.setTitle(WSUtility.getlocalizedString(key: "Next", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        
        headerProductNameLabel.text = "\(prodDetailsDict["name"] as! String)"
        freeSampleTextLabel.text = WSUtility.getlocalizedString(key: "Free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        
        backToDetailsLabel.text = WSUtility.getlocalizedString(key: "Back to details", lang: WSUtility.getLanguage(), table: "Localizable")
        businessNameTextfield.placeholder = WSUtility.getlocalizedString(key: "Business name", lang: WSUtility.getLanguage(), table: "Localizable")
        if WSUtility.isLoginWithTurkey(){
            buildingNoTextfield.placeholder = WSUtility.getlocalizedString(key: "Address Line 1", lang: WSUtility.getLanguage(), table: "Localizable")
            streetTextfield.placeholder = WSUtility.getlocalizedString(key: "Address Line 2", lang: WSUtility.getLanguage(), table: "Localizable")
        }
        else{
            buildingNoTextfield.placeholder = WSUtility.getlocalizedString(key: "Building number", lang: WSUtility.getLanguage(), table: "Localizable")
            streetTextfield.placeholder = WSUtility.getlocalizedString(key: "Street", lang: WSUtility.getLanguage(), table: "Localizable")
            
        }
        cityTextfield.placeholder = WSUtility.getlocalizedString(key: "City", lang: WSUtility.getLanguage(), table: "Localizable")
        postalTextfield.placeholder = WSUtility.getlocalizedString(key: "Postal Code", lang: WSUtility.getLanguage(), table: "Localizable")
        fillSampleLbl.text = WSUtility.getlocalizedString(key: "Fill in your details below and get your free sample", lang: WSUtility.getLanguage(), table: "Localizable")
        var picDict: [String: Any] = [:]
        
        if let pictures = prodDetailsDict["pictures"] as? [AnyObject]{
            
            if pictures.count > 0{
                picDict = pictures[0] as! [String : Any]
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
            
        }
        
        myDetailProcessLbl.text = WSUtility.getlocalizedString(key: "My Detail", lang: WSUtility.getLanguage(), table: "Localizable")
        deliveryProcessLbl.text = WSUtility.getlocalizedString(key: "Delivery", lang: WSUtility.getLanguage(), table: "Localizable")
        summaryProcessLbl.text = WSUtility.getlocalizedString(key: "Summary", lang: WSUtility.getLanguage(), table: "Localizable")
        
        if summaryArray.count > 1{
            let tmpDict = summaryArray[1]
            updateValueswhilePoporPush(tmpDict: tmpDict)
        }
        else{
            updateDataWithUI()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{//on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateDataWithUI(){
        if WSUtility.isLoginWithTurkey(){
            setAddressValuesForTurkey(tmpDict: orderDictInfo)
            return
        }
        if let tmpDict = orderDictInfo["billingAddress"] as? [String: Any]{
            if let name = tmpDict["businessName"] as? String{
                businessNameTextfield.text = "\(name)"
            }
            if let hNo = tmpDict["houseNumber"] as? String{
                buildingNoTextfield.text = "\(hNo)"
            }
            if let name = tmpDict["street"] as? String{
                streetTextfield.text = "\(name)"
            }
            if let name = tmpDict["city"] as? String{
                cityTextfield.text = "\(name)"
            }
            if let code = tmpDict["zipCode"] as? String{
                postalTextfield.text = "\(code)"
            }
        }
    }
    
    func setAddressValuesForTurkey(tmpDict: [String: Any]){
        
        if let name = tmpDict["operatorBusinessName"] as? String{
            businessNameTextfield.text = "\(name)"
        }
        if let hNo = tmpDict["line1"] as? String{
            buildingNoTextfield.text = "\(hNo)"
        }
        if let name = tmpDict["line2"] as? String{
            streetTextfield.text = "\(name)"
        }
        if let name = tmpDict["town"] as? String{
            cityTextfield.text = "\(name)"
        }
        if let code = tmpDict["postalCode"] as? String{
            postalTextfield.text = "\(code)"
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
    
    func addBorderColor(textfiled: UITextField){
        textfiled.setLeftPaddingPoints(10)
        WSUtility.UISetUpForTextField(textField: textfiled, withBorderColor: unselectedTextFieldBorderColor)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        if summaryArray.count > 1{
            var myBusinessDetailsDict:[String: Any] = [:]
            myBusinessDetailsDict["businessName"] = businessNameTextfield.text
            myBusinessDetailsDict["buildingNo"] = buildingNoTextfield.text
            myBusinessDetailsDict["streetName"] = streetTextfield.text
            myBusinessDetailsDict["city"] = cityTextfield.text
            myBusinessDetailsDict["postalCode"] = postalTextfield.text
            summaryArray[1] = myBusinessDetailsDict
            self.delegate?.sendArray(array: summaryArray)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sample3rdVC"{
            let sampleOrder3VC = segue.destination as! SampleOrderStepThreeViewController
            var myBusinessDetailsDict: [String: Any] = [:]
            myBusinessDetailsDict["businessName"] = businessNameTextfield.text
            myBusinessDetailsDict["buildingNo"] = buildingNoTextfield.text
            myBusinessDetailsDict["streetName"] = streetTextfield.text
            myBusinessDetailsDict["city"] = cityTextfield.text
            myBusinessDetailsDict["postalCode"] = postalTextfield.text
            sampleOrder3VC.summaryArray.append(myDetailsDict)
            sampleOrder3VC.summaryArray.append(myBusinessDetailsDict)
            //sampleOrder3VC.summaryArray.append(self.prodDetailsDict)
            sampleOrder3VC.prodDetailsDict = self.prodDetailsDict
            sampleOrder3VC.sampleOrderDict = self.sampleOrderDict
        }
    }
    @IBAction func unwindToStep2(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SampleOrderStepThreeViewController {
            
            if sourceViewController.summaryArray.count > 1{
                
                summaryArray = sourceViewController.summaryArray
                let tmpDict = sourceViewController.summaryArray[1]
                updateValueswhilePoporPush(tmpDict: tmpDict)
            }
        }
    }
    func updateValueswhilePoporPush(tmpDict: [String: Any]){
        if let name = tmpDict["businessName"] as? String{
            businessNameTextfield.text = "\(name)"
        }
        if let name = tmpDict["buildingNo"] as? String{
            buildingNoTextfield.text = "\(name)"
        }
        if let name = tmpDict["streetName"] as? String{
            streetTextfield.text = "\(name)"
        }
        if let name = tmpDict["city"] as? String{
            cityTextfield.text = "\(name)"
        }
        if let name = tmpDict["postalCode"] as? String{
            postalTextfield.text = "\(name)"
        }
    }
    @IBAction func nextBtn(sender: UIButton){
        var isFieldsEmpty: Bool = false
        let businessName: String? = businessNameTextfield.text
        let buildingNo: String? = buildingNoTextfield.text
        let street: String? = streetTextfield.text
        let city: String? = cityTextfield.text
        let postalCode: String? = postalTextfield.text
        
        if businessName == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: businessNameTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        
        if buildingNo == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: buildingNoTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        
        if street == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: streetTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if city == "" {
            
            WSUtility.UISetUpForTextFieldWithImage(textField: cityTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if (postalCode?.count)! > 5 || (postalCode?.count)! < 4{
            
            UISetUpForPostalCodeTextFields(textField: postalTextfield, boolValue: true)
            isFieldsEmpty = true
        }
        if !isFieldsEmpty{
            self.performSegue(withIdentifier: "sample3rdVC", sender: self)
        }
    }
    
    func UISetUpForPostalCodeTextFields(textField:UITextField ,boolValue: Bool)  {
        
        if boolValue == true {
            
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 50))
            let checkedImage: UIImageView = UIImageView()
            checkedImage.frame = CGRect(x: 0, y: 17.5, width: 15, height: 15)
            checkedImage.contentMode = .scaleAspectFit
            
            let billingCode = (textField.text?.count)!
            
            if billingCode == 5 || billingCode == 4 {
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
}
extension SampleOrderStepTwoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case businessNameTextfield:
            buildingNoTextfield.becomeFirstResponder()
        case buildingNoTextfield:
            streetTextfield.becomeFirstResponder()
        case streetTextfield:
            cityTextfield.becomeFirstResponder()
        case cityTextfield:
            postalTextfield.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func textDidchange(_ textField: UITextField){
        switch textField {
        case businessNameTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: businessNameTextfield, boolValue: true)
        case buildingNoTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: buildingNoTextfield, boolValue: true)
        case streetTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: streetTextfield, boolValue: true)
        case cityTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: cityTextfield, boolValue: true)
        case postalTextfield:
            WSUtility.UISetUpForTextFieldWithImage(textField: postalTextfield, boolValue: true)
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        
        if textField == postalTextfield {
            
            let currentCharacterCount = textField.text?.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 5
        }
        return true
    }
}

