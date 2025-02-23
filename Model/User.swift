//
//  User.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 20.02.2025.
//

import Foundation

class User: Codable {
    
    let displayName: String
    let email: String
    var debt: Double
    var due: Double
    var groupIds: [String]
    
    
    init(displayName: String, email: String) {
        self.displayName = displayName
        self.email = email
        self.debt = 0.0
        self.due = 0.0
        self.groupIds = []
    }
    
    func calculateTotal() -> Double {
        return self.due - self.debt
    }
    
}







