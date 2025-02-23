//
//  TransactionViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 21.02.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


protocol TransactionCreateDelegate: AnyObject {
    func didCreateGroup()
}

class TransactionCreateViewController: UIViewController {
    
    weak var delegate: TransactionCreateDelegate?
    
    let db = Firestore.firestore()
    var selectedGroupId: String?
    var selectedDate = Date()
    
    // MARK: Outlets
    
    @IBOutlet weak var transactionTitleInput: UITextField!
    @IBOutlet weak var transactionAmountInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        
    }
    
    // Function to check input and check it is not nil
    func processInput(_ input: String?) throws -> String {
        guard let variable = input else {
            throw TransactionError.invalidInput
        }
        return variable
    }
    
    
    // MARK: Actions
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        Task{
            do {
                // Get selected group referance
                let selectedGroupRef = self.db.collection(K.FirebaseDataGroups.collectionName)
                    .document(selectedGroupId!)
                
                // Get user
                guard let payerEmail = Auth.auth().currentUser?.email else { return }
                
                // Set transaction title
                let title = try processInput(transactionTitleInput.text)
                
                // Set amount
                let amountText = try processInput(transactionAmountInput.text)
                guard let amount = Double(amountText) else {
                    print("Invalid amount")
                    return
                }
                // Creating new Transaction instance for writing
                let newTransaction = Transaction(
                    title: title,
                    amount: amount,
                    date: selectedDate,
                    payer: payerEmail
                )
                
                let encodedTransaction: [String: Any] = [
                    "uniqueId": newTransaction.uniqueId,
                    "title": newTransaction.title,
                    "amount": newTransaction.amount,
                    "date": Timestamp(date: newTransaction.date),  // Firestore-friendly date
                    "payer": newTransaction.payer
                ]

                try await selectedGroupRef.updateData([
                    K.FirebaseDataGroups.transactionsField: FieldValue.arrayUnion([encodedTransaction])
                ])
                
                print("my new transaction \(newTransaction)")
                // Add new transaction to array
                var document = try await selectedGroupRef.getDocument().data(as: Group.self)
    
                // update each user
                let memberIds = document.memberIds
                for member in memberIds{
                    let memberRef = self.db.collection(K.FirebaseDataUsers.collectionName)
                        .document(member)
                    
                    var user = try await memberRef.getDocument().data(as: User.self)

                    if member == payerEmail {
                        user.due += amount - (amount / Double(memberIds.count))
                        try await memberRef.updateData([K.FirebaseDataUsers.dueField: user.due])
                    } else {
                        user.debt += (amount / Double(memberIds.count))
                        try await memberRef.updateData([K.FirebaseDataUsers.debtField: user.debt])
                    }
                }
                
                delegate?.didCreateGroup()

                navigationController?.popViewController(animated: true)

            }
            catch TransactionError.invalidInput {
                print(K.emptyInputErrorMessage)
            }
            catch {
                print("Error: \(error.localizedDescription)")
            }
            
            
        }
        
    }
    
    
}
