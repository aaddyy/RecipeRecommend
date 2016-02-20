import UIKit
import SwiftyJSON
import Alamofire
import Parse

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var menus: [[String: String?]] = []
    var currentUrl: String = ""
    var currentMenu: [String: String?] = ["": ""]
    var Url: String!
    var Name: String!
    let currentFlag = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMenus()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "「"+"\(Name)"+"」最新TOP4"
    }
    
    //APIから情報取得
    func getMenus(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, Url)
            .responseJSON{ response in
                guard let object = response.result.value else{
                    return
                }
                let json = JSON(object)
                json["result"].forEach{(i, json) in
                    let menu: [String: String?] = [
                        //                        "id": json["recipeId"].string,
                        "title": json["recipeTitle"].string,
                        "recipeUrl": json["recipeUrl"].string,
                        "foodimageurl": json["foodImageUrl"].string,
                        //                        "mediumimageurl": json["mediumImageUrl"].string,
                        //                        "smallimageurl": json["smallImageUrl"].string,
                        //                        "pickup": json["pickup"].string,
                        //                        "shop": json["shop"].string,
                        //                        "nickname": json["nickname"].string,
                        "description": json["recipeDescription"].string,
                        //                        "material": json["recipeMaterial"].string,
                        "time": json["recipeIndication"].string,
                        "cost": json["recipeCost"].string,
                        //                        "publishday": json["recipePublishday"].string,
                        //                        "rank": json["rank"].string
                    ]
                    self.menus.append(menu)
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.tableView.reloadData()
        }
    }
    
    //TableViewの設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell")!
        
        let menu = menus[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = menu["title"]!
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        
        let descriptionLabel = cell.viewWithTag(2) as! UILabel
        descriptionLabel.text = menu["description"]!
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
        let timeLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.text = menu["time"]!
        timeLabel.numberOfLines = 0
        timeLabel.sizeToFit()
        
        let costLabel = cell.viewWithTag(4) as! UILabel
        costLabel.text = menu["cost"]!
        costLabel.numberOfLines = 0
        costLabel.sizeToFit()
        
        //画像の処理
        let url = NSURL(string: menu["foodimageurl"]!!)
        let req = NSURLRequest(URL:url!)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data!)
            let menuImage = cell.viewWithTag(5) as! UIImageView
            menuImage.image = image
        }
        return cell
    }
    
    //画面遷移設定・値渡し
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentUrl = self.menus[indexPath.row]["recipeUrl"]!!
        self.currentMenu = self.menus[indexPath.row]
        self.performSegueWithIdentifier("ShowToSearchWebViewController", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue,  sender: AnyObject?) {
        var cast = segue.destinationViewController
        if cast is UINavigationController{
        } else {
            let menuweb = cast as! MenuWebViewController
            menuweb.Url = self.currentUrl
            menuweb.Menu = self.currentMenu
            menuweb.flag = self.currentFlag
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
