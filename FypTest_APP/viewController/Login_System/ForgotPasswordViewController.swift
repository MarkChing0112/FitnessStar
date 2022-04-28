//
//  ForgotPasswordViewController.swift
//  FypTest_APP
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func tologinHome(){
        let loginFirstPageViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginFirstPageViewController) as? LoginFirstPageViewController
        
        self.view.window?.rootViewController = loginFirstPageViewController
        self.view.window?.makeKeyAndVisible()

    }
    @IBAction func SendBtnOnTap(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: EmailTextField.text!){(error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion:  nil)
                return
            }
            let alert = UIAlertController(title: "", message:"password reset email has been set!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: {action in self.tologinHome()}))
            self.present(alert, animated: true, completion:  nil)
        }
    }
    
}
