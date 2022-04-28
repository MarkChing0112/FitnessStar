//
//  SignOut.swift
//  FypTest_APP

import UIKit
import Foundation
import Firebase
import FirebaseAuth
func SignOut(){
    let firebaseAuth = Auth.auth()
    do{
    try firebaseAuth.signOut()
          let firebaseAuth = Auth.auth()
    
      } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
      }
}

