//
//  AccountDetailsViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-08-14.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class IncomeExpenseEvent {
    let transactionType: String
    let amount: String
    
    internal init(tType: String, amount: String) {
        self.transactionType = tType
        self.amount = amount
    }
}


class AccountDetailsViewController: UIViewController {
    
    @IBOutlet weak var incomeExpenseTable: UITableView!
    
    var events = [IncomeExpenseEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        incomeExpenseTable.delegate = self
//        incomeExpenseTable.dataSource = self

        fetchTransactions()
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return events.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeExpenseCell") as! IncomeExpenseTableViewCell
//
//        let event = events[indexPath.row]
////        cell.fillCell(accountName: event.accountName, currentBalance: event.currentBalance)
//
//        return cell
//    }
    
    @IBAction func showOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Income/Expense",
                                      style: .default) { _ in
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "incomeExpenseVC") as! IncomeExpenseViewController
            self.present(nextViewController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))

        self.present(alert, animated: true)
    }
    
    func errorAlert(title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchTransactions() {
        let db = Firestore.firestore()
        
        db.collection("incomeExpense").addSnapshotListener { documentSnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.errorAlert(title: "Error plotting events", error: err.localizedDescription)
                } else {
                    self.events.removeAll()
                    
                    for document in documentSnapshot!.documents {
                        let account = document.data()
                        
                        if Auth.auth().currentUser?.uid == account["added_by"] as? String {
                            let tType = account["incomeExpense"]
                            let amount = account["amount"]
                            
                            print("here!!! \(account)")
                            
                            self.events.append(IncomeExpenseEvent(
                                tType: tType as! String,
                                amount: amount as! String
                            ))
                        }
                    }
                    
                    self.incomeExpenseTable.reloadData()
                }
        }
    }
}
