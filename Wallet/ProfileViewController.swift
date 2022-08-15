//
//  ProfileViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-08-14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        db.collection("users").addSnapshotListener { documentSnapshot, err in
                if let err = err {
                    print("Error getting user data: \(err)")
                    self.errorAlert(title: "Error getting user data", error: err.localizedDescription)
                } else {
                    for document in documentSnapshot!.documents {
                        let users = document.data()
                        
                        print(users["user_id"]!)
                        
                        if Auth.auth().currentUser?.uid == users["user_id"] as? String {
                            print(users["name"]!)
                            self.userName.text = users["name"] as? String
                            
                            print(users["mobile_number"]!)
                            self.userMobileNumber.text = users["mobile_number"] as? String
                        }
                    }
                }
        }
    }
    
    func errorAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
