//
//  HomeViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    
    let db = Firestore.firestore()
    
    // MARK: Outlets
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Get active user info using firebase auth
        let getUserInfo: () async -> Void = {
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            let docRef = self.db.collection(K.FirebaseDataUsers.collectionName).document(userEmail)
            do {
                // Get user data info using email as key
                let data = try await docRef.getDocument(as: User.self)
                // Set variables
                self.displayNameLabel.text = data.displayName
                self.debtLabel.text = "\(data.debt) $"
                self.dueLabel.text = "\(data.due) $"
                self.totalBalanceLabel.text = "\(data.calculateTotal()) $"
            }
            catch {
                print("Error getting document: \(error)")
            }
        }
        Task {
            await getUserInfo()
        }
    }
    
    // MARK: Actions
    
    @IBAction func currencyButtonPressed(_ sender: Any) {
        // TODO: Call currency API to see rates
    }
    
   
    
    
    
    
    
    
}
