import UIKit
import Parse

class MenuManager: NSObject {
    var user: User?
    
//    var recipeId: String
    var recipeTitle: String
    var recipeUrl: String
    var foodImageUrl: String
//    var mediumImageUrl: String
//    var smallImageUrl: String
//    var pickup: String
//    var shop: String
//    var nickname: String
    var recipeDescription: String
//    var recipeMaterial: String
    var recipeIndication: String
    var recipeCost: String
//    var recipePublishday: String
//    var rank: String

    init(recipeTitle: String, recipeUrl: String, foodImageUrl: String, recipeDescription: String,  recipeIndication: String, recipeCost: String) {
        self.recipeTitle = recipeTitle
        self.recipeUrl = recipeUrl
        self.foodImageUrl = foodImageUrl
        self.recipeDescription = recipeDescription
        self.recipeIndication = recipeIndication
        self.recipeCost = recipeCost
    }

    //Parseへ保存
    func save(){
        let menumanagerObject = PFObject(className: "MenuManager")
        menumanagerObject["recipeTitle"] = recipeTitle
        menumanagerObject["recipeUrl"] = recipeUrl
        menumanagerObject["foodImageUrl"] = foodImageUrl
        menumanagerObject["recipeDescription"] = recipeDescription
        menumanagerObject["recipeIndication"] = recipeIndication
        menumanagerObject["recipeCost"] = recipeCost
        menumanagerObject["user"] = PFUser.currentUser()
        menumanagerObject.saveInBackgroundWithBlock { (success, error) in
            if success{
            }
        }
    }
}
