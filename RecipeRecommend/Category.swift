import UIKit
import Parse

class Category: NSObject {
    
        var categoryId: String
        var categoryName: String
        var categoryUrl: String
        
    init(categoryId: String, categoryName: String, categoryUrl: String) {
            self.categoryId = categoryId
            self.categoryName = categoryName
            self.categoryUrl = categoryUrl
        }
        
        //Parseへ保存
        func save(){
            let categoryObject = PFObject(className: "Category")
            categoryObject["categoryId"] = categoryId
            categoryObject["categoryName"] = categoryName
            categoryObject["categoryUrl"] = categoryUrl
            categoryObject.saveInBackgroundWithBlock { (success, error) in
                if success{
                }
            }
        }
    }
