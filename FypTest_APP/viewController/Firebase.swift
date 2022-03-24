//
//  Firebase.swift
//  FypTest_APP
//
//  Created by Isaac Lee on 24/2/2022.
//

import Foundation
import FirebaseFirestore


class Firebase {
    
    var p = [Activity]()
    
    func FireStorereadData() {
        
    }
    
    func getlocation(searchDistrict: String) {
        let database = Firestore.firestore()
        
        database.collection(searchDistrict).getDocuments() { (querySnapshot, err) in
            if let err = err {
                
            } else {
                for document in querySnapshot!.documents {
                    Activity.init(x: nil, y: nil, district: nil, gymroom: ["\(document.data())"])
                }
            }
        }
    }
}
