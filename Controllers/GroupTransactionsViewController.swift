//
//  GroupTransactionsViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GroupTransactionsViewController: UIViewController {

    let db = Firestore.firestore()
    // getting transactions from other screen
    var selectedGroupId: String?
    // to send destination VC
    var selectedTransaction: Transaction?
    // for table
    var transactions: [Transaction] = []
    
    // MARK: - Outlets
    @IBOutlet weak var groupTransactionsTable: UITableView!
    

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        groupTransactionsTable.dataSource = self
        // Register nib
        groupTransactionsTable.register(UINib(nibName: K.CellNames.transactionCellNibName, bundle: nil), forCellReuseIdentifier: K.CellNames.transactionCellIdentifier)
        reloadTransactions()
    }
    
    // Function to fetch group data from firebase
    func fetchGroupData(groupId: String) async throws -> Group {
        let dataRef = self.db.collection(K.FirebaseDataGroups.collectionName).document(groupId)
        return try await dataRef.getDocument(as: Group.self)
    }
    
    func reloadTransactions() {
        Task {
            // If there are transactions clear it
            transactions = []
            
            let docRef = self.db.collection(K.FirebaseDataGroups.collectionName).document(selectedGroupId!)
            do {
                // Get group data using groupId as key
                let data = try await docRef.getDocument(as: Group.self)
                transactions = data.getTransactionList()
                DispatchQueue.main.async { self.groupTransactionsTable.reloadData()
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    // Send transactions to new view and set delegate for group refresh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.createNewTransactionSeque {
            if let destinationVC = segue.destination as? TransactionCreateViewController {
                destinationVC.selectedGroupId = self.selectedGroupId
                destinationVC.delegate = self
            }
        }
    }
    
    
    
    
    
    
    // MARK: Actions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.createNewTransactionSeque, sender: self)
        
        // TODO: Need hazırla segue pass groupid
        
    }
    
}

// MARK: - Extensions

extension GroupTransactionsViewController: TransactionCreateDelegate {
    // Reload groups when a new transaction is created
     func didCreateGroup() {
         print("New transaciton created. Reloading...")
         reloadTransactions()
     }

}

extension GroupTransactionsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellNames.transactionCellIdentifier, for: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        
        let formatterMonth = DateFormatter()
        formatterMonth.dateFormat = "MMM"  // Short month name
        
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "dd" // Two digit
        
        cell.monthLabel.text = formatterMonth.string(from: transaction.date)
        cell.dayLabel.text = formatterDay.string(from: transaction.date)
        cell.transactionTitleLabel.text = transaction.title
        cell.transactionPayerLabel.text = transaction.payer
        cell.transactionAmountLabel.text = String(transaction.amount)

        return cell
    }
    
}


