import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var Cancel: UIButton!
    var TABControl = TabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        passwordTextField.delegate = self
        SignUpButton.titleLabel?.numberOfLines = 3
        SignUpButton.titleLabel?.textAlignment = NSTextAlignment.Center
        Cancel.titleLabel?.numberOfLines = 3
        Cancel.titleLabel?.textAlignment = NSTextAlignment.Center
        
        shouldAutorotate()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    //表示する毎に表示画像を変更する
    override func viewWillAppear(animated: Bool) {
        var temp = arc4random() % 8 + 1
        backImage.image = UIImage(named: "\(temp).jpg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    @IBAction func tapSignUpButton(sender: AnyObject) {
        let user = User(name: nameTextField.text!, password: passwordTextField.text!)
        user.signUp { (message) in
            if let unwrappedMessage = message {
                if (unwrappedMessage == ("username "+"\(self.nameTextField.text!)"+" already taken")){
                    self.showAlert("「\(self.nameTextField.text!)」"+"は既に登録済みのユーザー名です")
                }else if(self.nameTextField.text! == ""){
                    self.showAlert("ユーザー名とパスワードは入力必須です")
                }else if(unwrappedMessage != "invalid login parameters") {
                    self.showAlert(unwrappedMessage)
                }
                }else if (self.passwordTextField.text! == ""){
                    self.showAlert("ユーザー名とパスワードは入力必須です")
                }else{
                    self.showNotice("ユーザーが登録されました")
                    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    self.TABControl.viewWillAppear(false)
                    }
                }
            }
    
    @IBAction func tapLoginButton(sender: AnyObject) {
        let user = User(name: nameTextField.text!, password: passwordTextField.text!)
        user.login { (message) in
            if let unwrappedMessage = message {
            if (unwrappedMessage == "invalid login parameters") {
                self.showAlert("ユーザー名またはパスワードの入力に誤りがあります")
            }else if (unwrappedMessage != "invalid login parameters") {
                self.showAlert(unwrappedMessage)
                }
            } else{
                self.showNotice("ログイン成功")
                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                self.TABControl.viewWillAppear(false)
            }
        }
    }
    
    @IBAction func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.TABControl.viewWillAppear(false)
    }
    
    //アラートを表示させるメソッドを定義
    func showAlert(message: String?) {
        let alertController = UIAlertController(title: "エラー", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showNotice(message: String?) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
    