//
//  IncomeExpenseViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-08-14.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class IncomeExpenseViewController: UIViewController {
    
    
    @IBOutlet weak var incomeExpenseButton: UIButton!
    @IBOutlet weak var incomeExpenseAmmount: UITextField!
    
    @IBOutlet weak var errorMessageForIncomeExpenseButton: UILabel!
    @IBOutlet weak var errorMessageForAmount: UILabel!
    
    @IBOutlet weak var addIncomeExpenseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addIncomeExpenseButton.isEnabled = (incomeExpenseAmmount.text == nil || incomeExpenseButton.currentTitle == "Select Account Type")
    }
    
    @IBAction func selectIncomeExpense(_ sender: UIButton) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Income",
                                      style: .default) { _ in
            self.incomeExpenseButton.setTitle("Income", for: .normal)
            self.errorMessageForIncomeExpenseButton.isHidden = true
        })
        
        alert.addAction(UIAlertAction(title: "Expense",
                                      style: .default) { _ in
            self.incomeExpenseButton.setTitle("Expense", for: .normal)
            self.errorMessageForIncomeExpenseButton.isHidden = true
        })

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel) { _ in
            if self.incomeExpenseButton.currentTitle == "Income" || self.incomeExpenseButton.currentTitle == "Expense" {
                
                self.errorMessageForIncomeExpenseButton.isHidden = true
            } else {
                self.errorMessageForIncomeExpenseButton.isHidden = false
            }
        })

        self.present(alert, animated: true)
    }
    
    func checkingValidity()  {
        if let amount = incomeExpenseAmmount.text {
            if !amount.isEmpty {
                if incomeExpenseButton.currentTitle == "Income" || incomeExpenseButton.currentTitle == "Expense" {
                    
                    addIncomeExpenseButton.isEnabled = true
                }
            } else {
                addIncomeExpenseButton.isEnabled = false
            }
        }
    }
    
    @IBAction func amountTFChnaged(_ sender: UITextField) {
        checkingValidity()
        
        if let amount = incomeExpenseAmmount.text{
            if !amount.isEmpty {
                errorMessageForAmount.isHidden = true
            } else {
                errorMessageForAmount.isHidden = false
            }
        }
    }
    
    func errorAlert(error: String) {
        let alert = UIAlertController(title: "Event registration Failed!", message: error, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func addIncomeExpense(_ sender: UIButton) {
        if let iAmount = incomeExpenseAmmount.text, let incomeExpenseType = incomeExpenseButton.currentTitle, let uid = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            
            db.collection("incomeExpense").addDocument(data: [
                "added_by": uid,
                "account_id": "Account ID",
                "incomeExpense": incomeExpenseType,
                "amount": iAmount
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    self.errorAlert(error: "Error occured while registering event")
                } else {
                    self.dismiss(animated: true)
                }
            }
            
//            db.collection("accounts").addSnapshotListener { documentSnapshot, err in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                        self.errorAlert(error: err.localizedDescription)
//                    } else {
//                        for document in documentSnapshot!.documents {
//                            let account = document.data()
//
//                            if Auth.auth().currentUser?.uid == account["added_by"] as? String {
//                                var cBalance = account["current_balance"]
//
////                                if incomeExpenseType == "Income" {
////                                    cBalance = cBalance as! Int + Int(iAmount)!
////                                    db.collection("accounts").document("JRdOn6Ax3efBBII11v7P").update({
////                                        current_balance; cBalance
////                                    })
////                                }
//                            }
//                        }
//                    }
//            }
            
        }
    }
}
