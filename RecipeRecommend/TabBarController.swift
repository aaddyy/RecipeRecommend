import UIKit
import Parse

class TabBarController: UITabBarController,UITabBarControllerDelegate{
    var Tab = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let iconcolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
        // アイコン色
        UITabBar.appearance().tintColor = iconcolor
        UITabBar.appearance().translucent  = false
        UITabBar.appearance().layer.borderColor = UIColor.grayColor().CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        self.selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 3{
            if PFUser.currentUser() == nil {
               consent()
            }
        }
    }

    func consent() {
        let alertController = UIAlertController(title: "お気に入り機能を使用するにはユーザー登録が必要です。\n登録が可能な場合は、「ユーザー登録」へ進んで下さい。", message: "", preferredStyle: .Alert)
        let signUpAction = UIAlertAction(title: "ユーザー登録", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.viewWillAppear(true)
                self.execution()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.viewWillAppear(true)
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
}
