//
//  TransactionObject.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/6/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import Foundation

class TransactionObject {
    
    var hashValue: Int {
        
        let hash = self.id.hashValue
        return hash
    }
    
    let amount: Int
    let categorization: String
    let merchant: String
    let isPending: Bool
    let transactionType: TransactionTypes
    let clearDate: Date
    let id: String
    let transactionTime: Date
    let monthAndYear: String
    
    init (amount: Int, isPending: Bool, clearDate: Date, id: String, categorization: String, merchant: String, transactionType: TransactionTypes, transactionTime: Date, monthAndYear: String) {
        self.amount = amount
        self.isPending = isPending
        self.clearDate = clearDate
        self.id = id
        self.categorization = categorization
        self.merchant = merchant
        self.transactionType = transactionType
        self.transactionTime = transactionTime
        self.monthAndYear = monthAndYear
    }
    
}

func ==(lhs: TransactionObject, rhs: TransactionObject) -> Bool {
    return lhs.id == rhs.id
}
