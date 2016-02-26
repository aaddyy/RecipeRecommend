import UIKit
import Parse

class FavoriteTableViewController: UIViewController,  UITableViewDataSource,  UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var favorits: [[String: String?]] = []
    var currentUrl: String = ""
    var currentMenu: [String: String?] = ["": ""]
    let currentFlag = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        favorits = []
        tableView.dataSource = self
        tableView.delegate = self
        setEditing(false, animated: true)
        if PFUser.currentUser() != nil {
        self.fetchFavorits()
        LogoutButtonSetting()
        DeleteButtonSetting()
        }
        self.tableView.reloadData()
    }
    
    //Parseから取得
    func fetchFavorits() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let queryInfo = PFQuery(className: "MenuManager")
        queryInfo.includeKey("user")
        queryInfo.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                var favorite: [String: String?] = ["":""]
                for object in objects! {
                    let USER = object["user"].objectId
                    let current = PFUser.currentUser()!.objectId
                    if USER == current {
                    favorite = [
                        "title": object["recipeTitle"] as? String,
                        "recipeUrl": object["recipeUrl"] as? String,
                        "foodimageurl": object["foodImageUrl"] as? String,
                        "description": object["recipeDescription"] as? String,
                        "time": object["recipeIndication"] as? String,
                        "cost": object["recipeCost"] as? String,
                        ]
                    self.favorits.append(favorite)
                    }
                }
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    //TableViewの設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell")!
        
        let favorit = favorits[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = favorit["title"]!
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        
        let descriptionLabel = cell.viewWithTag(2) as! UILabel
        descriptionLabel.text = favorit["description"]!
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
        let timeLabel = cell.viewWithTag(3) as! UILabel
        timeLabel.text = favorit["time"]!
        timeLabel.numberOfLines = 0
        timeLabel.sizeToFit()
        
        let costLabel = cell.viewWithTag(4) as! UILabel
        costLabel.text = favorit["cost"]!
        costLabel.numberOfLines = 0
        costLabel.sizeToFit()
        
        //画像の処理
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: favorit["foodimageurl"]!!)
        let req = NSURLRequest(URL:url!)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data!)
            let menuImage = cell.viewWithTag(5) as! UIImageView
            menuImage.image = image
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        return cell
    }
    
    //画面遷移設定・値渡し
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentUrl = self.favorits[indexPath.row]["recipeUrl"]!!
        self.currentMenu = self.favorits[indexPath.row]
        self.performSegueWithIdentifier("ShowToFavoriteWebViewController", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue,  sender: AnyObject?) {
        let cast = segue.destinationViewController
        if cast is UINavigationController{
        } else {
            let menuweb = cast as! MenuWebViewController
            menuweb.Url = self.currentUrl
            menuweb.Menu = self.currentMenu
            menuweb.flag = self.currentFlag
        }
    }
    
    //ログアウト機能
    //ログアウトボタンの設定
    func LogoutButtonSetting(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Logout.png"), style: .Plain, target: self, action: "logout")
        //画面の向き変化を探知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // 端末の向きがかわったら呼び出される.
    func onOrientationChange(notification: NSNotification){
        
        // 現在のデバイスの向きを取得.
        var deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        // 向きの判定.
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            //横向きの判定
            var LogoutButton = UIBarButtonItem(image: UIImage(named: "Logoutsmall.png"), style: .Plain, target: self, action: "logout")
            navigationItem.rightBarButtonItem = LogoutButton
        } else if UIDeviceOrientationIsPortrait(deviceOrientation){
            //縦向きの判定
            var LogoutButton = UIBarButtonItem(image: UIImage(named: "Logout.png"), style: .Plain, target: self, action: "logout")
            navigationItem.rightBarButtonItem = LogoutButton
        }
    }
    
    func logout() {
        let alertController = UIAlertController(title: "ログアウトしますか？", message: "", preferredStyle: .Alert)
        let logoutAction = UIAlertAction(title: "ログアウト", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.execution()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func execution(){
        PFUser.logOut()
        performSegueWithIdentifier("MODALLoginViewController", sender: self)
    }
    //
    
//お気に入り削除機能
    func DeleteButtonSetting(){
        self.navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
        tableView.editing.description
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let alertController = UIAlertController(title: "お気に入りから削除しますか？", message: "", preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "削除", style: .Default,handler:{ (action:UIAlertAction!) -> Void in
                    let queryInfo = PFQuery(className: "MenuManager")
                    queryInfo.includeKey("user")
                    queryInfo.findObjectsInBackgroundWithBlock { (objects, error) in
                        if error == nil {
                            var temp = -1
                            for object in objects! {
                                let USER = object["user"] .objectId
                                let currentuser = PFUser.currentUser()!.objectId
                                if USER == currentuser {
                                    let URL = object["recipeUrl"] as! String
                                    let currentUrl = self.favorits[indexPath.row]["recipeUrl"]!!
                                    if URL == currentUrl {
                                        object.deleteInBackground()
                                        temp = indexPath.row
                                        }
                                    }
                                }
                            self.favorits.removeAtIndex(temp)
                            self.tableView.reloadData()
                            self.setEditing(false, animated: true)
                            }
                    }
                })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .Default,
                handler:{ (action:UIAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }
    self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let temp = "削除"
        return temp
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle { if tableView.editing {
        return UITableViewCellEditingStyle.Delete }
    else { return UITableViewCellEditingStyle.None } }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
