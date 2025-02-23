//
//  GroupViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class GroupViewController: UIViewController {
    
    let db = Firestore.firestore()
    // To send to destinationVC
    var selectedGroup: Group?
    // For TableView show
    var groups: [Group] = []
    
    // MARK: - Outlets
    @IBOutlet weak var groupTableView: UITableView!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        // register nib
        groupTableView.register(UINib(nibName: K.CellNames.groupCellNibName, bundle: nil), forCellReuseIdentifier: K.CellNames.groupCellIdentifier)
        reloadGroups()
    }
    
    // Function to fetch group data from firebase
    func fetchGroupData(groupId: String) async throws -> Group {
        let dataRef = self.db.collection(K.FirebaseDataGroups.collectionName).document(groupId)
        return try await dataRef.getDocument(as: Group.self)
    }
    
    func reloadGroups() {
        Task {
            // If there are groups clear it
            groups = []
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            let docRef = self.db.collection(K.FirebaseDataUsers.collectionName).document(userEmail)
            
            do {
                // Get user data info using email as key
                let data = try await docRef.getDocument(as: User.self)
                let groupIds = data.groupIds
                // Fetch group data from user
                for id in groupIds{
                    let groupData = try await fetchGroupData(groupId: id)
                    self.groups.append(groupData)
                }
                
                DispatchQueue.main.async { self.groupTableView.reloadData()
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
    }
    
    // Send transactions to new view and set delegate for group refresh
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.groupAddSegue {
            if let destinationVC = segue.destination as? GroupCreateViewController {
                destinationVC.delegate = self
            }
        }
        
        if segue.identifier == K.groupTransactionDetailSegue {
            let destinationVC = segue.destination as! GroupTransactionsViewController
            destinationVC.selectedGroupId = self.selectedGroup?.uniqueId ?? ""
        }
    }
    

    // MARK: Actions
    
    @IBAction func groupAddButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.groupAddSegue, sender: self)
    }
    

    
}


// MARK: - Extensions

extension GroupViewController: GroupCreateDelegate {
    // Reload groups when a new group is created
     func didCreateGroup() {
         print("New group created. Reloading...")
         reloadGroups()
     }

}

extension GroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Groups array count is \(groups.count)")
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellNames.groupCellIdentifier, for: indexPath) as! GroupCell
        // Set cell outlets
        cell.groupNameLabel.text = groups[indexPath.row].groupName
        cell.memberTotalLabel.text = " \(groups[indexPath.row].memberIds.count) members."
        cell.totalSpendingLabel.text = String(groups[indexPath.row].totalAmountSpent)
        print("Cell write is completed")
        return cell
    }
}

extension GroupViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGroup = groups[indexPath.row]
        self.performSegue(withIdentifier: K.groupTransactionDetailSegue, sender: self)
    }
    
}
