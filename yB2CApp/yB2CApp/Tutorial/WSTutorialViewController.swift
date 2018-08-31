//
//  WSTutorialViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 12/9/17.
//

import UIKit

@objc class WSTutorialViewController: UIViewController {

    
    @IBOutlet weak var joinLoyaltyLogoImage: UIImageView!
    @IBOutlet weak var firstTutorialSubHeaderLabel: UILabel!
    
    @IBOutlet weak var quickTipsfirstTutorial: UILabel!
    
    @IBOutlet weak var firstDetailFirstTutorialLabel: UILabel!
    
    @IBOutlet weak var secondTutorialSubHeaderLabel: UILabel!
    @IBOutlet weak var secondTutorialHeaderLabel: UILabel!
    
    @IBOutlet weak var secondDetailFirstTutorialLabel: UILabel!
    
    @IBOutlet weak var firstDetailSecondTutorialLabel: UILabel!
    @IBOutlet weak var quickTipsSecondTutorial: UILabel!
    
    @IBOutlet weak var scanlabel: UILabel!
    
    @IBOutlet weak var subHeaderThirdTutorialLabel: UILabel!
    
    @IBOutlet weak var firstDetailFourthTutorialLabel: UILabel!
    
    @IBOutlet weak var quickTipsThirdTutorialLabel: UILabel!
    
    @IBOutlet weak var firstDetailThirdTutorial: UILabel!
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    @IBOutlet weak var subHeaderFourthTutorialLabel: UILabel!
    
    @IBOutlet weak var saveRecipesLabel: UILabel!
    @IBOutlet weak var quickTipsFourthTutorialLabel: UILabel!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControler: UIPageControl!
    @IBOutlet weak var scrollviewContentWidth: NSLayoutConstraint!
    @IBOutlet weak var tutoirialView1: UIView!
    @IBOutlet weak var tutoirialView2: UIView!
    @IBOutlet weak var tutoirialView3: UIView!
    @IBOutlet weak var tutoirialView4: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var mSkipButton: UIButton!
    @IBOutlet weak var mNextButton: UIButton!{
        didSet{
            mNextButton.layer.borderWidth = 1.0
            mNextButton.layer.borderColor = UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0).cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinLoyaltyLogoImage.image = UIImage(named: WSUtility.isLoginWithTurkey() ? "trLoyaltyProgrammeIcon" : "TutorialchefRewards")
        self.sendActionAndLabelToGA(action: "Start Onboarding", label: "Incomplete")
        FireBaseTracker.fireBaseTrackerWith(Events: "Other", Category: "Onboarding", Action: "Start Onboarding")
        WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding", actions: "Start Onboarding", labels: "Complete")
        let tutoriaIamgesArray: [UIView] = [tutoirialView1,tutoirialView2,tutoirialView3,tutoirialView4]
        pageControler.numberOfPages = tutoriaIamgesArray.count
        var index: Int = 0;
        
        for view in tutoriaIamgesArray {
            
            view.frame = CGRect(x: (index * Int(UIScreen.main.bounds.size.width)),y: 0,width: Int(UIScreen.main.bounds.size.width),height: Int(UIScreen.main.bounds.size.height))
            imageScrollView.addSubview(view)
            index += 1
        }
        scrollviewContentWidth.constant = CGFloat(CGFloat(tutoriaIamgesArray.count) * UIScreen.main.bounds.size.width)
      
        // Do any additional setup after loading the view.
        mNextButton.setTitle(WSUtility.getlocalizedString(key: "Next", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        mSkipButton.setTitle(WSUtility.getlocalizedString(key: "Skip", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        quickTipsfirstTutorial.text = WSUtility.getlocalizedString(key: "Quick Tips Tutorail", lang: WSUtility.getLanguage(), table: "Localizable")
        
        firstDetailFirstTutorialLabel.text = WSUtility.getlocalizedString(key: "Earn loyalty points when you order with us", lang: WSUtility.getLanguage(), table: "Localizable")
        secondDetailFirstTutorialLabel.text = WSUtility.getlocalizedString(key: "Save up points and redeem them for great gifts", lang: WSUtility.getLanguage(), table: "Localizable")
        
        secondTutorialHeaderLabel.text = WSUtility.getlocalizedString(key: "Shopping List", lang: WSUtility.getLanguage(), table: "Localizable")
        secondTutorialSubHeaderLabel.text = WSUtility.getlocalizedString(key: "Easy Re-ordering", lang: WSUtility.getLanguage(), table: "Localizable")
        
        quickTipsSecondTutorial.text = WSUtility.getlocalizedString(key: "Quick Tip", lang: WSUtility.getLanguage(), table: "Localizable")
        firstDetailSecondTutorialLabel.text = WSUtility.getlocalizedString(key: "Build your list of products for easy order and re-order.", lang: WSUtility.getLanguage(), table: "Localizable")
        scanlabel.text = WSUtility.getlocalizedString(key: "Scan Tutorail", lang: WSUtility.getLanguage(), table: "Localizable")
        
        subHeaderThirdTutorialLabel.text = WSUtility.getlocalizedString(key: "Short for time?", lang: WSUtility.getLanguage(), table: "Localizable")
        
        quickTipsThirdTutorialLabel.text = WSUtility.getlocalizedString(key: "Quick Tip", lang: WSUtility.getLanguage(), table: "Localizable")
        firstDetailThirdTutorial.text = WSUtility.getlocalizedString(key: "Scan products barcodes for quick re-ordering", lang: WSUtility.getLanguage(), table: "Localizable")
        
        recipeLabel.text = WSUtility.getlocalizedString(key: "Recipes", lang: WSUtility.getLanguage(), table: "Localizable")

        subHeaderFourthTutorialLabel.text = WSUtility.getlocalizedString(key: "Recipes inspiration right at the tip of your fingers.", lang: WSUtility.getLanguage(), table: "Localizable")
        quickTipsFourthTutorialLabel.text = WSUtility.getlocalizedString(key: "Quick Tip", lang: WSUtility.getLanguage(), table: "Localizable")
        firstDetailFourthTutorialLabel.text = WSUtility.getlocalizedString(key: "Save recipes by tapping on the heart.", lang: WSUtility.getLanguage(), table: "Localizable")
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        var countryLoyaltyPoints = " "
        if let countryloyalty = UserDefaults.standard.value(forKey: COUNTRY_LOYALTY_POINTS) {
            countryLoyaltyPoints = "\(countryloyalty)"
        }
        pointsLabel.text = WSUtility.getlocalizedString(key: "Here's 50 points ,on us", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: countryLoyaltyPoints)
        
        let range = NSString(string: pointsLabel.text!).range(of: "\(WSUtility.getlocalizedString(key: "50 points", lang: WSUtility.getLanguage(), table: "Localizable")?.replacingOccurrences(of: "%@", with: countryLoyaltyPoints) ?? "")")
        let attributedString = NSMutableAttributedString(string: pointsLabel.text!)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "DINPro-Medium", size: 16.0)!, range: range)
        let range2 = NSString(string: pointsLabel.text!).range(of: countryLoyaltyPoints)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0), range: range2)
        pointsLabel.attributedText = attributedString
        if UserDefaults.standard.bool(forKey: "isFirstTimeLogin") {
            pointsLabel.isHidden = false
        }
        else{
            pointsLabel.isHidden = true
        }
         let nameString = WSUtility.getlocalizedString(key: "Welcome <First Name> to Chef Rewards.", lang: WSUtility.getLanguage(), table: "Localizable")
        welcomeLabel.text = nameString?.replacingOccurrences(of: "<%@>", with: "")
        if let firstName = UserDefaults.standard.value(forKeyPath: "FirstName"){
            welcomeLabel.text = nameString?.replacingOccurrences(of: "<%@>", with: "\(firstName)")
        }
    }
    @IBAction func skipButtonPressed(sender: UIButton){
        
        self.sendActionAndLabelToGA(action: "End Onboarding", label: "Incomplete")
        FireBaseTracker.fireBaseTrackerWith(Events: "Other", Category: "Onboarding", Action: "End Onboarding", Label: "Incomplete")
         WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding", actions: "End Onboarding", labels: "Complete")
        movetoHomeVC()
    }
    @IBAction func nextButtonPressed(sender: UIButton){
        
        mSkipButton.isHidden = false
        mNextButton.setTitle(WSUtility.getlocalizedString(key: "Next", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        
        if (imageScrollView.contentOffset.x + imageScrollView.frame.width) < imageScrollView.contentSize.width {
            var frame: CGRect = CGRect.zero
            frame.origin.x = imageScrollView.contentOffset.x + imageScrollView.frame.width
            frame.origin.y = 0
            frame.size = imageScrollView.frame.size
            imageScrollView.scrollRectToVisible(frame, animated: true)
            pageControler.currentPage =  Int(imageScrollView.contentOffset.x / imageScrollView.bounds.size.width) + 1
            
            if pageControler.currentPage == 3 {
                mSkipButton.isHidden = true
                 mNextButton.setTitle(WSUtility.getlocalizedString(key: "Finish", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
                
                mNextButton.backgroundColor = UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0)
                mNextButton.setTitleColor(UIColor.white, for: .normal)
            }
            
        }
        else{
            FBSDKAppEvents.logEvent("onboarding Button clicked")
            WSUtility.sendTrackingEvent(events: "Other", categories: "Onboarding", actions: "End Onboarding", labels: "Complete")
            FireBaseTracker .fireBaseTrackerWith(Events: "Other", Category: "Onboarding", Action: "End Onboarding", Label: "Complete")
            self.sendActionAndLabelToGA(action: "End Onboarding", label: "Complete")
            movetoHomeVC()
        }
        
    }
    
    func sendActionAndLabelToGA(action: String, label: String){
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }

            UFSGATracker.trackEvent(withCategory: "Onboarding", action: action, label: label, value: nil)
    }
    
    func movetoHomeVC(){
        UserDefaults.standard.set(true, forKey: "isExistedUserLogin")
        let delegate: HYBAppDelegate = UIApplication.shared.delegate as! HYBAppDelegate
        delegate.openHomeScreen()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mSkipButton.isHidden = false
        pageControler.currentPage =  Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
         mNextButton.setTitle(WSUtility.getlocalizedString(key: "Next", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        mNextButton.backgroundColor = UIColor.white
        mNextButton.setTitleColor(UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0), for: .normal)
        if pageControler.currentPage == 3 {
            mSkipButton.isHidden = true
            mNextButton.setTitle(WSUtility.getlocalizedString(key: "Finish", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
            mNextButton.backgroundColor = UIColor(red:1.00, green:0.35, blue:0.01, alpha:1.0)
            mNextButton.setTitleColor(UIColor.white, for: .normal)
        }
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
