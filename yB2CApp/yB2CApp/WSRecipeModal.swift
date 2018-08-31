//
//  WSRecipeModal.swift
//  yB2CApp
//
//  Created by Guddu Gaurav on 29/11/2017.
//

import UIKit

class WSRecipeModal: NSObject {
  var recipeTitle:String?
  var recipeImagePath:String?
  var recipeDescription:String?
  var recipe_Personalized_id:String?
  var status:Int16?
  var recipe_Number:String?
  var recipe_Type:String? // To determine if the home screen swipw animation function tile is "Recipe" or "Inspiration"
  var inspirationDescription:String? // To hold the inspiration description.
  
  
 class func parseRecipesDetail(dictRecipes:[[String:Any]]) -> [WSRecipeModal] {
    
    var recipes = [WSRecipeModal]()
    for dict in dictRecipes {
    
      let recipeModal = WSRecipeModal()
      recipeModal.recipeTitle = dict["title"] as? String
      recipeModal.recipeImagePath = dict["banner_image_url"] as? String //downloadImageAndSaveToDocumentsDirectory(imageUrl: (dict["banner_image"] as? String)!, imageIndex: "\(index)") //dict["banner_image"] as? String
     
      recipeModal.recipe_Personalized_id = "\(dict["recipe_id"] ?? "")"
      recipeModal.recipe_Number = "\(dict["recipe_code"] ?? "")"
      recipes.append(recipeModal)
      
    }
    
    return recipes
  }
  
}
