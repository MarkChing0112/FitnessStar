//
//  LoginViewController.swift
//  SeniorVolunteer
//

//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ForgotpasswordBtn: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.returnKeyType = UIReturnKeyType.done
    }
    
    // touch space to close keyboard
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view?.endEditing(false)
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        // Style the elements
        self.passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let firstPageNavigationController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationController) as? FirstPageNavigationController
                
                self.view.window?.rootViewController = firstPageNavigationController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func ForgotPasswordBtnOnTap(_ sender: Any) {
        
    }
}
