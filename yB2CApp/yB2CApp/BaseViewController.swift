//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
   // var backendService:HYBB2CService = (UIApplication.shared.delegate as! HYBAppDelegate).backEndService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("My UFS\n", terminator: "")
            
            if (getTopViewController() is WSFavouriteShoppingListViewController ) || (getTopViewController() is WSRecipeOverViewViewController ) || (getTopViewController() is SearchViewController ){
                self.tabBarController?.selectedIndex = 0
                return
            }
            
            
            self.openViewControllerBasedOnIdentifier("Home")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("ChefRewardLandingID")
            break
        case 3:
            print("Scan\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ScanVCID")
            
            break
        case 4:
            print("Notifications", terminator: "")
            self.openViewControllerBasedOnIdentifier("MyNotificationViewControllerID")
            
            break
        case 5:
            print("Order History", terminator: "")
            break
        case 6:
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController : UIViewController? = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController? = self.navigationController!.topViewController!
        
        if (topViewController?.restorationIdentifier! == destViewController?.restorationIdentifier!){
            print("Same VC")
        } else {
            // destViewController?.hidesBottomBarWhenPushed = true
            //self.navigationController?.popToViewController(topViewController, animated: false)
            self.navigationController!.pushViewController(destViewController!, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(UIImage(named:"hamburger_copy.png") , for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
        
        let btnShowCart = UIButton(type: UIButtonType.system)
        btnShowCart.setImage(#imageLiteral(resourceName: "WebShop-ShoppingCart"), for: UIControlState())
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btnShowCart.addTarget(self, action: #selector(BaseViewController.cartButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        self.navigationItem.rightBarButtonItem = customRightBarItem;
        
        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 63, height: 25))
        logoImage.image = UIImage(named: "UFS_Logotype_RGB")
        logoImage.contentMode = .scaleAspectFit
        logoImage.autoresizingMask = .flexibleWidth
        self.navigationItem.titleView = logoImage
        
        
    }
    
    func getTopViewController() -> UIViewController {
        let topViewController : UIViewController? = self.navigationController!.topViewController!
        return topViewController!
    }
    
    //    func defaultMenuImage() -> UIImage {
    //        var defaultMenuImage = UIImage()
    //
    //        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
    //
    //        UIColor.black.setFill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
    //
    //        UIColor.white.setFill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
    //        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
    //
    //        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
    //
    //        UIGraphicsEndImageContext()
    //
    //        return defaultMenuImage;
    //    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let menuVC : MenuViewController = mainStoryBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(menuVC.view)
        
        // self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        // for DTO
        UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    
    func cartButtonPressed(_ sender : UIButton){
        /*
         if let loadCart : HYBCart = backendService.currentCartFromCache() {
         if((loadCart.deliveryItemsQuantity).intValue > 0){
         let storyboard = UIStoryboard(name: "Cart", bundle: nil)
         let cartView =  storyboard.instantiateViewController(withIdentifier: "CartViewC") as! HYBCartController
         self.navigationController?.pushViewController(cartView, animated: true)
         }else{
         callEmptyCart()
         }
         }else{
         callEmptyCart()
         }
         */
        
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartView =  storyboard.instantiateViewController(withIdentifier: "CartViewC") as! HYBCartController
        self.navigationController?.pushViewController(cartView, animated: true)
        
    }
    
    func callEmptyCart(){
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let cartView =  storyboard.instantiateViewController(withIdentifier: "EmptyCartView") as! EmptyCartViewController
        self.navigationController?.pushViewController(cartView, animated: true)
    }
}
