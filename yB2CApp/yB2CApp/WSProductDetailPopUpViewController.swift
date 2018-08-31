//
//  WSProductDetailPopUpViewController.swift
//  UFSDev
//
//  Created by Naveen Kumar k N on 29/03/18.
//

import UIKit
@objc protocol UpdateTextFieldDelegate {
    func updateTextFieldInProductDetail(strQuantity:String, strUnit:String)
}
class WSProductDetailPopUpViewController: UIViewController {
    var isEdited = false
    weak var delegateUpdateTF:UpdateTextFieldDelegate?
    var strContainerType = "Case"
    var strQuantityCount = "1"
    @IBOutlet weak var vwBase: UIView!
    @IBOutlet weak var productDetailPopupTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    var productDetailArray:[String:Any]?
    var sampleOrderDict = [String:Any]()
    weak var delegateContainerType:ContainerTypeDelegate?
    var isSmapleOrderAvailable:Bool?
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        // Sets the status bar to hidden when the view has finished appearing
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        // Sets the status bar to visible when the view is about to disappear
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.setTitle(WSUtility.getlocalizedString(key: "Cancel", lang: WSUtility.getLanguage(), table: "Localizable")! + "  X", for: .normal)
        vwBase.dropShadow(scale: true)
        productDetailPopupTableView.register(UINib(nibName: "WSCustomChefRewardDetailAddToCartTableViewCell", bundle: nil), forCellReuseIdentifier: "WSCustomChefRewardDetailAddToCartTableViewCell")
        productDetailPopupTableView.register(UINib(nibName: "ProductNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        delegateUpdateTF?.updateTextFieldInProductDetail(strQuantity: strQuantityCount, strUnit: strQuantityCount)
        self.navigationController?.popViewController(animated: true)
    }
    func addProductToCart(forProduct productCode:String, pQuantity: String) {
        let cartBussinesslogicHandler = WSAddToCartBussinessLogic()
        cartBussinesslogicHandler.addToCartWithQuantity(quantity: pQuantity, productCode: productCode, addedFrom: self)
        
    }
}

extension WSProductDetailPopUpViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == ""{
            return true
        }
        let num = Int(textField.text!+string)
        if textField.text?.count == 0 || textField.text == "" {
            if string == "" || string == "0"{
                textField.text = "1"
                return false
            }
        }
        else if num! > 1000 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField.text == ""{
            textField.text = "1"
        }
        WSUtility.setQty(strQty: textField.text!)
        productDetailPopupTableView.reloadData()
    }
}
extension WSProductDetailPopUpViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productAddToCartCell = tableView.dequeueReusableCell(withIdentifier: "WSCustomChefRewardDetailAddToCartTableViewCell") as! WSCustomChefRewardDetailAddToCartTableViewCell
        productAddToCartCell.delegateContainerType = self
        productAddToCartCell.setUI()
        productAddToCartCell.updateCellContent(productDetail: productDetailArray!)
        productAddToCartCell.sampleOrderButtonHeightConstraint.constant = isSmapleOrderAvailable! ? 40 : 0
        productAddToCartCell.orderSampleButton.isHidden = !isSmapleOrderAvailable!
        productAddToCartCell.isSmapleOrderAvailable = isSmapleOrderAvailable!
        productAddToCartCell.delegate = self
        productAddToCartCell.tfQuantity.tag = indexPath.row
        productAddToCartCell.tfQuantity.delegate = self
        productAddToCartCell.tfQuantity.addDoneButtonToKeyboard(myAction:  #selector(productAddToCartCell.tfQuantity.resignFirstResponder))
        if WSUtility.getProductType() == "Case" {
            productAddToCartCell.selectCaseView()
        }
        else if WSUtility.getProductType() == "Unit"{
            productAddToCartCell.selectUnitView()
        }
        productAddToCartCell.tfQuantity.text = WSUtility.getQty()
        if productAddToCartCell.strLoyaltyPoints != ""{
            productAddToCartCell.setProductLoyaltyPoint(loyaltyPoint: productAddToCartCell.strLoyaltyPoints)
        }

        return productAddToCartCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell") as! ProductNameTableViewCell
        sectionHeader.productNameLbl.text = productDetailArray!["name"] as? String
        return sectionHeader
    }
    
}
extension WSProductDetailPopUpViewController:ChefRewardDetailDelegate{
    func updateCellAfterGoalSet(isGoalSet: Bool) {
        
    }
    
    func actionOnContainerType(packagingType: String, containerType: String, eanCode: String) {
        strContainerType = containerType
    }
    
    func showMoreProductInforamtionSection() {
        
    }
    func addToCartFromDetailCell(prodCode: String, quantity: String) {
        addProductToCart(forProduct: prodCode, pQuantity: quantity)
    }
    func ScreenNavigateDelegate() {
        let storyboard = UIStoryboard(name: "SampleOrder", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SampleOrderStepOneViewControllerID") as! SampleOrderStepOneViewController
        vc.prodDetailsDict = productDetailArray!
        vc.sampleOrderDict = self.sampleOrderDict
        self.navigationController?.pushViewController(vc,animated: true)
    }
    func updateQtyString(string:String){
//        strQuantityCount = string
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func dropShadowForCheckout(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func dropTopAndBottomShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 1.5)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropTopShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: -1.5)
        layer.shadowRadius = 1.5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension WSProductDetailPopUpViewController : ContainerTypeDelegate{
    func updateContainerType(strType: String) {
        strContainerType = strType
        delegateContainerType?.updateContainerType(strType: strType)
    }
}
