//
//  WSFavouriteListBaseViewController.swift
//  yB2CApp
//
//  Created by Ramakrishna on 11/26/17.
//

import UIKit

class WSFavouriteListBaseViewController: BaseViewController,NoInternetDelegate,NetworkStatusDelegate {

    @IBOutlet weak var extendedViewHeightConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var shoppingListButton: UIButton!
    @IBOutlet weak var seperatorX: NSLayoutConstraint!
    @IBOutlet weak var noShoppinglistView: UIView!
    
    @IBOutlet weak var shopNowButton: UIButton!
    @IBOutlet weak var shopSubHeaderLabel: UILabel!
    @IBOutlet weak var orderHeaderLabel: UILabel!
    var controllers = [UIViewController]()
    var pageViewController:UIPageViewController?
    var noInternetView:UFSNoInternetView?
    var currentIndex = 0
    let networkStatus = UFSNetworkReachablityHandler.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        networkStatus.startNetworkReachabilityObserver()
        addSlideMenuButton()
        shopNowButton.alpha = 1.0
        scanButton.alpha = 0.4
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: DTO_OPERATOR){
            WSWebServiceBusinessLayer().updateExcludedProductsFromUserProfile()
        }
        UITexts()
        networkStatus.delegate = self
        networkCheckAndApiCall()
      if !WSUtility.isTaxNumberAvailable(VCview: self.view){
            WSUtility.addTaxNumberView(viewController: self)
        }
      WSUtility.setCartBadgeCount(ViewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WSUtility.removeNoNetworkView(internetView: &noInternetView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let serviceBussinessLayer =  WSWebServiceBusinessLayer()
        serviceBussinessLayer.trackingScreens(screenName: "Shopping Listing Screen")
    }

    func btnTaxTapped(sender:UIButton)  {
        let storyBoard: UIStoryboard = UIStoryboard(name: "EnterTaxNumberStoryboard", bundle: nil)
      let vc:WSEnterTaxNumberViewController = storyBoard.instantiateViewController(withIdentifier: "WSEnterTaxNumberViewController") as! WSEnterTaxNumberViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
      vc.callBack = {
        if let view = self.view.viewWithTag(9006){
          view.removeFromSuperview()
        }
        self.networkCheckAndApiCall()
      }

      present(vc, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func UITexts() {
        shopNowButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shopNowButton.setTitle(WSUtility.getlocalizedString(key: "Shop now", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        shoppingListButton.setTitle(WSUtility.getlocalizedString(key: "Shopping List", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        scanButton.setTitle(WSUtility.getlocalizedString(key: "Scan", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        orderHeaderLabel.text = WSUtility.getlocalizedString(key: "You have not placed an order with us yet.", lang: WSUtility.getLanguage(), table: "Localizable")
        shopSubHeaderLabel.text = WSUtility.getlocalizedString(key: "Shop with us and earn points for great gifts.", lang: WSUtility.getLanguage(), table: "Localizable")
    }
    
    func initializePageViewController()  {
        let storyBoard = UIStoryboard(name: "ShoppingList", bundle: nil)
        pageViewController = storyBoard.instantiateViewController(withIdentifier: "GenericPageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        
        if let firstViewController = controllers.first {
            pageViewController?.setViewControllers([firstViewController],
                                                   direction: .forward,
                                                   animated: true,
                                                   completion: nil)
        }
        
        pageViewController?.view.frame = CGRect(x: 0, y: extendedViewHeightConstraint.constant , width: self.view.frame.size.width, height: self.view.frame.size.height - (extendedViewHeightConstraint.constant))
    
        self.addChildViewController(pageViewController!)
        view.addSubview((pageViewController?.view)!)
        pageViewController?.didMove(toParentViewController: self)
      
//      if !WSUtility.isTaxNumberAvailable(){
//        WSUtility.addTaxNumberView(viewController: self)
//      }
        
    }
    func networkCheckAndApiCall()  {
        if (UFSNetworkReachablityHandler().reachabilityManager?.isReachable)!{
            ReachableNetwork()
        }else{
            NonReachableNetwork()
        }
    }

    func reloadView() {
        networkCheckAndApiCall()
    }

    func ReachableNetwork() {
        navigationBarSetUp()
        WSUtility.removeNoNetworkView(internetView: &noInternetView)
    }

    func NonReachableNetwork() {
        if noInternetView == nil {
            WSUtility.loadNoInternetView(internetView: &noInternetView, controllerView: self)
        }
    }

    func navigationBarSetUp()  {
        let storyBoard = UIStoryboard(name: "ShoppingList", bundle: nil)
        guard controllers.count != 2 else {
            return
        }
        
        controllers.removeAll()
        pageViewController?.view.removeFromSuperview()
        pageViewController?.removeFromParentViewController()
        
        let FavViewController: WSFavouriteShoppingListViewController = storyBoard.instantiateViewController(withIdentifier: "ShoppingListViewControllerID") as! WSFavouriteShoppingListViewController
        FavViewController.delegate = self
        controllers = [FavViewController]
        initializePageViewController()
        
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        if ((controllers.count == 0) || (index >= controllers.count)) {
            return UIViewController()
        }
        
        return controllers[index]
        
    }
    @IBAction func shoppingListButtonAction(_ sender: UIButton) {
        
        seperatorX.constant = 0
        shopNowButton.alpha = 1.0
        scanButton.alpha = 0.4
        if let scanListVC = controllers.first {
            pageViewController?.setViewControllers([scanListVC],
                                                   direction: .reverse,
                                                   animated: true,
                                                   completion: nil)
        }
        
    }
    
  @IBAction func shopNowButtonAction(_ sender: UIButton) {
    self.tabBarController?.selectedIndex = 2
  }
  @IBAction func scanListButtonAction(_ sender: UIButton) {
        
        seperatorX.constant = UIScreen.main.bounds.size.width / 2
        shopNowButton.alpha = 0.4
        scanButton.alpha = 1.0
        if let shoppingListVC = controllers.last {
            pageViewController?.setViewControllers([shoppingListVC],
                                                   direction: .forward,
                                                   animated: true,
                                                   completion: nil)
        }
        
    }
}
extension WSFavouriteListBaseViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        return controllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = controllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return controllers[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if self.pageViewController?.viewControllers?.last is WSFavouriteShoppingListViewController {
            seperatorX.constant = 0
            currentIndex = 0
            shopNowButton.alpha = 1.0
            scanButton.alpha = 0.4
        }else{
            seperatorX.constant = UIScreen.main.bounds.size.width / 2
            currentIndex = 1
            shopNowButton.alpha = 0.4
            scanButton.alpha = 1.0
        }
        
    }
    
}

extension WSFavouriteListBaseViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == controllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == controllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
}

extension WSFavouriteListBaseViewController: WSFavouriteShoppingListViewDelegate{
    func showHideNoFavouriteView(showHide: Bool){
        if showHide{
            noShoppinglistView.isHidden = true
          pageViewController?.view.isHidden = false
          
        }
        else{
            controllers.removeAll()
            //pageViewController?.view.removeFromSuperview()
           // pageViewController?.removeFromParentViewController()
          pageViewController?.view.isHidden = true
            noShoppinglistView.isHidden = false
        }
    }
  
  func addToCartMethod(productCode: String, quantity: String) {
     let cartBussinesslogicHandler = WSAddToCartBussinessLogic()
    cartBussinesslogicHandler.addToCartWithQuantity(quantity: quantity, productCode: productCode, addedFrom:self)
  }
  
}
