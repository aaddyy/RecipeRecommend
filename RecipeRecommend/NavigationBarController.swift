import UIKit

class NavigationBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 色
        let iconcolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
        let titlecolor = UIColor(red: 70/255, green: 210/255, blue: 20/255, alpha: 1.0)
        
        // アイコン色
        self.navigationBar.tintColor = iconcolor
        
        // フォント設定
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HiraginoSans-W3", size: 15)!,NSForegroundColorAttributeName:titlecolor]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//画面固定する為の機能拡張
extension UINavigationController {
    public override func shouldAutorotate() -> Bool {
        return visibleViewController!.shouldAutorotate()
    }
}
