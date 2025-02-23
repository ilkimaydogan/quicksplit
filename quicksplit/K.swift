//
//  Constants.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

struct K {
    static let registerSegue = "RegisterToApp"
    static let loginSegue = "LoginToApp"
    static let groupAddSegue = "AddNewGroup"
    static let groupDetailSegue = "GoToGroupTransactions"
    static let transactionSavedSegue = "GoToGroupList"
    static let groupCreatedSegue = "GroupCreated"
    static let groupTransactionDetailSegue = "GoToGroupTransactionList"
    static let createNewTransactionSeque = "CreateNewTransaction"
    static let emptyInputErrorMessage = "The input field can not be left empty"
    static let unknownErrorMessage = "There's an unknown error :)"
    
    struct FirebaseDataGroups {
        static let collectionName = "groups"
        static let nameField = "groupName"
        static let membersField = "members"
        static let transactionsField = "transactions"
        
    }
    
    struct FirebaseDataUsers {
        static let collectionName = "users"
        static let displayNameField = "displayName"
        static let emailField = "email"
        static let debtField = "debt"
        static let dueField = "due"
        static let groupIdsField = "groupIds"
    }
    
    struct CellNames {
        static let groupCellNibName = "GroupCell"
        static let groupCellIdentifier = "GroupDetailCell"
        
        static let transactionCellNibName = "TransactionCell"
        static let transactionCellIdentifier = "TransactionDetailCell"
    }
}
