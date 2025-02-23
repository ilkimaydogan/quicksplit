//
//  LoginViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }
    
    // MARK: Functions
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    // Navigating to the next view
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
            
        }
    }
    
}
