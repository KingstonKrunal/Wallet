//
//  SettingsViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-30.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func profilePage(_ sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        self.present(nextViewController, animated: true)
    }
    
    
    @IBAction func developersPage(_ sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "developersVC") as! DevelopersViewController
        self.present(nextViewController, animated: true)
    }
    
    
    @IBAction func aboutPage(_ sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        self.present(nextViewController, animated: true)
    }
}
