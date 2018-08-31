//
//  WSAddToCartBussinessLogic.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 30/12/2017.
//

import UIKit

class WSAddToCartBussinessLogic: NSObject {
    var currentViewController = UIViewController()
    var currentProductCode = ""
    
    var isLoginAPICalled = false
    var isActiveCartAPICallForQuantity = true
    var productQuantity = "1"
    var apiIncrementValue = 0
  
    func addProductToCart(forProduct productCode:String, addedFrom viewController:UIViewController) {
        
        guard !productCode.isEmpty else {
            return
        }
        
        isActiveCartAPICallForQuantity = false
        currentViewController = viewController
        currentProductCode = productCode
        addToCartAPICall()
        
    }
    
    func addToCartAPICall()  {
        
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.addToCart(product: currentProductCode, cart_id: UFSHybrisUtility.uniqueCartId, successResponse:{ (response) in
            print(response)
           // UFSProgressView.stopWaitingDialog()
            self.retriveCurrentCart(afterProductAddedToCart: true)
            
        }) { (errorMessage) in
           // UFSProgressView.stopWaitingDialog()
            print(errorMessage)
          
          /*
          if errorMessage .hasPrefix("Cannot find user with uid"){
            WSSoftLoginHandler().doSoftLogin(success: {
              if self.apiIncrementValue == 0{
                self.apiIncrementValue = 1
                self.addToCartAPICall()
              }else{
                UFSProgressView.stopWaitingDialog()
              }
            }, failure: { (errorMessage) in
              UFSProgressView.stopWaitingDialog()
            })
          }else{
            UFSProgressView.stopWaitingDialog()
            WSUtility.showAlertWith(message: errorMessage, title: "", forController: self.currentViewController)
          }
          
          */
          
          self.doSoftLoginAfterUserNotFound(errorMessage: errorMessage, viewController: self.currentViewController, success: {
            self.addToCartAPICall()
          })
          
        }
        
    }
    
    func addToCartWithQuantity(quantity:String, productCode:String, addedFrom viewController:UIViewController){
        
        guard !productCode.isEmpty else {
            
            return
        }
        
        productQuantity = quantity
        isActiveCartAPICallForQuantity = true
        currentViewController = viewController
        currentProductCode = productCode
        
        let webServiceBusinessLayer = WSWebServiceBusinessLayer()
        UFSProgressView.showWaitingDialog("")
        webServiceBusinessLayer.addQtyProductToCart(product: productCode, cart_id: UFSHybrisUtility.uniqueCartId, product_qty: quantity, successResponse: {(response) in
            print(response)
            self.retriveCurrentCart(afterProductAddedToCart: true)
        }) {(errorMessage) in
          
          
          self.doSoftLoginAfterUserNotFound(errorMessage: errorMessage, viewController: viewController, success: {
            self.addToCartWithQuantity(quantity: quantity, productCode: productCode, addedFrom: viewController)
          })
          
          
        }
        
    }
  
    //MARK: Get Cart From Backend
    func retriveCurrentCart(afterProductAddedToCart:Bool){
        
        UFSProgressView.showWaitingDialog("")
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getCartsForUserId(userId: "", params: ["":""], successResponse:{ (response) in
            print(response)
            UFSProgressView.stopWaitingDialog()
            //self.currentViewController.showNotifyMessage(WSUtility.getlocalizedString(key: "Added to cart", lang: WSUtility.getLanguage(), table: "Localizable"))
            WSUtility.setCartBadgeCount(ViewController: self.currentViewController)
            UFSProgressView.stopWaitingDialog()
            
        }) { (errorMessage) in
            UFSProgressView.stopWaitingDialog()
            print(errorMessage)
        }
    }
    
    
    func getCartDetail(forController viewController:UIViewController?)  {
        
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.getCartsForUserId(userId: "", params: ["":""], successResponse:{ (response) in
            print(response)
            if(viewController != nil){
                WSUtility.setCartBadgeCount(ViewController: viewController!)
            }else{
                //WSUtility.setCartBadgeCount(ViewController: nil)
            }
            
            UFSProgressView.stopWaitingDialog()
        }) { (errorMessage) in
            print(errorMessage)
          
          if errorMessage .hasPrefix("Cannot find user with uid"){
            
            self.doSoftLoginAfterUserNotFound(errorMessage: errorMessage, viewController: self.currentViewController, success: {
              UFSProgressView.stopWaitingDialog()
            })
            
          }else{
            
            if(viewController != nil){
              self.createCartForUSer(forController: viewController!)
            }else{
              self.createCartForUSer(forController: nil)
            }
            
          }
          
          
          
        }
        
    }
    
    func createCartForUSer(forController viewController:UIViewController?)  {
        
        let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
        businessLayer.createCartForUserId(userId: "", params: ["":""], successResponse:{ (response) in
            print(response)
            
        }) { (errorMessage) in
            print(errorMessage)
        }
        
    }
  
  /*
  func updateCart(entryNumber:String, cartQuantity:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliureResponse:@escaping (_ errorMessage:String) -> Void)  {
    
    let cartId = UFSHybrisUtility.uniqueCartId
    let businessLayer: WSWebServiceBusinessLayer = WSWebServiceBusinessLayer()
    businessLayer.replaceCartEntryForUserId(cartId: cartId, entryNumber: entryNumber, cartQuantity: cartQuantity, successResponse: { (response) in
      successResponse(response)
    }) { (errorMessage) in
      faliureResponse(errorMessage)
    }
    
    
  }
  */
  
  func doSoftLoginAfterUserNotFound(errorMessage:String,viewController:UIViewController,success:@escaping ()-> Void)  {
    
    if errorMessage .hasPrefix("Cannot find user with uid"){
      WSSoftLoginHandler().doSoftLogin(success: {
        if self.apiIncrementValue == 0{
          self.apiIncrementValue = 1
         // self.addToCartWithQuantity(quantity: quantity, productCode: productCode, addedFrom: viewController)
          success()
        }else{
          UFSProgressView.stopWaitingDialog()
        }
      }, failure: { (errorMessage) in
        UFSProgressView.stopWaitingDialog()
      })
    }else{
      UFSProgressView.stopWaitingDialog()
      WSUtility.showAlertWith(message: errorMessage, title: "", forController: viewController)
    }
    
  }
  
    
}

