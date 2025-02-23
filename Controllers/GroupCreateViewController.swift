//
//  GroupCreateViewController.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 21.02.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


protocol GroupCreateDelegate: AnyObject {
    func didCreateGroup()
}



class GroupCreateViewController: UIViewController {
    
    weak var delegate: GroupCreateDelegate?

    
    let db = Firestore.firestore()
    var groupId = ""
    var members: [String] = []
    
    // MARK: - Outlets
    @IBOutlet weak var groupNameTextInput: UITextField!
    @IBOutlet weak var memberMailTextInput: UITextField!
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Function to check input and check it is not nil
    func processInput(_ input: String?) throws -> String {
        guard let variable = input else {
            throw TransactionError.invalidInput
        }
        return variable
    }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        do {
            let newMember = try processInput(memberMailTextInput.text)
            members.append(newMember)
            
        }
        catch TransactionError.invalidInput {
            print(K.emptyInputErrorMessage)
        }
        catch {
            print(K.unknownErrorMessage)
        }
        
        memberMailTextInput.text = ""
    }
    
    
    
    @IBAction func groupCreateButtonPressed(_ sender: UIButton) {
        
        Task {
            do {
                // Get active user info using firebase auth
                guard let userEmail = Auth.auth().currentUser?.email else { return }
                // Always add the login user as a member to the group
                print("my users email is \(userEmail)")
                self.members.append(userEmail)
                
                // Get input name
                let groupName = try processInput(groupNameTextInput.text)
                
                // Create a group class instance
                let newGroup = Group(
                    groupName: groupName,
                    members: self.members)
                
                self.groupId = newGroup.uniqueId
                
                try await self.db.collection(K.FirebaseDataGroups.collectionName)
                    .document(newGroup.uniqueId)
                    .setData(from: newGroup)
                
                // Update user info
                for email in self.members {
                    print(email)
                    var userGroupIds: [String] = []
                    let userRef = self.db.collection(K.FirebaseDataUsers.collectionName).document(email)
                    
                    let document = try await userRef.getDocument()
                    if document.exists{
                        userGroupIds = document.get(K.FirebaseDataUsers.groupIdsField) as! [String]
                        userGroupIds.append(self.groupId)
                    }
                
                    try await userRef.updateData([K.FirebaseDataUsers.groupIdsField: userGroupIds])
                    print("Updated groups for user: \(email)")
                }
                
                
                delegate?.didCreateGroup()

                navigationController?.popViewController(animated: true)
                
                
            } catch TransactionError.invalidInput {
                print(K.emptyInputErrorMessage)
            } catch {
                print("Error while creating new group")
            }
        }
    }
    
}
