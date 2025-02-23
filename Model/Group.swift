//
//  Group.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import Foundation

class Group: Codable {
    let uniqueId: String
    var groupName: String
    var transactionList: [Transaction]
    var memberIds: [String]
    var totalAmountSpent: Double

    init(groupName: String, members: [String]) {
        self.uniqueId = UUID().uuidString
        self.groupName = groupName
        self.memberIds = members
        self.transactionList = []
        self.totalAmountSpent = 0
    }

    enum CodingKeys: String, CodingKey {
        case uniqueId
        case groupName
        case transactionList
        case memberIds
        case totalAmountSpent
    }

    
    func getMembers() -> [String] {
        return memberIds
    }
    
    func getTransactionList() -> [Transaction] {
        return transactionList
    }
    
    func addMember(userId: String){
        self.memberIds.append(userId)
    }
    
    func deleteMember(userId: String){
        self.memberIds.removeAll { $0 == userId }
    }
    
    func addTransaction(transaction: Transaction){
        self.transactionList.append(transaction)
        self.totalAmountSpent += transaction.amount
    }
    
    func removeTransaction(transaction: Transaction){
        self.totalAmountSpent -= transaction.amount
        self.transactionList.removeAll{ $0.uniqueId == transaction.uniqueId}
    }
    
    
    


}

