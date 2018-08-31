//
//  WSProductSubCategoryViewController.swift
//  yB2CApp
//
//  Created by Anandita on 11/27/17.
//

import UIKit

class WSProductSubCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var productSubCatTableView: UITableView!
  @IBOutlet weak var headerLabel: UILabel!
  var selectedCategoryDict: [String: Any] = [:]
  var prodSubCategories: [[String: Any]] = []
  var selectedIndex: Int = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    let serviceBussinessLayer =  WSWebServiceBusinessLayer()
    serviceBussinessLayer.trackingScreens(screenName: "Product Sub Category Screen")
    UFSGATracker.trackScreenViews(withScreenName: "Product Sub Category Screen")
    FireBaseTracker.ScreenNaming(screenName: "Product Sub Category Screen", ScreenClass: String(describing: self))
    FBSDKAppEvents.logEvent("Product Sub Category Screen")
    productSubCatTableView.tableFooterView = UIView(frame: CGRect.zero)
    UISetUP()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if !WSUtility.isTaxNumberAvailable(VCview: self.view){
        WSUtility.addTaxNumberView(viewController: self)
      productSubCatTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 75))
    }else if let view = self.view.viewWithTag(9006){
      view.removeFromSuperview()
       productSubCatTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    if let array = selectedCategoryDict["subcategories"] as? [[String: Any]]{
      prodSubCategories = array
      productSubCatTableView.reloadData()
    }
    if let name = selectedCategoryDict["name"] as? String{
      headerLabel.text = name
    }
    
    WSUtility.setCartBadgeCount(ViewController: self)
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
    
  func UISetUP()  {
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.addNavigationRightBarButton(toViewController: self)
  }
  
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func rightBarButtonPressed(_ sender: UIButton)  {
    WSUtility.cartButtonPressed(viewController: self)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return prodSubCategories.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
    let cell: SubCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SubCategoryTableViewCell
    let dict = prodSubCategories[indexPath.row]
    if let name = dict["name"] as? String{
      cell.nameLabel.text = name
    }else{
      cell.nameLabel.text = ""
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    return 60.0
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //  selectedIndex = indexPath.row
    self.performSegue(withIdentifier: "ProductListVC", sender: indexPath)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // get a reference to the second view controller
    if segue.identifier == "ProductListVC"{
      
      let indexpath = sender as! IndexPath
      let allProductsViewController = segue.destination as! AllProductsViewController
      
      allProductsViewController.selectedSubCategoryDict = prodSubCategories[indexpath.row]
      
    }
  }
}
