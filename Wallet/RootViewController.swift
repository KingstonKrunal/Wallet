//
//  RootViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-29.
//

import UIKit
import FirebaseAuth

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeScreenVC") as! HomeScreenViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: true)
            } else {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
