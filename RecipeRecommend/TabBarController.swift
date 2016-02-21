import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let iconcolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
        // アイコン色
        UITabBar.appearance().tintColor = iconcolor
        UITabBar.appearance().translucent  = false
        UITabBar.appearance().layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
