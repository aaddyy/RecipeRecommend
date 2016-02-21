import UIKit
import WebKit
import Parse

class MenuWebViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {
    let wkWebView = WKWebView()
    var Url: String!
    var Menu: [String: String?] = ["": ""]
    var login = LoginViewController()
    var check = 0
    var flag = 0
    let titlecolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
    var Landscape = "starsmall.png"
    var Portrait = "starbig.png"
    var tempOrientation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView.frame = self.view.frame
        self.view.addSubview(wkWebView)
        self.wkWebView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let URL = NSURL(string: Url)
        let URLReq = NSURLRequest(URL:URL!)
            
        self.wkWebView.navigationDelegate = self
        self.wkWebView.loadRequest(URLReq)
    }
    
    override func viewWillAppear(animated: Bool) {
        Check()
    }
    
//お気に入りボタンの設定
    func favoriteButtonSetting(){
            if flag != 1{
                var deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
                        if UIDeviceOrientationIsLandscape(deviceOrientation) {
                            tempOrientation = Landscape
                 } else if UIDeviceOrientationIsPortrait(deviceOrientation){
                            tempOrientation = Portrait
                }
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: tempOrientation), style: .Plain, target: self, action: "favorite")
            //画面の向き変化を探知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
            }else{
                flag = 0
            }
    }

    // 端末の向きがかわったら呼び出される.
    func onOrientationChange(notification: NSNotification){
        
        // 現在のデバイスの向きを取得.
        var deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        // 向きの判定.
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            //横向きの判定
            var FavoriteButton = UIBarButtonItem(image: UIImage(named: Landscape), style: .Plain, target: self, action: "favorite")
            navigationItem.rightBarButtonItem = FavoriteButton
        } else if UIDeviceOrientationIsPortrait(deviceOrientation){
            //縦向きの判定
            var FavoriteButton = UIBarButtonItem(image: UIImage(named: Portrait), style: .Plain, target: self, action: "favorite")
            navigationItem.rightBarButtonItem = FavoriteButton
        }
    }
    
    //お気に入り登録。Parseへ保存
    func favorite(){
        if (check == 1) {
            self.showAlert("既にお気に入り登録済みです")
        }else if (check == 0){
            let menumanager = MenuManager(recipeTitle: self.Menu["title"]!!, recipeUrl: self.Menu["recipeUrl"]!!, foodImageUrl: self.Menu["foodimageurl"]!!, recipeDescription: self.Menu["description"]!!, recipeIndication: self.Menu["time"]!!, recipeCost: self.Menu["cost"]!!)
            menumanager.save()
            self.favoriteButtonSetting()
            self.showAlert("お気に入りに登録されました")
            // 向きの判定.
            var deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
            if UIDeviceOrientationIsLandscape(deviceOrientation) {
                //横向きの判定
                var FavoriteButton = UIBarButtonItem(image: UIImage(named: "starsmallchange.png"), style: .Plain, target: self, action: "favorite")
                navigationItem.rightBarButtonItem = FavoriteButton
            } else if UIDeviceOrientationIsPortrait(deviceOrientation){
                //縦向きの判定
                var FavoriteButton = UIBarButtonItem(image: UIImage(named: "starbigchange.png"), style: .Plain, target: self, action: "favorite")
                navigationItem.rightBarButtonItem = FavoriteButton
            }
        }
    }
    
    //お気に入りの重複確認
    func Check(){
        check = 0
        let queryInfo = PFQuery(className: "MenuManager")
        queryInfo.includeKey("user")
        queryInfo.findObjectsInBackgroundWithBlock { (objects, error) in
            for object in objects! {
                let USER = object["user"].objectId
                let current = PFUser.currentUser()!.objectId
                if USER == current {
                    let exist = object["recipeUrl"] as! String
                    let currentURL = self.Menu["recipeUrl"]!! as! String
                    if exist == currentURL{
                        self.check = 1
                        self.Landscape = "starsmallchange.png"
                        self.Portrait = "starbigchange.png"
                    }
                }
            }
            self.favoriteButtonSetting()
        }
    }
    //
    
    //アラートを表示させるメソッドを定義
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //
    
    //読み込み中の表示
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.navigationItem.title = "読み込み中..."
    }
    
    //タイトル表示
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.navigationItem.title = wkWebView.title
    }
    
    //タブ遷移する際、一つ前の画面に戻っておく
    override func viewDidDisappear(animated: Bool) {
        if flag == 2{
            self.navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
            flag = 0
        }else{
            self.navigationController?.popViewControllerAnimated(true)
            flag = 0
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            flag = 0
        }
    }
    //
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
