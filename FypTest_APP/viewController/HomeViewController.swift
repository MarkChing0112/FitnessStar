//
//  HomeViewController.swift
//  FypTest_APP
import Firebase
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignOut_BTN(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do{
        try firebaseAuth.signOut()
              let firebaseAuth = Auth.auth()
              print("signout success")
              showAlertS()
          } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
          }
    }
    func toHomeView(){
        let loginFirstPageViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginFirstPageViewController) as? LoginFirstPageViewController
        
        view.window?.rootViewController = loginFirstPageViewController
        view.window?.makeKeyAndVisible()
    }
    func showAlertS(){
        let alert = UIAlertController(title: "SignOut Success!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: {action in self.toHomeView()}))
        present(alert, animated: true)
    }

}
