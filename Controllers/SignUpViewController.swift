//
//  SignInViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    

    
    
    // MARK: Main func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Functions
    
    @IBAction func signUpPressed(_ sender: UIButton) {

        
        // Getting user inputs and checking for nulls.
        
        if let displayName = displayNameField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) {
                authResult, error in
                if let e = error {
                    // TODO: Check if email is already in usage
                    // TODO: Password must be at least 6 digit long
                    // TODO: No text field should be empty add pop up errors.
                    // TODO: can display error as a pop up in next version
                    
                    print(e.localizedDescription)
                    
                } else {
                    
                    // TODO: Check if the nickname does exist
                
                    // Creating the user struct
                    let user = User(displayName: displayName, email: email)
                    
                    // Registering the user to the database
                    do {
                        try self.db.collection(K.FirebaseDataUsers.collectionName)
                            .document(user.email)
                            .setData(from: user)
                    } catch let error {
                        print("Error writing user to Firestore: \(error)")
                    }
                    
                    // Navigating to the next view
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
    
    // MARK: - Todos
    
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
    }
    
}
