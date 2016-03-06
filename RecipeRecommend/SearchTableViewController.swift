import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import Parse

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let myColor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
    let backColor = UIColor(red: 150/255, green: 160/255, blue: 220/255, alpha: 1.0)
    var Category: [[String: String?]] = []
    var filteredSearch = [Search]()
    var currentUrl: String = ""
    var currentName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // サーチコントローラ設定
        self.searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.Prominent
        searchBar.sizeToFit()
        searchBar.tintColor = myColor
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.barTintColor = backColor
        searchBar.layer.borderColor = UIColor.grayColor().CGColor
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tap)
    }
    
//Parse上のカテゴリ情報取得
    func fetchCategory(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //検索文字列のスペースを判別
        var tempArray:[String] = []
        let tempText = self.searchBar.text!
        if (tempText.rangeOfString(" ") != nil){
            tempArray = tempText.componentsSeparatedByString(" ")
        }else if (tempText.rangeOfString("　") != nil){
            tempArray = tempText.componentsSeparatedByString("　")
        }else{
            tempArray.append(tempText)
        }
        let count = tempArray.count
        //

        let limit = 3
        for(var j=0; j < limit+1; j++){
        let queryInfo = PFQuery(className: "Category")
        queryInfo.limit = 1000
        queryInfo.skip = 1000*j
        queryInfo.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                    for object in objects! {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        let exist = object["categoryName"] as! String
                        var check = 0
                        
                            for (var i=0; i < count; i++){
                                if (exist.rangeOfString(tempArray[i] ) != nil){
                                    check++
                                    }
                                }
                                if (check == count){
                                    let temp: [String: String?] = [
                                        "name": object["categoryName"]! as? String,
                                        "url": object["categoryUrl"]! as? String
                                    ]
                                    self.Category.append(temp)
                                    self.tableView.reloadData()
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    }
                                }
                            }
                        }
                }
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

//画面遷移設定・値渡し
    override func prepareForSegue(segue: UIStoryboardSegue,  sender: AnyObject?) {
        let cast = segue.destinationViewController
        if cast is UINavigationController{
        } else {
            let searchResults = cast as! SearchResultsViewController
            searchResults.Url = self.currentUrl
            searchResults.Name = self.currentName
            searchResults.Flag = 1
        }
    }
    
//searchbarのdelegate系
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Category = []
        fetchCategory()
        self.view.endEditing(true)
    }
    //GestureRecognizerが載っているので、cellタップが認識されるように記載
    func handleTap(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
        let touch = sender.locationInView(tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(touch) {
        let temp = (self.Category[indexPath.row]["url"]!! as NSString).substringFromIndex(37) as String
        let endPoint = temp.characters.count - 1
        let str = (temp as NSString).substringToIndex(endPoint)
        let forAddUrl = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?format=json&applicationId=1059767517344748188&categoryId=" + str
        self.currentUrl = forAddUrl
        self.currentName = self.Category[indexPath.row]["name"]!!
        self.performSegueWithIdentifier("ShowToSearchResults", sender: nil)
        }
    }
//
    
//tableview設定
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("searchcell")! as UITableViewCell
        let category = Category[indexPath.row]
        cell.textLabel!.text = category["name"]!
        return cell
    }
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(40)
    }
//
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



