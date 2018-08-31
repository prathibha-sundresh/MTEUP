//
//  UFSPopUpViewController.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 23/06/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSPopUpViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var popUpTableView: UITableView!
  
  var arrayItems = [String]()
  var selectedItem = ""
    var callBack: ((_ itemName:String) -> Void)?
  var titleString:String = ""
  var isSearchBarHidden = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 0.6)
    //self.titleLabel.text = titleString
    self.updateLabelForLanguage()
    if isSearchBarHidden {
      searchBoxHeightConstraint.constant = 0
    }
    
    popUpTableView.estimatedRowHeight = 55
    popUpTableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func crossButtonTapped(_ sender: UIButton) {
//    if let callBackBlock = callBack{
//      callBackBlock(selectedItem)
//    }
    self.dismiss(animated: true, completion: nil)
  }
  
  func passValueToParentViewController()  {
    if let callBackBlock = callBack{
      callBackBlock(selectedItem)
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension UFSPopUpViewController:UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UFSUpdateLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UFSUpdateLocationTableViewCell") as! UFSUpdateLocationTableViewCell
    
    
    cell.nameLabel.text = arrayItems[indexPath.row]
    
    if arrayItems[indexPath.row] == selectedItem {
      cell.hideOrShowRightIndicatorViewForCell(cell: cell, state: false)
    }else{
      cell.hideOrShowRightIndicatorViewForCell(cell: cell, state: true)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    selectedItem = arrayItems[indexPath.row]
    popUpTableView.reloadData()
    
    passValueToParentViewController()
    
    /*
    if selectedItem == "Turkish" {
        UserDefaults.standard.set("tr", forKey: "lang")
    }*/
    if selectedItem == "German"{
        UserDefaults.standard.set("de", forKey: "lang")
    }
    else if selectedItem == "English"{
        UserDefaults.standard.set("en", forKey: "lang")
     
    }
    
    self.updateLabelForLanguage()

    
  }

    func updateLabelForLanguage(){
        
        guard let value = String(titleString) else {
            return
        }
        
        if value == "Update Location" {
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Update Location", lang:WSUtility.getLanguage(), table: "Localizable")
        }
        else if value == "Change Language"{
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Change Language", lang:WSUtility.getLanguage(), table: "Localizable")
        }
        else if value == "Select a business type"{
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select a business type", lang:WSUtility.getLanguage(), table: "Localizable")
        }
        else if value == "Select a country"{
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select a country", lang:WSUtility.getLanguage(), table: "Localizable")
        }
        else if value == "Select Distributor"{
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select Distributor", lang:WSUtility.getLanguage(), table: "Localizable")
        }else if value == "Select tradepartner"{
           self.titleLabel.text = WSUtility.getlocalizedString(key:"Select a Trade Partner", lang:WSUtility.getLanguage(), table: "Localizable")
          
        }else if value == "Select tradepartner location"{
          self.titleLabel.text = WSUtility.getlocalizedString(key:"Select tradepartner location", lang:WSUtility.getLanguage(), table: "Localizable")
          
        } else if value == "Select a month" {
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select a month", lang:WSUtility.getLanguage(), table: "Localizable")
            
        } else if value == "Select a year" {
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select a year", lang:WSUtility.getLanguage(), table: "Localizable")
            
        } else if value == "Select a city" {
            self.titleLabel.text = WSUtility.getlocalizedString(key:"Select your city", lang:WSUtility.getLanguage(), table: "Localizable")
        }
    }
  
  
}

