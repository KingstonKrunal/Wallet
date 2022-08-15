//
//  HomeScreenViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Event {
    let accountName: String
    let currentBalance: String
    
    internal init(accountName: String, currentBalance: String) {
        self.accountName = accountName
        self.currentBalance = currentBalance
    }
}

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false

    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!

    private var revealSideMenuOnTop: Bool = true

    @IBOutlet weak var accountsTV: UITableView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountsTV.delegate = self
        accountsTV.dataSource = self
        
        fetchEvents()
        
        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "sideMenuVC") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        
        // Side Menu AutoLayout
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // Default Main View Controller
//        showViewController(viewController: UINavigationController.self, storyboardId: "homeScreenVC")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountTableViewCell
        
        let event = events[indexPath.row]
        cell.fillCell(accountName: event.accountName, currentBalance: event.currentBalance)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountDetailsVC") as! AccountDetailsViewController
        
        self.present(nextViewController, animated: true)
    }
    
    func fetchEvents() {
        let db = Firestore.firestore()
        
        db.collection("accounts").addSnapshotListener { documentSnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.errorAlert(title: "Error plotting events", error: err.localizedDescription)
                } else {
                    self.events.removeAll()
                    
                    for document in documentSnapshot!.documents {
                        let account = document.data()
                        
                        if Auth.auth().currentUser?.uid == account["added_by"] as? String {
                            let aName = "\(account["account_name"] ?? "") \(account["account_type"] ?? "")"
                            let cBalance = "$\(account["current_balance"] ?? "NIL")"
                            
                            print("here!!! \(account)")
                            
                            self.events.append(Event(
                                accountName: aName,
                                currentBalance: cBalance
                            ))
                        }
                    }
                    
                    self.accountsTV.reloadData()
                }
        }
    }
    
    
    @IBAction func showOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Account",
                                      style: .default) { _ in
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "addAccountVC") as! AddAccountViewController
            self.present(nextViewController, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Currency Converter",
                                      style: .default) { _ in
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "currencyConverterVC") as! CurrencyConverterViewController
            self.present(nextViewController, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Settings",
                                      style: .default) { _ in
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
            self.present(nextViewController, animated: true)
        })
        
//        alert.addAction(UIAlertAction(title: "About",
//                                      style: .default) { _ in
//            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
//            self.present(nextViewController, animated: true)
//        })

        alert.addAction(UIAlertAction(title: "Logout",
                                      style: .destructive) { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
                // Go to login view
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: true)
            } catch let signOutError as NSError {
                self.errorAlert(title: "Error signing out", error: signOutError.localizedDescription)
            }
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
    
    
    @IBAction func sideMenuButton(_ sender: UIButton) {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
}


extension HomeScreenViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
//        case 0:
            // Home
//            self.showViewController(viewController: UINavigationController.self, storyboardId: "homeScreenVC")
//        case 1:
            // Currency Converter
//            self.showViewController(viewController: UINavigationController.self, storyboardId: "MusicNavID")
//        case 2:
            // Profile
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let profileModalVC = storyboard.instantiateViewController(withIdentifier: "ProfileModalID") as? ProfileViewController
//            present(profileModalVC!, animated: true, completion: nil)
//        case 3:
//            // Settings
//            self.showViewController(viewController: UINavigationController.self, storyboardId: "SettingsNavID")
        default:
            break
        }

        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }

//    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
//        // Remove the previous View
//        for subview in view.subviews {
//            if subview.tag == 99 {
//                subview.removeFromSuperview()
//            }
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
//        vc.view.tag = 99
//        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
//        addChild(vc)
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
//            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
//        ])
//        if !self.revealSideMenuOnTop {
//            if isExpanded {
//                vc.view.frame.origin.x = self.sideMenuRevealWidth
//            }
////            if self.sideMenuShadowView != nil {
////                vc.view.addSubview(self.sideMenuShadowView)
////            }
//        }
//        vc.didMove(toParent: self)
//    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) {
//                self.sideMenuShadowView.alpha = 0.6
            }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) {
//                self.sideMenuShadowView.alpha = 0.0
            }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}

extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> HomeScreenViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is HomeScreenViewController {
            return viewController! as? HomeScreenViewController
        }
        while (!(viewController is HomeScreenViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is HomeScreenViewController {
            return viewController as? HomeScreenViewController
        }
        return nil
    }
    
}
