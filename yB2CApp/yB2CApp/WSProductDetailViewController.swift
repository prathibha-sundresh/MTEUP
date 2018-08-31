//
//  WSProductDetailViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 29/11/2017.
//

import UIKit
@objc protocol ProductDetailDelegate {
    func reloadRow(cellIndex:Int)
}

class WSProductDetailViewController: UIViewController {
    var updatedOnce = false
    weak var delegate:ProductDetailDelegate?
    var cellIndex = Int()
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var cartViewHtCons: NSLayoutConstraint!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var cartView: UIView!
    var addToCartPC = ""
    var productQnt = ""
    var cartviewHt :CGFloat?
    @IBOutlet weak var vwShadowLine: UIView!
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var noProductFoundLabel: UILabel!
    
    var productCode = ""
    var originalProductCode = ""
    let Top_Image_Section = 0
    let PriceAndOtherDetail_Section = 1
    let Video_Section = 2
    let Banner_Image_Section = 3
    let Product_Description_Text_Section = 4
    let Product_Information_Section = 5
    let Nutrition_Information_Section = 6
    let Use_Section = 7
    
    
    var sections = [[String:Any]]()
    var expandedArray:[Int] = []
    var productDetailArray = [String:Any]()
    var nutritionCellHeight = 0
    var dachClaimArray = [[String:Any]]()
    var youtubeUrlLink = ""
    var isSmapleOrderAvailable = false
    var sampleOrderDict = [String:Any]()
    var selectedPackagingType = ""
    var selectedContainerType = ""
    var selectedEanCode = ""
    
    let dackCliamImagesAndTitle = ["Keine-glutenhaltigen-Zutaten-lt-Rezeptur":"Keine glutenhaltigen Zutaten lt. Rezeptur","Keine-laktosehaltigen-Zutaten-lt-Rezeptur":"Keine laktosehaltigen Zutaten lt. Rezeptur","Fettarm":"Fettarm","Ohne-MSG-lt-Rezeptur":"Ohne MSG lt. Rezeptur","Ohne-Farbstoffe":"Ohne Farbstoffe","Ohne-Konservierungsstoffe":"Ohne Konservierungsstoffe","Mit-Jodsalz":"Mit Jodsalz","Ohne-deklarationspflichtige-Zusatzstoffe":"Ohne deklarationspflichtige Zusatzstoffe","Ohne-deklarationspflichtige-Allergene":"Ohne deklarationspflichtige Allergene","Geeignet-fur-leichte-Vollkost":"Geeignet für leichte Vollkost","Vegan-Vegetabil":"Vegan / Vegetabil","Vegetarisch-Ovo-Lacto-Vegetabil":"Vegetarisch / Ovo Lacto Vegetabil","Alkoholfrei":"Alkoholfrei","Glutenfrei":"Glutenfrei","Laktosefrei":"Laktosefrei"]
    
    // var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WSUtility.setProductType(strType: "Unit")
        WSUtility.setQty(strQty: "1")
        addToCartBtn.setTitle(WSUtility.getlocalizedString(key:"Buy now", lang:WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        addToCartBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        cartviewHt = cartViewHtCons.constant
        cartView.isHidden = true
        cartViewHtCons.constant = 0
        
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            WSWebServiceBusinessLayer().updateExcludedProductsFromUserProfile()
        }
        serviceBussinessLayer.trackingScreens(screenName: "Product Detail Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Product Item Detail")
        FireBaseTracker.ScreenNaming(screenName: "Product Item Detail", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Product Detail Screen")
        
        // Do any additional setup after loading the view.
        //ProductDetailSectionHeaderCell
        
        // productTableView.register(UINib(nibName: "ProductDetailSectionHeaderCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSectionHeaderCell")
        productTableView.register(UINib(nibName: "ProductDetailSectionHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProductDetailSectionHeaderCell")
        productTableView.register(UINib(nibName: "WSPdNutritionTableViewCell", bundle: nil), forCellReuseIdentifier: "WSPdNutritionTableViewCell")
        productTableView.register(UINib(nibName: "WSProductDetailUseTableViewCell", bundle: nil), forCellReuseIdentifier: "WSProductDetailUseTableViewCell")
        productTableView.register(UINib(nibName: "UFSProductDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UFSProductDetailTableViewCell")
         productTableView.register(UINib(nibName: "WSNutritionFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "WSNutritionFooterTableViewCell")
        
        
        sections = [["SectionName":"","NumberOfRow":1],["SectionName":"","NumberOfRow":1],["SectionName":"","NumberOfRow":1],["SectionName":"","NumberOfRow":1],["SectionName":"Full Product Details","NumberOfRow":1],["SectionName":"Product Information","NumberOfRow":0],["SectionName":"Nutrition","NumberOfRow":2],["SectionName":"Use","NumberOfRow":0]]
        
        productTableView.rowHeight = UITableViewAutomaticDimension;
        productTableView.estimatedRowHeight = 400;
        productTableView.isHidden = true
        noProductFoundLabel.isHidden = true
        
        noProductFoundLabel.text = WSUtility.getlocalizedString(key: "Product Not found", lang: WSUtility.getLanguage(), table: "Localizable")
        
        getProductDetail()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        WSUtility.addNavigationBarBackButton(controller: self)
        WSUtility.addNavigationRightBarButton(toViewController: self)
        if SHOW_ALL_RECIPES_FROM_SAMPLE_ORDER_SUCCESS{ //on tap of explore recipes from Sample product thanky you screen.
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        WSUtility.setCartBadgeCount(ViewController: self)
      if !WSUtility.isTaxNumberAvailable(VCview: self.view){
            WSUtility.addTaxNumberView(viewController: self)
        }
        //self.tabBarController?.tabBar.isHidden = false
    }
    func btnTaxTapped(sender:UIButton)  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.callBack = {
            if let view = self.view.viewWithTag(9006){
                view.removeFromSuperview()
            }
        }
        present(vc, animated: true, completion: nil)
        
    }
    @objc func keyboardWillShow(aNotification:Notification) {
        let info = aNotification.userInfo! as NSDictionary
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
        
        productTableView.contentInset = contentInsets;
        productTableView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = view.frame
        aRect.size.height -= (kbSize?.height)!;
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:Notification)  {
        let  contentInsets = UIEdgeInsets.zero;
        productTableView.contentInset = contentInsets;
        productTableView.scrollIndicatorInsets = contentInsets;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
        WSUtility.cartButtonPressed(viewController: self)
        
    }
    func checkExcludedProductsFoundOrNotForDTO()->Bool{
        // For DTO User
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            let excludedProducts:[String] = UserDefaults.standard.value(forKey: "ExcludedProducts") as! [String]
            //print(excludedProducts)
            if let value = self.productDetailArray["number"] as? String{
                let foundExcludedProducts = excludedProducts.filter() { $0 == value }
                //print(foundExcludedProducts)
                if foundExcludedProducts.count > 0{
                    // self.showNotifyMessage(WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable"))
                    return true
                }
                return false
            }
        }
        return false
    }
    func getProductDetail()  {
        UFSProgressView.showWaitingDialog("")
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.getProductDetail(productID: productCode, successResponse: { (response) in
           // print("productDetail:%@",response)
            
            self.productDetailArray = response
            
            UFSProgressView.stopWaitingDialog()
            
            if let variants = self.productDetailArray["variantOptions"] as? [[String:Any]] {
                if variants.count < 2{
                    WSUtility.setProductType(strType: "Case")
                }
            }
            if let dict = self.productDetailArray["error"] as? [String: Any]{
                let errorCode = dict["errorCode"] as? Int
                if errorCode == 404{
                    self.noProductFoundLabel.isHidden = false
                    return
                }
            }
            
            if self.productDetailArray.count > 0{
                
                /*
                 let nutritionCollectionViewHeight = CGFloat(calculateCollectionViewHeight(productInfoCount: 7))
                 let nutritionInfo = self.productDetailArray["nutrients"] as? [[String:Any]]
                 let nutritionTableViewHeight =  CGFloat(((nutritionInfo?.count)! * 44) + 100)
                 
                 nutritionTableViewHeight = nutritionTableViewHeight + nutritionCollectionViewHeight
                 */
                
                self.getSampleOrderProductList()
                
                if let tempArray = self.productDetailArray["dachClaims"] as? [[String:Any]]{
                    self.getDachClaims(tempArrayDachClaims: tempArray)
                }
                
                var isYoutubeUrlAvailable = false
                var isBannerAvailable = false
                if let sellingStory = self.productDetailArray["sellingStory"] as? [[String:Any]]{
                    
                    //for Video
                    for dict in sellingStory {
                        
                        if let urlLink = dict["linksUrl"] as? String, urlLink.count > 0{
                            isYoutubeUrlAvailable = true
                            self.youtubeUrlLink = urlLink
                            
                        }else if let urlLink = dict["youtubeurl"] as? String,  urlLink.count > 0 {
                          isYoutubeUrlAvailable = true
                          self.youtubeUrlLink =  urlLink
                      }
                        /*
                        // for Banner
                        if let _ = dict["pictures"]{
                            isBannerAvailable = true
                            
                        }
                        */
                    }
                    
                    
                }
              
              // for Banner
              isBannerAvailable = self.checkSellingStoryCount(productDetail: self.productDetailArray)
                
                
                if isYoutubeUrlAvailable == false {
                    let videoDict = ["SectionName":"","NumberOfRow":0] as [String : Any]
                    self.sections[2] = videoDict // for video index
                    
                }
                
                if isBannerAvailable == false {
                    let videoDict = ["SectionName":"","NumberOfRow":0] as [String : Any]
                    self.sections[3] = videoDict // for image banner index
                    
                }
                
                
                
                self.productTableView.isHidden = false
                self.noProductFoundLabel.isHidden = true
                self.productTableView.reloadData()
            }
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            self.noProductFoundLabel.isHidden = false
        }
    }
    
    func getDachClaims(tempArrayDachClaims:[[String:Any]]) {
        let predicate = NSPredicate(format: "value == %@","true")
        let tempArray = tempArrayDachClaims.filter { predicate.evaluate(with: $0) }
        
        let dachClaimTempValue =  dackCliamImagesAndTitle.map { $0.1 }
        for dict in tempArray{
          if let name = dict["name"] as? String{
            if dachClaimTempValue.contains(name) {
              dachClaimArray.append(dict)
            }
          }
        }
    }
    
    func getSampleOrderProductList()  {
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        webServiceBusinessLayer.getSampleOrderProductList(successResponse: { (response) in
            
            UFSProgressView.stopWaitingDialog()
            let productVariantDict = self.filterEanCode()
            
            if response.count > 0 {
                let baseCode = self.productCode.dropLast(3)
                
                for dict in response {
                    
                    if let numberArray = dict["productNumber"] as? [String]{
                        
                        if numberArray.count > 0{
                            
                            if (numberArray[0] == self.productDetailArray["number"] as? String) || (numberArray[0] == productVariantDict["cuProductCode"]) || (numberArray[0] == productVariantDict["cuEanCode"]) || (numberArray[0] == productVariantDict["duProductCode"]) || (numberArray[0] == productVariantDict["duEanCode"]) {
                                
                                self.isSmapleOrderAvailable = true
                                self.sampleOrderDict = dict
                                print(self.sampleOrderDict)
                                // self.productTableView.rect(forSection: 1)
                                self.productTableView.reloadData()
                                
                                return
                            }
                            
                        }
                    }
                    
                    if (dict["recipeNetId"] as! String) == baseCode {
                        self.isSmapleOrderAvailable = true
                        self.sampleOrderDict = dict
                        self.productTableView.rect(forSection: 1)
                        
                        return
                        
                    }
                    
                }
                
                /*
                 let predicate = NSPredicate(format: "recipeNetId == %@",String(baseCode))
                 let filterArray = response.filter { predicate.evaluate(with: $0) }
                 if filterArray.count > 0{
                 self.isSmapleOrderAvailable = true
                 // let indexPath = IndexPath(row: 1, section: 1)
                 self.productTableView.rect(forSection: 1)
                 }
                 */
                
            }
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
        }
    }
    
    func filterEanCode() -> ([String:String]) {
        
        var productVariantDict = ["cuProductCode":"","cuEanCode":"","duProductCode":"","duEanCode":""]
        if let variants = productDetailArray["variantOptions"] as? [[String:Any]] {
            
            
            for varaintInfo in variants{
                
                let varaintDict = varaintInfo["typeOfProduct"] as? [String:Any]
                if varaintDict!["name"] as! String == "CU"{
                    
                    productVariantDict["cuProductCode"] = "\(varaintInfo["code"]!)"
                    productVariantDict["cuEanCode"] = "\(varaintInfo["ean"]!)"
                    
                }else if varaintDict!["name"] as! String == "DU"{
                    
                    productVariantDict["duProductCode"] = "\(varaintInfo["code"]!)"
                    productVariantDict["duEanCode"] = "\(varaintInfo["ean"]!)"
                }
            }
        }
        
        return productVariantDict
    }
    
  
  func checkSellingStoryCount(productDetail:[String:Any])-> Bool  {
    
    if let sellingStory = productDetail["sellingStory"] as? [[String:Any]] {
      
      if sellingStory.count > 0{
        
        
        if let pictures = sellingStory[0]["pictures"] as? [[String:Any]]{
          
          if pictures.count == 0{
            
            if let bannerImageUrl = sellingStory[0]["truthVisualImageUrl"] as? String, bannerImageUrl.count > 0 {
            
              return true
            }
            
          }else{
            
            for (index, element) in pictures.enumerated() {
              print("Item \(index): \(element)")
              
              if let bannerImageUrl = pictures[index]["imageUrl"] as? String,bannerImageUrl.count > 0 {
                
               return true
                
              }
              
              
            }
            
          }
          
        }else if let _ = sellingStory[0]["rtbImageAfterUrl"] as? String{
          
      return true
          
        }
        
      }
    }
    return false
  }
  
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is WSVideoPlayerViewController{
            let vc = segue.destination as? WSVideoPlayerViewController
            vc?.videoUrl = youtubeUrlLink
        }
        
        if segue.destination is SampleOrderStepOneViewController{
            let vc = segue.destination as? SampleOrderStepOneViewController
            vc?.prodDetailsDict = productDetailArray
            vc?.sampleOrderDict = self.sampleOrderDict
            
        }
        if segue.destination is WSProductDetailPopUpViewController{
            let vc = segue.destination as? WSProductDetailPopUpViewController
            vc?.delegateContainerType = self
            vc?.productDetailArray = productDetailArray
            vc?.isSmapleOrderAvailable = isSmapleOrderAvailable
            vc?.sampleOrderDict = sampleOrderDict
            vc?.delegateUpdateTF = self
        }
        
    }
    
    func addProductToCart(forProduct productCode:String, pQuantity: String) {
        
        /*
         let loadCart : HYBCart = backendService.currentCartFromCache()
         let webServiceBusinessLayer = WSWebServiceBusinessLayer()
         UFSProgressView.showWaitingDialog("")
         webServiceBusinessLayer.addQtyProductToCart(product: productCode, cart_id: loadCart.code!, product_qty: pQuantity, successResponse: {(response) in
         print(response)
         self.retriveCurrentCart()
         }) {(errorMessage) in
         UFSProgressView.stopWaitingDialog()
         self.showNotifyMessage(errorMessage)
         }
         */
        if checkExcludedProductsFoundOrNotForDTO(){
            return
        }
        let cartBussinesslogicHandler = WSAddToCartBussinessLogic()
        cartBussinesslogicHandler.addToCartWithQuantity(quantity: pQuantity, productCode: productCode, addedFrom: self)
        
    }
    
    func retriveCurrentCart(){
        /*
         backendService.getCartsForUserId(backendService.userId, withParams: nil, andExecute: {(_ response, _ error) in
         
         if response == nil {
         self.showNotifyMessage((error)?.localizedDescription)
         }else{
         let arr: [Any] = response as! [Any]
         let cart: HYBCart? = arr[0] as? HYBCart
         self.backendService.saveCart(inCacheNotifyObservers: cart)
         UFSProgressView.stopWaitingDialog()
         self.showNotifyMessage(WSUtility.getlocalizedString(key: "Added to cart", lang: WSUtility.getLanguage(), table: "Localizable"))
         }
         })
         UFSProgressView.stopWaitingDialog()
         
         */
    }
    
    @IBAction func addTocartBtnClicked(_ sender: UIButton){
        addProductToCart(forProduct: addToCartPC, pQuantity: productQnt)
    }
    func buyNowBtnClicked(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: "ProductDetail", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WSProductDetailPopUpViewController") as! WSProductDetailPopUpViewController
        vc.productDetailArray = productDetailArray
        vc.isSmapleOrderAvailable = isSmapleOrderAvailable
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WSProductDetailViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""{
            return true
        }
        if let num = Int(textField.text!+string){
            if textField.text?.count == 0 || textField.text == "" {
                if string == "" || string == "0"{
                    textField.text = "1"
                    return false
                }
            }
            else if num > 1000 {
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField.text == ""{
            textField.text = "1"
        }
        WSUtility.setQty(strQty: textField.text!)
        productTableView.reloadData()
    }
    
}
extension WSProductDetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section>4{
            
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductDetailSectionHeaderCell") as? ProductDetailSectionHeaderCell //tableView.dequeueReusableCell(withIdentifier: "ProductDetailSectionHeaderCell") as? ProductDetailSectionHeaderCell
            sectionHeader?.delegate = self
            let title = WSUtility.getTranslatedString(forString: (sections[section]["SectionName"] as? String)!)
            sectionHeader?.sectionTitleLabel.text = title
            sectionHeader?.section = section
            
            sectionHeader?.iconImageView.image = (sections[section]["NumberOfRow"]) as? Int == 0 ? #imageLiteral(resourceName: "plusIcon_black") : #imageLiteral(resourceName: "minusIcon_black")
            sectionHeader?.bottomSepratorView.isHidden = (sections[section]["NumberOfRow"]) as? Int == 0 ? false : true
            
            return sectionHeader
        }
        else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height =  (section <= 4) ? 0 : 60
        return CGFloat(height)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section]["NumberOfRow"] as! Int
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Banner_Image_Section{
            return 764
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == Top_Image_Section {
            
            let productImageCell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardDetailImageCollectionTableViewCell") as! WSChefRewardDetailImageCollectionTableViewCell
            productImageCell.delegate = self
            productImageCell.updateUI()
            productImageCell.productCode = productCode
            productImageCell.updateCellContent(productDetail: productDetailArray)

            if productDetailArray.count > 0{
                if let pictures = productDetailArray["pictures"] as? [[String : Any]] , pictures.count > 0{
                  productImageCell.productArray = productDetailArray
                  productImageCell.reloadCollectionViewWith(images: pictures)
                }else if let variants = self.productDetailArray["variantOptions"] as? [[String:Any]] {
                  
                  let thumbNailImage = getThumbNailImageFromVariantOption(variantOption: variants)
                  if thumbNailImage.count > 0{
                    let ImageDict = ["thumbNailImage":thumbNailImage]
                    let arrayImageDict = [ImageDict]
                    productImageCell.reloadCollectionViewWithVariantOptionImage(images: arrayImageDict)
                  }
                  
              }
              
              
                if let id = (self.productDetailArray["number"] as? NSString) {
                    //productImageCell.favouriteBtn.tag = id
                    productImageCell.productNumber = "\(id)"
                }
                productImageCell.titleLabel.text = productDetailArray["name"] as? String
            }
            
            let productNumber = (self.productDetailArray["number"] ?? "") as! NSString
            let favoriteProductList = WSUtility.getProductCode()
            if favoriteProductList.contains(productNumber as String) {
                productImageCell.isProductFavorite(isfavourite: true)
            } else {
                productImageCell.isProductFavorite(isfavourite: false)
            }
            
            // productImageCell.titleLabel.text = "Test"
            cell = productImageCell
        }else if indexPath.section == PriceAndOtherDetail_Section{
            let productAddToCartCell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardDetailAddToCartTableViewCell") as! WSChefRewardDetailAddToCartTableViewCell
            
            productAddToCartCell.delegateContainerType = self
            productNameLbl.text = productDetailArray["name"] as? String
            productAddToCartCell.isFromPDP = true
          
          /*
            var arrVariants = [[String:Any]]()
            if let variants = self.productDetailArray["variantOptions"] as? [[String:Any]] {
                arrVariants = variants
            }
 */
            productAddToCartCell.setUI()
            productAddToCartCell.updateCellContent(productDetail: productDetailArray)
            productAddToCartCell.sampleOrderButtonHeightConstraint.constant = isSmapleOrderAvailable ? 40 : 0
            productAddToCartCell.orderSampleButton.isHidden = !isSmapleOrderAvailable
            productAddToCartCell.delegate = self
            
            productAddToCartCell.orderSampleButton.addTarget(self, action: #selector(sampleOrder_Click), for: .touchUpInside)
            
            productAddToCartCell.shadowView!.layer.cornerRadius = 5
            productAddToCartCell.shadowView!.layer.shadowOffset = CGSize(width: 0, height: -20)
            productAddToCartCell.shadowView!.layer.shadowRadius = 5
            productAddToCartCell.shadowView!.layer.shadowOpacity = 0.5
            productAddToCartCell.shadowView!.layer.masksToBounds = false
            productAddToCartCell.tfQuantity.tag = indexPath.row
            productAddToCartCell.tfQuantity.delegate = self
            productAddToCartCell.tfQuantity.addDoneButtonToKeyboard(myAction:  #selector(productAddToCartCell.tfQuantity.resignFirstResponder))
            productAddToCartCell.tfQuantity.text = WSUtility.getQty()
            if let dic = productDetailArray["defaultPackagingType"] as? [String:Any]{
                if let str = dic["name"] as? String{
                    if str == "ONLYDU"{
                        productAddToCartCell.isCaseViewSelected = true
                        if !updatedOnce{
                            WSUtility.setProductType(strType: "Case")
                            updatedOnce = true
                        }
                    }
                    else if str == "ONLYCU"{
                        productAddToCartCell.isUnitViewSelected = true
                        if !updatedOnce{
                        WSUtility.setProductType(strType: "Unit")
                            updatedOnce = true
                        }
                    }
                }
            }
//            if arrVariants.count == 1{
//                    productAddToCartCell.isCaseViewSelected = true
//                }
            if WSUtility.getProductType() == "Case" {
                productAddToCartCell.selectCaseView()
            }
            else if WSUtility.getProductType() == "Unit" {
                productAddToCartCell.selectUnitView()
            }
            if productAddToCartCell.strLoyaltyPoints != ""{
                productAddToCartCell.setProductLoyaltyPoint(loyaltyPoint: productAddToCartCell.strLoyaltyPoints)
            }
            cell = productAddToCartCell
            
        }else if indexPath.section == Banner_Image_Section{
            let productBannerCell = tableView.dequeueReusableCell(withIdentifier: "WSProdDetailImageTableViewCell") as! WSProdDetailImageTableViewCell
            productBannerCell.updateCellContent(productDetail: productDetailArray)
            cell = productBannerCell
            
        }else if indexPath.section == Video_Section{
            let productVideoCell = tableView.dequeueReusableCell(withIdentifier: "ProdDetailVideoTableViewCell") as! ProdDetailVideoTableViewCell
            
            let url = URL(string:youtubeUrlLink)
            let thumbnailImagePath = "https://img.youtube.com/vi/\(url?.lastPathComponent ?? "")/hqdefault.jpg"
            productVideoCell.videoThumbnailImage.sd_setImage(with: URL(string:thumbnailImagePath), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell = productVideoCell
        }else if indexPath.section == Product_Description_Text_Section{
            let productVideoCell = tableView.dequeueReusableCell(withIdentifier: "ProdDetailTextTableViewCell") as! ProdDetailTextTableViewCell
            
            cell = productVideoCell
        }
        else if indexPath.section == Product_Information_Section {
            let productVideoCell = tableView.dequeueReusableCell(withIdentifier: "ProdDetailDescriptionTableViewCell") as! ProdDetailDescriptionTableViewCell
            productVideoCell.firstDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Product Description") //"Product Description"
            var plaintext = self.productDetailArray["properties"] as? String
            plaintext = plaintext?.replacingOccurrences(of: "\\r", with: "\n\n")
            productVideoCell.firstDescriptionValueLabel.text = plaintext //self.productDetailArray["properties"] as? String
            productVideoCell.secondDescriptionBoxLabel.text = WSUtility.getTranslatedString(forString: "Packaging") //"Packaging"
            productVideoCell.secondDescriptionValueLabel.text = selectedPackagingType
            productVideoCell.thirdDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Container")//"Container"
            productVideoCell.thirdDescriptionValueLabel.text = WSUtility.getTranslatedString(forString: selectedContainerType)
            productVideoCell.fourthDescriptionLabel.text = WSUtility.getTranslatedString(forString: "Product Codes") //"Product Codes"
            productVideoCell.fourthDescriptionValueLabel.text = "GTIN  \(selectedEanCode)"
            productVideoCell.fifthDescriptionValueLabel.text = ""
            productVideoCell.fifthDescriptionLabel.text = ""
            
            cell = productVideoCell
        }else if indexPath.section == Nutrition_Information_Section{
            
            if indexPath.row == 0 {
                
                let nutritionCell = tableView.dequeueReusableCell(withIdentifier: "WSPdNutritionTableViewCell") as! WSPdNutritionTableViewCell
                
                if self.productDetailArray.count > 0 {
                    if WSUtility.isLoginWithTurkey(){
                        if  let nutritionInfo = self.productDetailArray["nutrientTypes"] as? [Any]{
                            nutritionCell.nutritionTableViewHeightConstraint.constant =  CGFloat(((nutritionInfo.count+1) * 44) + 20)
                        }else{
                            nutritionCell.nutritionTableViewHeightConstraint.constant = 0
                        }
                    }else{
                        if  let nutritionInfo = self.productDetailArray["nutrients"] as? [[String:Any]]{
                            nutritionCell.nutritionTableViewHeightConstraint.constant =  CGFloat(((nutritionInfo.count+1) * 44) + 20)
                        }else{
                            nutritionCell.nutritionTableViewHeightConstraint.constant = 0
                        }
                    }
                    nutritionCell.updateCellContent(productDetail: self.productDetailArray)
                    nutritionCell.nutritionCollectionViewHeightConstraint.constant = CGFloat(calculateCollectionViewHeight(productInfoCount: dachClaimArray.count))
                    nutritionCell.updateCollectionView(with: dachClaimArray)
                    
                    if let portion = self.productDetailArray["portionsize"] as? Int{
                        if portion == 0{
                            nutritionCell.portionLabel.text = ""
                        }else{
                            nutritionCell.portionLabel.text = "\(WSUtility.getTranslatedString(forString: "Portion size")) = \(portion) g"
                        }
                    } else if let portion = self.productDetailArray["portionSize"] as? Int{
                        if portion == 0{
                            nutritionCell.portionLabel.text = ""
                        }else{
                            nutritionCell.portionLabel.text = "\(WSUtility.getTranslatedString(forString: "Portion size")) = \(portion) g"
                        }
                    }
                    
                }
                cell = nutritionCell
                
            }else{
                
                let footerCell = tableView.dequeueReusableCell(withIdentifier: "WSNutritionFooterTableViewCell") as!                 WSNutritionFooterTableViewCell
                if  let nutritionTable = self.productDetailArray["nutritionTable"] as? [String:Any]{
                    if  let footerTexts = nutritionTable["footertexts"] as? [String]{
                        if footerTexts.count > 0 {
                            let joinedStrings = footerTexts.joined(separator: "\n")
                            footerCell.footerTextLb.text = joinedStrings
                        }else{
                            footerCell.footerTextLb.text = ""
                        }
                    }else{
                        footerCell.footerTextLb.text = ""
                    }
                }else{
                    footerCell.footerTextLb.text = ""
                }
                cell = footerCell
            }
        }else if indexPath.section == Use_Section{
            
            let nutritionCell = tableView.dequeueReusableCell(withIdentifier: "WSProductDetailUseTableViewCell") as! WSProductDetailUseTableViewCell
            
            nutritionCell.updateCellContent(detail: productDetailArray)
            cell = nutritionCell
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Video_Section {
            self.performSegue(withIdentifier: "videoPlayerSegue", sender: self)
        }
    }
    
    func calculateCollectionViewHeight(productInfoCount:Int) -> Int {
        let height:Double = Double(Double(productInfoCount)/3.0)
        let roundedVal = height.rounded(.awayFromZero)
        let collectionCellHeight = Double((UIScreen.main.bounds.width/3) + 25)
        let cellHeight = Int(roundedVal * collectionCellHeight)
        return cellHeight
    }
  
  func getThumbNailImageFromVariantOption(variantOption:[[String:Any]]) -> String  {
    for varaintInfo in variantOption{
      
      let varaintDict = varaintInfo["typeOfProduct"] as? [String:Any]
      
      
      if varaintDict!["name"] as! String == "CU"{
        // caseLabel?.text = varaintInfo["packaging"] as? String
        if let imageUrl = varaintInfo["thumbnailUrl"] as? String{
          return imageUrl
        }
        
      }else if varaintDict!["name"] as! String == "DU" {
        if let imageUrl = varaintInfo["thumbnailUrl"] as? String{
           return imageUrl
        }
      }
    }
    return ""
  }
}

extension WSProductDetailViewController:SectionHeaderDelegate{
    func toggleSection(header: ProductDetailSectionHeaderCell, section: Int) {
        if section == Nutrition_Information_Section{ // having two row
            
            let row = sections[section]["NumberOfRow"] as! Int
            sections[section]["NumberOfRow"] = (row == 0) ? 2 : 0
            productTableView?.beginUpdates()
            productTableView.reloadSections(IndexSet(integer:section), with: .automatic)
            productTableView?.endUpdates()
            
        }else{
            let row = sections[section]["NumberOfRow"] as! Int // Having one row
            sections[section]["NumberOfRow"] = (row == 0) ? 1 : 0
            productTableView?.beginUpdates()
            productTableView.reloadSections(IndexSet(integer:section), with: .automatic)
            productTableView?.endUpdates()
        }
    }
    func sampleOrder_Click(sender: UIButton){
        if checkExcludedProductsFoundOrNotForDTO(){
            return
        }
        self.performSegue(withIdentifier: "sampleorderFirstVC", sender: self)
    }
}

extension WSProductDetailViewController:ChefRewardDetailDelegate{
    func productDetails(productCode: String, qnt: String) {
        addToCartPC = productCode
        productQnt = qnt
    }
    
    func actionOnContainerType(packagingType: String, containerType: String, eanCode: String) {
        selectedContainerType = containerType
        selectedPackagingType = packagingType
        selectedEanCode = eanCode
    }
    
    func addToCartFromDetailCell(prodCode: String, quantity: String) {
        // let prodCodeValue = originalProductCode.count == 0 ? productCode :  originalProductCode
        addProductToCart(forProduct: prodCode, pQuantity: quantity)
    }
    
    func updateCellAfterGoalSet(isGoalSet: Bool) {
        // empty
    }
    
    func showMoreProductInforamtionSection() {
        let indexPath = IndexPath(row: NSNotFound, section: 5)
        self.productTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    func updateQtyString(string:String){
    }
}
extension WSProductDetailViewController: WSChefRewardDetailImageCellDelegate{
    func showTestMessage() {
        // self.showNotifyMessage(WSUtility.getlocalizedString(key: "The product is currently not available.", lang: WSUtility.getLanguage(), table: "Localizable"))
    }
    func reloadAllProductsRow(){
        delegate?.reloadRow(cellIndex: cellIndex)
    }
}
extension WSProductDetailViewController:UIScrollViewDelegate{
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 750{
            cartViewHtCons.constant = cartviewHt!
            cartView.isHidden = false
            vwShadowLine.dropShadow(scale: true)
            
        }else{
            cartViewHtCons.constant = 0
            cartView.isHidden = true
        }
    }
}

extension WSProductDetailViewController:UpdateTextFieldDelegate{
    func updateTextFieldInProductDetail(strQuantity:String, strUnit:String){
        productTableView.reloadData()
    }
}

extension WSProductDetailViewController : ContainerTypeDelegate{
    func updateContainerType(strType: String) {
//        productTableView.reloadData()
    }
}
