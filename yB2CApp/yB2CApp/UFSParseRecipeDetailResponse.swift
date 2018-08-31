//
//  UFSParseRecipeDetailResponse.swift
//  UnileverFoodSolution
//
//  Created by Guddu Gaurav on 24/07/17.
//  Copyright © 2017 Mindtree Ltd. All rights reserved.
//

import UIKit

class UFSParseRecipeDetailResponse: NSObject {
  
  class func parseRecipeDetailResponse(responseDict:[String:Any]) -> ([UFSRecipeDetailPreparation],[UFSRecipeDetailIngredients],[UFSRecipeDetailAllIngredients])  {
    
    let prducts = responseDict["recipeSteps"] as! [[String:Any]]
    
    var preparationArray = [UFSRecipeDetailPreparation]()
    var ingredientArray = [UFSRecipeDetailAllIngredients]()
    var otherIngredientsInRecipeArray = [UFSRecipeDetailIngredients]()
    
    for prodcutDict in prducts {
      
      let preparationModel = UFSRecipeDetailPreparation()
      let ingredientsModel = UFSRecipeDetailAllIngredients()
      
      preparationModel.title = prodcutDict["title"] as! String
      preparationModel.productCode = prodcutDict["code"] as! String
      preparationModel.preparationDescription = prodcutDict["description"] as! String
      ingredientsModel.productCode = prodcutDict["code"] as! String
      // preparationModel.product = createProductIngredientDetail(productInfo: prodcutDict).0
      
      if let recipeStory =  responseDict["recipeStory"]{
        preparationModel.recipeStory = "\(recipeStory)"
      }else{
        preparationModel.recipeStory = ""
      }
      
      
      var yeildQuantity = "\(responseDict["yieldQuantity"]!)"
      yeildQuantity = (yeildQuantity.components(separatedBy: "."))[0]
      
      let combinedIngredientsAndPreparation = createProductIngredientDetail(productInfo: prodcutDict, portionQuantity: Double(yeildQuantity)!)
      preparationModel.product = combinedIngredientsAndPreparation.0
      otherIngredientsInRecipeArray.append(contentsOf: combinedIngredientsAndPreparation.1)
      ingredientsModel.ingredientTitle = prodcutDict["title"] as! String
        print("yield quantity \(ingredientsModel.yieldQuantity)")
      ingredientsModel.yieldQuantity = yeildQuantity
      ingredientsModel.allProducts = combinedIngredientsAndPreparation.2
      
      
      preparationArray.append(preparationModel)
      
      ingredientArray.append(ingredientsModel)
      
    }
    
    return (preparationArray,otherIngredientsInRecipeArray, ingredientArray)
  }
  
  class func createProductIngredientDetail(productInfo:[String:Any], portionQuantity:Double) -> ([UFSRecipeDetailIngredients],[UFSRecipeDetailIngredients],[UFSRecipeDetailIngredients]) {
    
    
    let ingredientArray = productInfo["ingredients"] as! [[String:Any]]
    var productArray = [UFSRecipeDetailIngredients]()
    var ingredientProductArray = [UFSRecipeDetailIngredients]()
    var otherIngredientsInRecipeArray = [UFSRecipeDetailIngredients]()
    for dictIngredients in ingredientArray {
      
      let preparationIngredients = UFSRecipeDetailIngredients()
      
      if dictIngredients["unileverProduct"] as! Bool == true {
        
        if  let dict = dictIngredients["product"] as? [String:Any]{
          
          
          if dict["productCode"] != nil{
            preparationIngredients.productCode = dict["productCode"] as! String
          }else{
            preparationIngredients.productCode = ""
          }
          
          if let productNumber = dict["productNumber"] as? String{
            preparationIngredients.productNumber = productNumber
          }
          
          preparationIngredients.title = dict["name"] as! String
          
          preparationIngredients.productDescription = WSUtility.getValueFromDict(dict: dict, key: "noteAddAllergen")
          preparationIngredients.imageUrl = dict["packshotUrl"] as! String
          // preparationIngredients.price = "\(String(describing: dict["duPriceInCents"]))"
          
          let countryCode =  WSUtility.getCountryCode()
          
          if countryCode == "TR" {
            preparationIngredients.price = "\(0,0) ₺"
          }
          else if countryCode == "CH" {
            preparationIngredients.price = "CHF \(0,0)"
          }
          else {
            preparationIngredients.price = "€ \(0,0)"
          }
          
          var price : Int
          if dict["cuPriceInCents"] as! Int != 0 {
            price = dict["cuPriceInCents"] as! Int
          }else{
            price = dict["duPriceInCents"] as! Int
          }
          let priceInDuble = Double(Double(price)/100)
          var strPrice = "\(priceInDuble)"
          strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
          
          if countryCode == "TR" {
            preparationIngredients.price = "\(strPrice) ₺"
          }
          else if countryCode == "CH" {
            preparationIngredients.price = "CHF \(strPrice)"
          }
          else {
            preparationIngredients.price = "€ \(strPrice)"
          }
          preparationIngredients.withOutPriceSymbol = strPrice
          
          
          preparationIngredients.isUnileverProduct = true
          preparationIngredients.quantity = "\(dictIngredients["quantity"]!) \(dictIngredients["unit"]!)"
          // preparationIngredients.baseQuantiy = "\(dictIngredients["quantity"]!)"
          let baseQuantity = Double (Double("\(dictIngredients["quantity"]!)")! / Double(portionQuantity))
          preparationIngredients.baseQuantiy = "\(baseQuantity)"
          if let eanCode = dict["eanCode"]{
            preparationIngredients.eanCode = "\(eanCode)"
          }else if let cuEanCode = dict["cuEanCode"]{
            preparationIngredients.eanCode = "\(cuEanCode)"
          }else if let duEanCode = dict["duEanCode"]{
            preparationIngredients.eanCode = "\(duEanCode)"
          }else{
            preparationIngredients.eanCode = "123"
          }
          if let duEanCode = dict["duEanCode"]{
            preparationIngredients.duEanCode = "\(duEanCode)"
          }
          if let loyaltyPoint = dict["cuLoyaltyPoints"] as? Int, loyaltyPoint != 0{
            preparationIngredients.loyaltyPoint = "\(loyaltyPoint)"
          } else if let loyaltyPoint = dict["duLoyaltyPoints"]{
            preparationIngredients.loyaltyPoint = "\(loyaltyPoint)"
          }
          
          if productArray.count > 0 {
            // creating array for other ingredients in Preparations
            otherIngredientsInRecipeArray.append(preparationIngredients)
          }else{
            // Creating Array for Preparation Segment
            productArray.append(preparationIngredients)
            otherIngredientsInRecipeArray.append(preparationIngredients)
          }
          
          // Creating Array for Ingredients Segment
          ingredientProductArray.append(preparationIngredients)
          
        }
        
        
      }else{
        
        preparationIngredients.isUnileverProduct = false
        preparationIngredients.title = dictIngredients["ingredientName"] as! String
        
        preparationIngredients.quantity = "\(dictIngredients["quantity"]!) \(dictIngredients["unit"]!)"
        ingredientProductArray.append(preparationIngredients)
        //preparationIngredients.baseQuantiy = "\(dictIngredients["quantity"]!)"
        let baseQuantity = Double (Double("\(dictIngredients["quantity"]!)")! / Double(portionQuantity))
        preparationIngredients.baseQuantiy = "\(baseQuantity)"
        
        /*
         if dictIngredients["cuPriceInCents"] as! Int == 0 {
         preparationIngredients.price = "€ 0,0"
         }else{
         let price = dictIngredients["cuPriceInCents"] as! Int
         let priceInDuble = Double(price/100)
         var strPrice = "\(priceInDuble)"
         strPrice = strPrice.replacingOccurrences(of: ".", with: ",")
         preparationIngredients.price = "€ \(strPrice)"
         }
         */
        
        // print(preparationIngredients.quantity)
        
      }
      
    }
    
    return (productArray,otherIngredientsInRecipeArray,ingredientProductArray)
  }
  
  
}


