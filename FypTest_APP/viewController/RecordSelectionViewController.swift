//
//  RecordSelectionViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit

class RecordSelectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func tohomeview(){
        let firstPageNavigationController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationController) as? FirstPageNavigationController
        view.window?.rootViewController = firstPageNavigationController
        view.window?.makeKeyAndVisible()
    }

}
