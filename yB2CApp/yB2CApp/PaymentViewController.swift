//
//  PaymentViewController.swift
//  UFS
//
//  Created by Rajesh Reddy on 07/05/18.
//

import UIKit

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    var arrIban = [[String:Any]]()
    var arrcards = [[String: Any]]()
    var totalPriceForPayment_TR = ""
    var detailDictionary = [String: Any]()
    var addressDictionary = [String: Any]()
    var billingAddressDictionary = [String: Any]()
    var cartArr: [String] = [String]()
    var tradeNameTxt = ""
    var childTradeNameTxt = ""
    var totalPrice = ""
    var earnedLoyaltyPoints = ""
    var promoCode = ""
    var sameBilling = 0
    var summaryDeliveryDate = ""
    var validPromoDict: [String: Any] = [:]
    var totalItemsQunatity: Int = 0
    var strDeliveryNotes = ""
    var selectedTradePartnerId = ""
    var activeField = UITextField()

    var showPikerV:(([Any],String,String) -> ())?
    var updatePaymentDetils: (([String:Any]) ->())?
    var goToSummaryPage: (() ->())?
    var deleteAndreloadCards : ((String) -> Void)?
    var updateTheArrayCards : (([[String: Any]]) -> Void)?
    var scrollVaccordingToTextfild : ((UITextField) -> Void)?

    var indPath:IndexPath?
    var paymentDetail = [String:Any]()
 
    enum cardPayTableVtype :String{
        
        case onlySavedCards
        case noSavedCards
        case addCardsToSave
        case makeBydeifault
    }
    var tableVdesign = cardPayTableVtype.makeBydeifault
   
    @IBOutlet weak var aboveShadowView: UIView!
    @IBOutlet weak var belowShadowView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var selectedIndex = 0
    var strSelectedPmntMode = "cc"
    
    @IBOutlet weak var widthCnstHdr1: NSLayoutConstraint!
    @IBOutlet weak var widthCnstHdr2: NSLayoutConstraint!
    @IBOutlet weak var leadingCnstHdr3: NSLayoutConstraint!
    @IBOutlet weak var trailingCnstHdr3: NSLayoutConstraint!
    @IBOutlet weak var leadingCnstHdr2: NSLayoutConstraint!
    @IBOutlet weak var hightOfMidV: NSLayoutConstraint!

    @IBOutlet weak var vwTopBase: UIView!
    @IBOutlet weak var vwBottomBase: UIView!
    @IBOutlet weak var vwMidBase: UIView!
    @IBOutlet weak var btnNext: WSDesignableButton!
    
    @IBOutlet weak var paymentLabel_Step3: UILabel!
    
    @IBOutlet weak var tableMoneyTransfer: UITableView!
    @IBOutlet weak var cardPaymentTableV: UITableView!

   
    @IBOutlet weak var vwLineMnyTransfer: UIView!
    @IBOutlet weak var vwLineCC: UIView!
    
    @IBOutlet weak var btnPayMyMnyTransfer: UIButton!
    @IBOutlet weak var btnpayByCC: UIButton!
    
    @IBOutlet weak var lblPaymentHdr: UILabel!
    @IBOutlet weak var lblChoosehdr: UILabel!
    
    @IBOutlet weak var checkoutLabel: UILabel!
    @IBOutlet weak var btnBackToDetails: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
 
        //MARK: for cells
        UserDefaults.standard.set(true, forKey: "isFromSummary")
        cardPaymentTableV.register(UINib(nibName: "UFSSaveCardFormTableViewCell",bundle: nil), forCellReuseIdentifier: "UFSSaveCardFormTableViewCell")
        cardPaymentTableV.register(UINib(nibName: "UFSSavedCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "UFSSavedCardsTableViewCell")
        tableMoneyTransfer.register(UINib(nibName: "MoneyTransferCustomCell", bundle: nil), forCellReuseIdentifier: "MoneyTransferCustomCell")
        tableMoneyTransfer.register(UINib(nibName: "MoneyTransferFooterCell", bundle: nil), forCellReuseIdentifier: "MoneyTransferFooterCell")
        
        showPikerV = { (pikerData,strPopUpTitle,strSelectedItem) in
            
            let storyBoard = UIStoryboard(name: "CustomPopUp", bundle: nil)
            let popVC = storyBoard.instantiateViewController(withIdentifier: "UFSPopUpViewController") as? UFSPopUpViewController
            
            popVC?.arrayItems = pikerData as! [String]
            popVC?.titleString = strPopUpTitle
            popVC?.selectedItem = strSelectedItem
            popVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popVC?.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.present(popVC!, animated: false, completion: nil)
            var selectedValue : String = ""
            popVC?.callBack = { selectedItemValue in
                
                selectedValue = selectedItemValue
                updatePikerText!(selectedValue)
            }
        }
        updateTheArrayCards = { arrayOfcards in
            self.arrcards = arrayOfcards
        }
        scrollVaccordingToTextfild = { txtfld in
            
            //let textAbsoluteFrame = txtfld.convert(txtfld.bounds, to: self.scrollView)
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: textAbsoluteFrame.minY + 130), animated: true)

        }
        deleteAndreloadCards = { cardId in
            
            let alertController = UIAlertController(title: WSUtility.getlocalizedString(key: "Delete Card", lang: WSUtility.getLanguage()), message: WSUtility.getlocalizedString(key: "Are you sure you want to delete card details?", lang: WSUtility.getLanguage()), preferredStyle: .alert)
            
            let NoAction = UIAlertAction(title: WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage()), style: .default) { (action:UIAlertAction) in
                print("You've pressed No");
            }
            let YesAction = UIAlertAction(title: WSUtility.getlocalizedString(key: "OK", lang: WSUtility.getLanguage()), style: .default) { (action:UIAlertAction) in
                self.deleteCards(cardId: cardId)
                print("You've pressed Yes");
            }
            alertController.addAction(NoAction)
            alertController.addAction(YesAction)
            self.present(alertController, animated: true, completion: nil)

        }
        updatePaymentDetils = { dic in
             self.paymentDetail = dic
        }
        goToSummaryPage = {
             self.performSegue(withIdentifier: "seagueFromPaymentToSummary", sender: self)
            
        }
        
        //******************************************
        
        
        //NOTE : NEET TO IMPIMENT NOW ROW SELETION NOT WORKING WHILE IMPLIMENTED LIKE THIS
        
        indPath = IndexPath(item: 0, section: 0)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeliveryViewController.dismissKeyboard))
        //cardPaymentTableV.addGestureRecognizer(tap)
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
        defaultUISetUp()
        
        paymentLabel_Step3.text = "3. \(WSUtility.getlocalizedString(key: "Payment", lang: WSUtility.getLanguage(), table: "Localizable")!)"
        checkoutLabel.text = WSUtility.getlocalizedString(key: "Checkout", lang: WSUtility.getLanguage(), table: "Localizable")
        lblPaymentHdr.text = WSUtility.getlocalizedString(key: "Payment", lang: WSUtility.getLanguage(), table: "Localizable")
        lblChoosehdr.text = WSUtility.getlocalizedString(key: "Choose a payment method", lang: WSUtility.getLanguage(), table: "Localizable")
        btnpayByCC.setTitle(WSUtility.getlocalizedString(key: "Pay by Credit Card", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
       
        btnPayMyMnyTransfer.setTitle(WSUtility.getlocalizedString(key: "Pay by Money Transfer", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        btnNext.setTitle(WSUtility.getlocalizedString(key: "Next Step", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        let underlineAttributes : [String: Any] = [
            NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
            NSForegroundColorAttributeName : ApplicationOrangeColor,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Back to details", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                        attributes: underlineAttributes)
       btnBackToDetails.setAttributedTitle(attributeString, for: .normal)
       showSelectedPaymentOption()
      tableMoneyTransfer.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews(){
        
        let topShadowForAbove = EdgeShadowLayer(forView: self.aboveShadowView, edge: .Top)
        let belowShadowForAbove = EdgeShadowLayer(forView: self.aboveShadowView, edge:.Bottom)
        self.aboveShadowView.layer.addSublayer(topShadowForAbove)
        self.aboveShadowView.layer.addSublayer(belowShadowForAbove)

        let topShadowForBelow = EdgeShadowLayer(forView: self.belowShadowView, edge: .Top)
        let belowShadowForBelow = EdgeShadowLayer(forView: self.belowShadowView, edge:.Bottom)
        self.belowShadowView.layer.addSublayer(topShadowForBelow)
        self.belowShadowView.layer.addSublayer(belowShadowForBelow)

    }
  
    func showSelectedPaymentOption()  {
        //By Difault
        UFSProgressView.showWaitingDialog("")
        self.btnPayByCCTapped(btnpayByCC)
        getSavedPaymentcards()
        postVendorDetails()
        
        
    /*  btnPayMyMnyTransfer.isHidden = true
        btnpayByCC.setTitleColor(.black, for: .selected)
        btnpayByCC.isUserInteractionEnabled = false

        if WSUser().getUserProfile().isPaymentByCreditCard == true {
             getSavedPaymentcards()
            btnpayByCC.setTitle(WSUtility.getlocalizedString(key: "Pay by Credit Card", lang:   WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            self.btnPayByCCTapped(btnpayByCC)
        }else{
            postVendorDetails()
            btnpayByCC.setTitle(WSUtility.getlocalizedString(key: "Pay by Money Transfer", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            self.btnPayByCCTapped(btnPayMyMnyTransfer)
        }*/
    }
  
    func defaultUISetUp(){
        
        btnpayByCC.titleLabel?.adjustsFontSizeToFitWidth = true
        btnPayMyMnyTransfer.titleLabel?.adjustsFontSizeToFitWidth = true
        
        WSUtility.addNavigationBarBackButton(controller: self)
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "lock.png"), for: UIControlState.normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        if self.view.frame.size.width == 320 {
            widthCnstHdr1.constant = 68.0
            widthCnstHdr2.constant = 65.0
            leadingCnstHdr3.constant = 50.0
            trailingCnstHdr3.constant = 76.0
            leadingCnstHdr2.constant = 80.0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "seagueFromPaymentToSummary"{
            
            let vc: SummaryViewController = segue.destination as! SummaryViewController
            vc.strSelectedPmntMode = strSelectedPmntMode
            vc.detailDictionary = detailDictionary
            vc.addressDictionary = addressDictionary
            vc.billingAddressDictionary = billingAddressDictionary
            vc.cartArr = self.cartArr
            vc.totalPrice =  self.totalPrice
            vc.tradeNameTxt = self.tradeNameTxt
            vc.childTradeNameTxt = self.childTradeNameTxt
            vc.sameBilling = self.sameBilling
            vc.earnedLoyaltyPoints = self.earnedLoyaltyPoints
            vc.promoCode = self.promoCode
            vc.validPromoDict =  self.validPromoDict
            vc.summaryDeliveryDate = summaryDeliveryDate
            vc.totalItemsQunatity = self.totalItemsQunatity
            vc.strDeliveryNotes = strDeliveryNotes
            vc.totalPriceForPayment_TR = self.totalPriceForPayment_TR
            // Dont change " iban" & "payu" string, as same value is getting passed in order API
            vc.paymentMode = cardPaymentTableV.isHidden ? "iban" : "payu"
            vc.selectedTradePartnerId = selectedTradePartnerId
            
            if (cardPaymentTableV.isHidden == true){ // PAY WITHOUT CARD
                
                vc.paymentDetailDict = paymentDetail
                
            }else{ //PAY WITH CARD
                
                if (tableVdesign == cardPayTableVtype.onlySavedCards){
                    vc.paymentDetailDict = self.getTheSelectedCardDetails()
                }else if (tableVdesign == cardPayTableVtype.noSavedCards || tableVdesign == cardPayTableVtype.addCardsToSave){
                    vc.paymentDetailDict = paymentDetail
                }
            }
        }
    }
    
     //MARK : KEYBOARD CONTROLL
    
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
     //MARK : ScrollV deligates
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("Scroll finished")
    }
 
    //MARK : tableView Deligates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // cardPayment table View
        if (cardPaymentTableV == tableView){
            if tableVdesign == cardPayTableVtype.onlySavedCards{
                return 1
            }else if tableVdesign == cardPayTableVtype.noSavedCards{
                return 1
            }else if tableVdesign == cardPayTableVtype.addCardsToSave{
                return 2
            }else{
                return 1
            }
        }else{
             //  other table View
             return arrIban.count > 0 ? arrIban.count + 1 : arrIban.count// last cell : footer
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // cardPayment table View
        if (cardPaymentTableV == tableView){
            
            if tableVdesign == cardPayTableVtype.onlySavedCards{
                 return 216
            }else if tableVdesign == cardPayTableVtype.noSavedCards{
                return 412.5
            }else if tableVdesign == cardPayTableVtype.addCardsToSave{
                if indexPath.row == 0 {
                    return 216 }
                else {
                    return 412.5}
            }else{
                return 412.5
            }
 
        }else{
            //  other table View
            if indexPath.row == arrIban.count{// last cell : footer
                return 290
            }
            else{
                return 85
            }
        }
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
        //  cardPayment table View
            
        if (cardPaymentTableV == tableView){
            
            if (tableVdesign == cardPayTableVtype.onlySavedCards){
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "UFSSavedCardsTableViewCell", for: indexPath as IndexPath) as! UFSSavedCardsTableViewCell
                cell.updateColletionV(arrayCards: arrcards)
                cell.deleteAndreloadCards = self.deleteAndreloadCards
                cell.updateTheArrayCards = self.updateTheArrayCards
                cell.addAnotherCard.addTarget(self, action: #selector(addCardToSave), for: .touchUpInside)
                cell.addAnotherCardImgBtn.addTarget(self, action: #selector(addCardToSave), for: .touchUpInside)
                cell.addAnotherCardImgBtn.setImage(UIImage.init(named: "arrow_down"), for: .normal)
                
                let underlineAttributes : [String: Any] = [
                    NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
                    NSForegroundColorAttributeName : ApplicationOrangeColor,
                    NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Add another card", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                                attributes: underlineAttributes)
                cell.addAnotherCard.setAttributedTitle(attributeString, for: .normal)
                
      

                return cell
                
            }else if (tableVdesign == cardPayTableVtype.noSavedCards){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "UFSSaveCardFormTableViewCell", for: indexPath as IndexPath) as! UFSSaveCardFormTableViewCell
                cell.showPikerV = self.showPikerV
                cell.scrollVaccordingToTextfild = scrollVaccordingToTextfild
                cell.updatePaymentDetils = self.updatePaymentDetils
                cell.goToSummaryPage = self.goToSummaryPage!

                return cell
            }else if (tableVdesign == cardPayTableVtype.addCardsToSave){
                if indexPath.row == 0{// last case : add a new card
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UFSSavedCardsTableViewCell", for: indexPath as IndexPath) as! UFSSavedCardsTableViewCell
                    cell.updateColletionV(arrayCards: arrcards)
                    cell.updateTheArrayCards = self.updateTheArrayCards
                    cell.deleteAndreloadCards = self.deleteAndreloadCards
                    cell.addAnotherCard.addTarget(self, action: #selector(addCardToSave), for: .touchUpInside)
                    cell.addAnotherCardImgBtn.addTarget(self, action: #selector(addCardToSave), for: .touchUpInside)
                    cell.addAnotherCardImgBtn.setImage(UIImage.init(named: "arrowUpIcon"), for: .normal)
                    let underlineAttributes : [String: Any] = [
                        NSFontAttributeName : UIFont(name: "DinPro-Regular", size: 14.0)!,
                        NSForegroundColorAttributeName : ApplicationOrangeColor,
                        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                    let attributeString = NSMutableAttributedString(string: (WSUtility.getlocalizedString(key: "Add another card", lang: WSUtility.getLanguage(), table: "Localizable"))!,
                                                                    attributes: underlineAttributes)
                    cell.addAnotherCard.setAttributedTitle(attributeString, for: .normal)
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UFSSaveCardFormTableViewCell", for: indexPath as IndexPath) as! UFSSaveCardFormTableViewCell
                    cell.showPikerV = self.showPikerV
                    cell.updatePaymentDetils = self.updatePaymentDetils
                    cell.goToSummaryPage = self.goToSummaryPage!
                    cell.scrollVaccordingToTextfild = scrollVaccordingToTextfild
                    
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UFSSaveCardFormTableViewCell", for: indexPath as IndexPath) as! UFSSaveCardFormTableViewCell
                cell.showPikerV = self.showPikerV
                cell.scrollVaccordingToTextfild = scrollVaccordingToTextfild
                cell.updatePaymentDetils = self.updatePaymentDetils
                cell.goToSummaryPage = self.goToSummaryPage!
                return cell
            }
        }else{
            
             //  other table View
            
            if indexPath.row == arrIban.count{// last cell : footer
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyTransferFooterCell", for: indexPath as IndexPath) as! MoneyTransferFooterCell
                cell.selectionStyle = .none
                return cell
            }
            else{
                // create a new cell if needed or reuse an old one
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyTransferCustomCell", for: indexPath as IndexPath) as! MoneyTransferCustomCell
       
                cell.selectionStyle = .none
                if self.view.frame.size.width < 330{
                    cell.lblAddress.font = UIFont(name: "DINPro-Regular", size: 9.0)
                }
                
                if let obj = arrIban[indexPath.row] as? [String:Any]{
                    if let str = obj["accountNumber"] as? String{
                        cell.lblAccNo.text = "IBAN: \(str)"
                    }
                    if let str = obj["name"] as? String{
                        cell.lblAddress.text = "\(str)"
                    }
                    if let str = obj["name"] as? String{
                        cell.lblBankBold.text = "\(str)"
                    }else{
                        cell.lblBankBold.text = ""
                    }
                }
                if (selectedIndex ==  indexPath.row){
                    cell.ivRadio.setImage(#imageLiteral(resourceName: "gallery_sel"), for: .normal)
                    cell.vwBase.layer.borderColor = UIColor(red: 237.0/255.0, green: 101.0/255.0, blue: 44.0/255.0, alpha: 1).cgColor
                }else{
                    cell.ivRadio.setImage(UIImage.init(named: "radio_unsel"), for: .normal)
                    cell.vwBase.layer.borderColor = UIColor.lightGray.cgColor
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row != arrIban.count{
        selectedIndex = indexPath.row
        tableView.reloadData()
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    //MARK: CHECKING WETHER ANY CARD IS SELECTED OR NOT
    
    func checkTheCardSelected() -> (Bool) {

        var isSelected : Bool = false
        for card in arrcards {
            
            if let _ = card ["IsSelected"] {
                if card ["IsSelected"] as! Bool == true{
                    isSelected = true
                    break
                }
            }else{
            }
        }
        return isSelected
    }
    
    
    //MARK: RETURNING CARD  ID  SELECTED
    
    func getTheCardSelected() -> (String) {
        
        var isSelected : String = ""
        for card in arrcards {
            
            if let _ = card ["IsSelected"] {
                if card ["IsSelected"] as! Bool == true{
                    isSelected = card ["id"] as! String
                    break
                }
            }else{
            }
        }
        return isSelected
    }
    
    //MARK: RETURNING PAYMENT DETAILS FROM SAVED CARD SELECTED
    
    func getTheSelectedCardDetails() -> ([String:Any]) {
        var isSelectedDic : [String:Any] = [:]
        for card in arrcards {
            if let _ = card ["IsSelected"] {
                if card ["IsSelected"] as! Bool == true{
                    
                    isSelectedDic["CardNumber"] = card ["cardNumber"]
                    isSelectedDic["NameOnCard"] = card ["accountHolderName"]
                    isSelectedDic["CVV"] = ""
                    isSelectedDic["Expiration_Month"] = card ["expiryMonth"]
                    isSelectedDic["Expiration_Year"] = card ["expiryYear"]
                    isSelectedDic["isNeedToSave"] = false
                    isSelectedDic["isPaymentFromSavedCard"] = true
                    isSelectedDic["savedCardID"] =  card ["id"] as! String
                    break
                }
            }
        }
        return isSelectedDic
    }
    //MARK: ADD CARD RELAOD
    
    @objc func addCardToSave(sender: UIButton!) {
        
        if (self.tableVdesign == cardPayTableVtype.addCardsToSave){
             self.tableVdesign = cardPayTableVtype.onlySavedCards
             self.cardPaymentTableV.reloadData()
             self.expandMidViewByCCTableV()
        }else{//Expand
            self.tableVdesign = cardPayTableVtype.addCardsToSave
            self.cardPaymentTableV.reloadData()
            self.expandMidViewByCCTableV()
        }
    }
    //MARK : expand and animate midview
    
    func expandMidViewByCCTableV() -> () {
        
        if (tableVdesign == cardPayTableVtype.onlySavedCards){
            
            view.layoutIfNeeded()
            hightOfMidV.constant = (vwMidBase.frame.height - cardPaymentTableV.frame.height) + 216
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }else if (tableVdesign == cardPayTableVtype.noSavedCards){
            
            view.layoutIfNeeded()
            hightOfMidV.constant = 550
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }else if (tableVdesign == cardPayTableVtype.addCardsToSave){
           
            view.layoutIfNeeded()
            hightOfMidV.constant = cardPaymentTableV.contentSize.height +  (vwMidBase.frame.height - cardPaymentTableV.frame.height)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            view.layoutIfNeeded()
            hightOfMidV.constant = cardPaymentTableV.contentSize.height +  (vwMidBase.frame.height - cardPaymentTableV.frame.height)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func expandMidViewByPayUTableV() -> () {
        
        view.layoutIfNeeded()
        hightOfMidV.constant = self.tableMoneyTransfer.contentSize.height +  (vwMidBase.frame.height - tableMoneyTransfer.frame.height) + 30
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK : API CALLS
    
    func postVendorDetails() {
        let user:WSUser = WSUser().getUserProfile()
        var dicParam = [String:Any]()
        
        dicParam["vendCode"] = WSUtility.getValueFromUserDefault(key: TRADE_PARTNER_ID) //user.tradePartnerId
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
       serviceBussinessLayer.postVendorDetailsFor_TR_Payment(params: dicParam as NSDictionary,selectedVendorId:selectedTradePartnerId, successResponse: { (response) in
            print(response)
            if let dic = response as? [String:Any]{
                if let arr = response["iban"] as? [[String:Any]]{
                    self.arrIban = arr
                    DispatchQueue.main.async {
                        self.tableMoneyTransfer.isHidden = false
                        UIView.animate(withDuration: 0.6, animations: {
                            self.tableMoneyTransfer.alpha = 1
                        },
                                completion: { _ in
                                    if self.btnPayMyMnyTransfer.isSelected {
                                        self.tableMoneyTransfer.reloadData()
                                        self.tableMoneyTransfer.layoutIfNeeded()
                                        self.expandMidViewByPayUTableV()
                                        self.tableMoneyTransfer.layoutIfNeeded()
                                        self.expandMidViewByPayUTableV()
                                    }
                        })
                    }
                }
                UFSProgressView.stopWaitingDialog()
            }
        }) { (errorMessage) in
            print(errorMessage)
            UFSProgressView.stopWaitingDialog()
        }
        
    }
    func deleteCards(cardId:String) -> () {
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.deleteSavedPaymentCardsDetails(paymentDetailsId: cardId as NSString, successResponse: { (response) in
            self.getSavedPaymentcards()
        }) { (errorMessage) in
            print(errorMessage)
            UFSProgressView.stopWaitingDialog()

        }
    }
    
    func getSavedPaymentcards() {
      let serviceBussinessLayer =  WSWebServiceBusinessLayer()
      serviceBussinessLayer.getSavedPaymentCardsDetails(isSaved: true,selectedVendorId:selectedTradePartnerId, successResponse: { (response) in
        
            if let dic = response as? [String:Any] {
                if let arr = dic["payments"] as? [[String:Any]]{
                    self.arrcards = arr
                    DispatchQueue.main.async {
                        self.cardPaymentTableV.isHidden = false
                        UIView.animate(withDuration: 0.6, animations: {
                            self.cardPaymentTableV.alpha = 1
                        },
                                       completion: { _ in
                                        if self.btnpayByCC.isSelected {
                                            
                                            if self.arrcards.count > 0{
                                                self.tableVdesign = .onlySavedCards
                                                self.cardPaymentTableV.reloadData()
                                            }else{
                                                self.tableVdesign = .noSavedCards
                                                self.cardPaymentTableV.reloadData()
                                            }
                                            self.cardPaymentTableV.layoutIfNeeded()
                                            self.expandMidViewByCCTableV()
                                            self.cardPaymentTableV.layoutIfNeeded()
                                            self.expandMidViewByCCTableV()
                                        }
                        })
                    }
                }
            }
        UFSProgressView.stopWaitingDialog()
            
        }) { (errorMessage) in
            print(errorMessage)
            UFSProgressView.stopWaitingDialog()
        }
    }

    
    //MARK : BUTTON ACTIONS
    
    @IBAction func btnAddyourCard(_ sender: Any) {
        
        if ( cardPaymentTableV.isHidden == true) {  // IBAN
            
            if arrIban.count > 0{
                paymentDetail = arrIban[selectedIndex]
                self.performSegue(withIdentifier: "seagueFromPaymentToSummary", sender: self)
            }else{
                WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "No IBAN available", lang: WSUtility.getLanguage())!, title: WSUtility.getlocalizedString(key: "Error", lang: WSUtility.getLanguage())!, forController: self)
            }
        }else{ // PAYU
            
            if (tableVdesign == cardPayTableVtype.onlySavedCards){
                
                if (checkTheCardSelected()){
                    self.performSegue(withIdentifier: "seagueFromPaymentToSummary", sender: self)
                }else{
                    WSUtility.showAlertWith(message: WSUtility.getlocalizedString(key: "please select saved card", lang: WSUtility.getLanguage())!, title: "", forController: self)
                }
            }else if (tableVdesign == cardPayTableVtype.noSavedCards){
                if (!validateFields!()){
                    self.performSegue(withIdentifier: "seagueFromPaymentToSummary", sender: self)
                }
//                else{
//                    WSUtility.showAlertWith(message: "Fill the Fileds", title: "", forController: self)
//                }
            }else if (tableVdesign == cardPayTableVtype.addCardsToSave){
                
                if (!validateFields!()){
                    self.performSegue(withIdentifier: "seagueFromPaymentToSummary", sender: self)
                }
//                else{
//                    WSUtility.showAlertWith(message: "Fill the Fileds", title: "", forController: self)
//                }
            }
        }
    }
    
    func UISetUpForExpirationtextField(textField:UITextField ,boolValue: Bool)  {
        if !boolValue{
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = unselectedTextFieldBorderColor
            textField.layer.cornerRadius = 6
        }
        else{
            textField.layer.borderColor = selectedTextFieldBorderColor
        }
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveCardTapped(_ sender: Any) {
        
        let btn = sender as? UIButton
        btn?.isSelected = !(btn?.isSelected)!
    }
    @IBAction func btnPayByCCTapped(_ sender: Any) {
        
        btnpayByCC.isSelected = false
        btnPayMyMnyTransfer.isSelected = false
        let btn =  sender as? UIButton
        btn?.isSelected = true
    
        if btn == btnpayByCC { // Credit card
            
            btnpayByCC.setTitleColor(.black, for: .selected)
            btnPayMyMnyTransfer.setTitleColor(.lightText, for: .selected)
            
            vwLineCC.backgroundColor = .orange
            vwLineMnyTransfer.backgroundColor = .clear
            
            if self.arrcards.count > 0{
                self.tableVdesign = .onlySavedCards
                self.cardPaymentTableV.reloadData()
            }else{
                self.tableVdesign = .noSavedCards
                self.cardPaymentTableV.reloadData()
            }
            self.cardPaymentTableV.layoutIfNeeded()
            self.expandMidViewByCCTableV()
        
            
            tableMoneyTransfer.isHidden = true
            cardPaymentTableV.alpha = 0
            cardPaymentTableV.isHidden = false
            UIView.animate(withDuration: 0.6) {
                self.cardPaymentTableV.alpha = 1
            }
            strSelectedPmntMode = "cc"
            
           
            
        }
        else{// iBAN
            
            btnPayMyMnyTransfer.setTitleColor(.black, for: .selected)
            btnpayByCC.setTitleColor(.gray, for: .selected)
            
            vwLineCC.backgroundColor = .clear
            vwLineMnyTransfer.backgroundColor = .orange
            
            self.tableMoneyTransfer.reloadData()
            self.tableMoneyTransfer.layoutIfNeeded()
            self.expandMidViewByPayUTableV()
            
            cardPaymentTableV.isHidden = true
            tableMoneyTransfer.alpha = 0
            tableMoneyTransfer.isHidden = false
            UIView.animate(withDuration: 0.6) {
                self.tableMoneyTransfer.alpha = 1
            }
            strSelectedPmntMode = "moneytransfer"
            
            
            
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        btnAddyourCard(UIButton())
    }
    
    public class EdgeShadowLayer: CAGradientLayer {
        
        public enum Edge {
            case Top
            case Left
            case Bottom
            case Right
        }
        
        public init(forView view: UIView,
                    edge: Edge = Edge.Top,
                    shadowRadius radius: CGFloat = 4.0,
                    toColor: UIColor = UIColor(red:246.0/255.0, green:244.0/255.0, blue:242.0/255.0, alpha:1.0),
                    fromColor: UIColor = UIColor(red:225.0/255.0, green:225.0/255.0, blue:225.0/255.0, alpha:1.0)) {
            
            super.init()
            self.colors = [fromColor.cgColor, toColor.cgColor]
            self.shadowRadius = radius
            
            let viewFrame = view.frame
            
            switch edge {
            case .Top:
                startPoint = CGPoint(x: 0.5, y: 0.0)
                endPoint = CGPoint(x: 0.5, y: 1.0)
                self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width*2, height: shadowRadius)
            case .Bottom:
                startPoint = CGPoint(x: 0.5, y: 1.0)
                endPoint = CGPoint(x: 0.5, y: 0.0)
                self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width*2, height: shadowRadius)
            case .Left:
                startPoint = CGPoint(x: 0.0, y: 0.5)
                endPoint = CGPoint(x: 1.0, y: 0.5)
                self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
            case .Right:
                startPoint = CGPoint(x: 1.0, y: 0.5)
                endPoint = CGPoint(x: 0.0, y: 0.5)
                self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
//    @IBAction func tfExpiryDateTapped(_ sender: Any) {
//    }
//
//        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
//        return 350
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
//        var vwFooterMoneyTransferCustomFooter : MoneyTransferCustomFooter?
//        vwFooterMoneyTransferCustomFooter = MoneyTransferCustomFooter.instanceFromNib()
//
//        return vwFooterMoneyTransferCustomFooter
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
