//
//  SignUpViewController.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-29.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var uNameTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorMessageForUserName: UILabel!
    @IBOutlet weak var errorMessageForMobileNumber: UILabel!
    @IBOutlet weak var errorMessageForEmailId: UILabel!
    @IBOutlet weak var errorMessageForPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.isEnabled = (emailTF.text == nil || passwordTF.text == nil || mobileNumberTF.text == nil || uNameTF.text == nil)
    }
    
    func checkingValidity()  {
        if let email = emailTF.text, let password = passwordTF.text, let uName = uNameTF.text, let mNumber = mobileNumberTF.text {
            if !email.isEmpty && !password.isEmpty && !uName.isEmpty && !mNumber.isEmpty {
                signUpButton.isEnabled = true
            } else {
                signUpButton.isEnabled = false
            }
        }
    }
    
    @IBAction func userNameTFChanged(_ sender: UITextField) {
        checkingValidity()
        
        if let userName = uNameTF.text{
            if !userName.isEmpty {
                errorMessageForUserName.isHidden = true
            } else {
                errorMessageForUserName.isHidden = false
            }
        }
    }
    
    @IBAction func mobileNumberTFChanged(_ sender: UITextField) {
        checkingValidity()
        
        if let mobileNumber = mobileNumberTF.text{
            if !mobileNumber.isEmpty {
                errorMessageForMobileNumber.isHidden = true
            } else {
                errorMessageForMobileNumber.isHidden = false
            }
        }
    }
    
    @IBAction func emailTFChanged(_ sender: UITextField) {
        checkingValidity(   )
        
        if let email = emailTF.text{
            if !email.isEmpty {
                errorMessageForEmailId.isHidden = true
            } else {
                errorMessageForEmailId.isHidden = false
            }
        }
    }
    
    @IBAction func passwordTFChanged(_ sender: UITextField) {
        checkingValidity()
        
        if let password = passwordTF.text{
            if !password.isEmpty {
                errorMessageForPassword.isHidden = true
            } else {
                errorMessageForPassword.isHidden = false
            }
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if let uname = uNameTF.text, let mNumber = mobileNumberTF.text, let email = emailTF.text, let password = passwordTF.text {
            
            let auth = Auth.auth()
            
            if auth.currentUser != nil {
                //TODO: Query user data from firebase, if not exists create it.
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.errorAlert(error: error?.localizedDescription ?? "Error occured while registering user")
                }
                
                if authResult?.user != nil {
                    if let uid = authResult?.user.uid {
                        let db = Firestore.firestore()
                        
                        db.collection("users").document(uid).setData([
                            "name": uname,
                            "mobile_number": mNumber,
                            "user_id": uid
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                                self.errorAlert(error: "Error occured while registering user")
                            } else {
                                self.gotoHomeScreenVC()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func gotoHomeScreenVC() {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeScreenVC") as! HomeScreenViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true)
    }
    
    func errorAlert(error: String) {
        let alert = UIAlertController(title: "Sign Up Failed!", message: error, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func showLoginVC(_ sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: false)
    }
}
