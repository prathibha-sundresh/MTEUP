//
//  WSChefRewardLandingViewController.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 27/11/2017.
//

import UIKit

class WSChefRewardLandingViewController: BaseViewController {
  
    @IBOutlet weak var rewardsTableView: UITableView!
    @IBOutlet weak var rewardCategoriesLabel: UILabel!
    @IBOutlet weak var pointsBalanceLabel: UILabel!
  
    var loyaltyRewards = [[String:Any]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Chef Rewards Screen")
        UFSGATracker.trackScreenViews(withScreenName: "Chef Rewards Screen")
        FireBaseTracker.ScreenNaming(screenName: "Chef Rewards Screen", ScreenClass: String(describing: self))
        FBSDKAppEvents.logEvent("Chef Rewards Screen")
        // Do any additional setup after loading the view.
        UISetUP()
        
        //GBL_RL
        getRewards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func UISetUP()  {
    /*
    addSlideMenuButton()
    let pointsBalance = "600"
    let pointsBalanceText = "Your points balance \(pointsBalance)" // Have to set the values dynamically
    let attributedString = NSMutableAttributedString(string: pointsBalanceText, attributes:[NSFontAttributeName:
        UIFont(name: "DinPro-Medium", size: 16.0)!])
    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255.0 / 255.0, green: 90.0 / 255.0, blue: 0.0 / 255.0, alpha: 1) , range: NSRange(location: 20, length: pointsBalance.characters.count))
    pointsBalanceLabel.attributedText = attributedString
    */
    
    // dont uncomment the above line
    WSUtility.addNavigationBarBackButton(controller: self)
    WSUtility.setLoyaltyPoint(label: pointsBalanceLabel)
    rewardCategoriesLabel.text = WSUtility.getlocalizedString(key: "Reward Categories", lang: WSUtility.getLanguage(), table: "Localizable")
    
  }
  
    //GBL_RL
    // API Call
    func getRewards()  {
        UFSProgressView.showWaitingDialog("")
      
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.makeLoyaltyRewardsRequest(methodName: "", skip: "\(0)", take: "10", successResponse: { (response) in
            UFSProgressView.stopWaitingDialog()
            let dictResponse = response as! [String:Any]
            print(dictResponse)
            if let keyWordsDict = dictResponse["keywords"] as? NSDictionary {

                if !WSUtility.isLoginWithTurkey(){
                    self.loyaltyRewards.append(["name":"All rewards","slugifiedName":"*"])
                }
            let dict = keyWordsDict["categories"] as! [[String:Any]]
            self.loyaltyRewards.append(contentsOf: dict)
            
            self.rewardsTableView.reloadData()
            }
            
        }) { (errorMessage) in
            
            UFSProgressView.stopWaitingDialog()
        }
    }
    
  @IBAction func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
 
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      
        if segue.destination is WSLoyaltyListerViewController{
            let dict = sender as? [String:Any]
            let loyaltyLister = segue.destination as? WSLoyaltyListerViewController
            loyaltyLister?.selectedCategoryName = WSUtility.getTranslatedString(forString: dict!["name"]! as! String) //dict!["Name"] as! String
            let str =  dict!["slugifiedName"]! as! String
          /*
            if !WSUtility.isLoginWithTurkey(){
                loyaltyLister?.selectedCategoryCode = str
            }
            else{
                loyaltyLister?.selectedCategoryCode = "*"
            }
            */
          
          loyaltyLister?.selectedCategoryCode = str
        }
    }

}
extension WSChefRewardLandingViewController : UITableViewDataSource, UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return loyaltyRewards.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WSChefRewardLandingTableViewCell") as! WSChefRewardLandingTableViewCell
    let categoryDict = loyaltyRewards[indexPath.row]
    cell.titlelable.text = WSUtility.getTranslatedString(forString: categoryDict["name"]! as! String)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let categoryDict = loyaltyRewards[indexPath.row]
    self.performSegue(withIdentifier: "ShowSetGoalVC", sender: categoryDict)
  }
  
}
