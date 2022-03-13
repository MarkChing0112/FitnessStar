//
//  SignOut.swift
//  FypTest_APP
//
//  Created by Mark on 14/2/2022.
//
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

