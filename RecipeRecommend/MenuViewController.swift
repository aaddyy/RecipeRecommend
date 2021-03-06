import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import Parse

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var forTab: UIView!
    @IBOutlet weak var tableView: UITableView!

    var menus: [[String: String?]] = []
    var currentUrl: String = ""
    var currentMenu: [String: String?] = ["": ""]
    let titlecolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
    var tabButtons:Array<UIButton> = []
    let IdforUrl = ["30","38-501","38-502","38-503"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //siteButton
        setTabButton(self.view.center.x*2/5-20, text: "人気", color: titlecolor, tag: 0)
        setTabButton(self.view.center.x*4/5-20, text: "朝", color: titlecolor, tag: 1)
        setTabButton(self.view.center.x*6/5-20, text: "昼", color: titlecolor, tag: 2)
        setTabButton(self.view.center.x*8/5-20, text: "夜", color: titlecolor, tag: 3)
    }
    
    override func viewWillAppear(animated: Bool) {
        menus = []
        tableView.dataSource = self
        tableView.delegate = self
        
        //人気のボタンを選択状態にする
        tapTabButton(tabButtons[0])
        self.tableView.reloadData()
    }

    //APIから情報取得
    func getMenus(Id: String){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?applicationId=1059767517344748188&categoryId="+Id)
            .responseJSON{ response in
                guard let object = response.result.value else{
                    return
                }
                let json = JSON(object)
                json["result"].forEach{(i, json) in
                    let menu: [String: String?] = [
                        "title": json["recipeTitle"].string,
                        "recipeUrl": json["recipeUrl"].string,
                        "foodimageurl": json["foodImageUrl"].string,
                        "description": json["recipeDescription"].string,
                        "time": json["recipeIndication"].string,
                        "cost": json["recipeCost"].string,
                        ]
                        self.menus.append(menu)
                        }
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    //TableViewの設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: menu["foodimageurl"]!!)
        let menuImage = cell.viewWithTag(5) as! UIImageView
        menuImage.af_setImageWithURL(url!)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        return cell
    }
    
    //画面遷移設定・値渡し
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentUrl = self.menus[indexPath.row]["recipeUrl"]!!
        self.currentMenu = self.menus[indexPath.row]
        self.performSegueWithIdentifier("ShowToMenuWebViewController", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue,  sender: AnyObject?) {
        let cast = segue.destinationViewController
        if cast is UINavigationController{
        } else {
            let menuweb = cast as! MenuWebViewController
            menuweb.Url = self.currentUrl
            menuweb.Menu = self.currentMenu
        }
    }
    
    //タブボタンの設定
    func setTabButton(x: CGFloat, text: String, color: UIColor, tag: Int){
        let tabButton = UIButton()
        tabButton.frame.size = CGSizeMake(36, 36)
        tabButton.center = CGPointMake(x, 28)
        tabButton.setTitle(text, forState: UIControlState.Normal)
        tabButton.setTitleColor(color, forState: UIControlState.Selected)
        tabButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        tabButton.titleLabel?.font = UIFont(name: "HiraginoSans-W3", size: 13)
        tabButton.backgroundColor = UIColor.whiteColor()
        tabButton.tag = tag
        tabButton.addTarget(self, action: "tapTabButton:", forControlEvents: UIControlEvents.TouchUpInside)
        tabButton.layer.cornerRadius = 18
        tabButton.layer.borderColor = UIColor.grayColor().CGColor
        tabButton.layer.borderWidth = 1
        tabButton.layer.masksToBounds = true
        self.forTab.addSubview(tabButton)
        tabButtons.append(tabButton)
    }
    
    func setSelectedButton(button: UIButton, selected: Bool) {
        button.selected = selected
        if button.selected == true{
            button.layer.borderColor = titlecolor.CGColor
        }else{
            button.layer.borderColor = UIColor.grayColor().CGColor
        }
        
    }
    
    func tapTabButton(sender: UIButton){
        menus = []
        let i = sender.tag
        getMenus(IdforUrl[i])
        for(var j = 0; j < 4; j++){
            if j == i{
                setSelectedButton(tabButtons[j], selected: true)
                self.navigationItem.title = "\(tabButtons[j].titleLabel!.text!)"+"の献立 最新TOP4"
            }else{
                setSelectedButton(tabButtons[j], selected: false)
                }
            }
    }
//
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
