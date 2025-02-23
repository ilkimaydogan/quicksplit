//
//  Transaction.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 21.02.2025.
//

import Foundation

public struct Transaction: Codable {
    let uniqueId: String
    let title: String
    let amount: Double
    let date: Date
    let payer: String

    // Init for setting UUID as String
    init(title: String, amount: Double, date: Date, payer: String) {
        self.uniqueId = UUID().uuidString
        self.title = title
        self.amount = amount
        self.date = date
        self.payer = payer
    }

    enum CodingKeys: String, CodingKey {
        case uniqueId
        case title
        case amount
        case date
        case payer
    }
}

