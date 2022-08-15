//
//  AddAccountViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-30.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CloudKit

class AddAccountViewController: UIViewController {

    @IBOutlet weak var accountTypeButton: UIButton!
    
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var accountNameTF: UITextField!
    
    @IBOutlet weak var errorMessageForAccountType: UILabel!
    @IBOutlet weak var errorMessageForInitialAmount: UILabel!
    @IBOutlet weak var errorMessageForAcountName: UILabel!
    
    @IBOutlet weak var addAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let accountTypeMenu = UIMenu(title: "Select Account Type", options: .singleSelection, children: [
//            UIAction(title: "Saving", handler: sortClosure),
//            UIAction(title: "Chequing", handler: sortClosure),
//            UIAction(title: "Credit", handler: sortClosure)
//        ])
        
        addAccountButton.isEnabled = (initialAmountTF.text == nil || accountNameTF.text == nil || accountTypeButton.currentTitle == "Select Account Type")
    }
    
    
    @IBAction func accountType(_ sender: UIButton) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Saving",
                                      style: .default) { _ in
            self.accountTypeButton.setTitle("Saving", for: .normal)
            self.errorMessageForAccountType.isHidden = true
        })
        
        alert.addAction(UIAlertAction(title: "Chequing",
                                      style: .default) { _ in
            self.accountTypeButton.setTitle("Chequing", for: .normal)
            self.errorMessageForAccountType.isHidden = true
        })

        alert.addAction(UIAlertAction(title: "Credit",
                                      style: .default) { _ in
            self.accountTypeButton.setTitle("Credit", for: .normal)
            self.errorMessageForAccountType.isHidden = true
        })

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel) { _ in
            if self.accountTypeButton.currentTitle == "Saving" || self.accountTypeButton.currentTitle == "Chequing" || self.accountTypeButton.currentTitle == "Credit" {
                
                self.errorMessageForAccountType.isHidden = true
            } else {
                self.errorMessageForAccountType.isHidden = false
            }
        })

        self.present(alert, animated: true)
    }
    
    func checkingValidity()  {
        if let iAmount = initialAmountTF.text, let aName = accountNameTF.text {
            if !iAmount.isEmpty && !aName.isEmpty {
                if accountTypeButton.currentTitle == "Saving" || accountTypeButton.currentTitle == "Chequing" || accountTypeButton.currentTitle == "Credit" {
                    
                    addAccountButton.isEnabled = true
                }
            } else {
                addAccountButton.isEnabled = false
            }
        }
    }
    
    
    @IBAction func initialAmountTFChanged(_ sender: UITextField) {
        checkingValidity()
        
        if let iAmount = initialAmountTF.text{
            if !iAmount.isEmpty {
                errorMessageForInitialAmount.isHidden = true
            } else {
                errorMessageForInitialAmount.isHidden = false
            }
        }
    }
    
    @IBAction func accountNameTFChanged(_ sender: UITextField) {
        checkingValidity()
        
        if let aName = accountNameTF.text{
            if !aName.isEmpty {
                errorMessageForAcountName.isHidden = true
            } else {
                errorMessageForAcountName.isHidden = false
            }
        }
    }
    
    func gotoHomeScreenVC() {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeScreenVC") as! HomeScreenViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true)
    }
    
    func errorAlert(error: String) {
        let alert = UIAlertController(title: "Event registration Failed!", message: error, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addAccount(_ sender: UIButton) {
        if let iAmount = initialAmountTF.text, let aName = accountNameTF.text,
            let accountTyoe = accountTypeButton.currentTitle, let uid = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("accounts").addDocument(data: [
                "added_by": uid,
                "account_type": accountTyoe,
                "account_name": aName,
                "current_balance": iAmount
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    self.errorAlert(error: "Error occured while registering event")
                } else {
                    self.gotoHomeScreenVC()
                }
            }
        }
    }
}
