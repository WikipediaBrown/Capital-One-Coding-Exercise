//
//  TransactionContainer.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/3/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

enum TransactionTypes: String {
    case donutShop
    case unknown
}

class MonthAggregator {
    var monthAndYear: String
    var incomeWithDonuts = 0
    var incomeWithoutDonuts = 0
    var spendingWithDonuts = 0
    var spendingWithoutDonuts = 0
    
    init(monthAndYear: String, incomeWithDonuts: Int = 0, incomeWithoutDonuts: Int = 0, spendingWithDonuts: Int = 0, spendingWithoutDonuts: Int = 0) {
        self.monthAndYear = monthAndYear
        if incomeWithDonuts > 0 {self.incomeWithDonuts += incomeWithDonuts}
        if incomeWithoutDonuts > 0 {self.incomeWithoutDonuts += incomeWithoutDonuts}
        if spendingWithDonuts < 0 {self.spendingWithDonuts += spendingWithDonuts}
        if spendingWithoutDonuts < 0 {self.spendingWithoutDonuts += spendingWithoutDonuts}
    }
}

class TransactionObject {
    
    let amount: Int
    let categorization: String
    let merchant: String
    let isPending: Bool
    let transactionType: TransactionTypes
    let clearDate: Date
    let id: String
    let transactionTime: Date
    
    init (amount: Int, isPending: Bool, clearDate: Date, id: String, categorization: String, merchant: String, transactionType: TransactionTypes, transactionTime: Date) {
        self.amount = amount
        self.isPending = isPending
        self.clearDate = clearDate
        self.id = id
        self.categorization = categorization
        self.merchant = merchant
        self.transactionType = transactionType
        self.transactionTime = transactionTime
    }

}

class TransactionContainer: NSObject {
    typealias TransactionDataSource = [String: [TransactionObject]]
    typealias TransactionTotals = [String: MonthAggregator]
    let session = URLSession(configuration: .ephemeral)
    var delegate: TransactionContainerDelegate?
    
    static let shared = TransactionContainer()
    
    var dataSource = TransactionDataSource()
    var transactionTotals = TransactionTotals()
    private var sectionKeys = [String: Bool]() {
        didSet {
           dataKeys = Array(sectionKeys.keys).sorted()
        }
    }
    var dataKeys = [String]()
    
    let transactionTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        return formatter
    }()
    
    func getAccountData() {
        
        var tempDataSource = TransactionDataSource()
        var tempSectionKeys = [String: Bool]()
        
        let argumentsDictionary = ["args": [ "uid": 1110590645, "token": "C49D97196322A2DCE8543074FDFA1BA1", "api-token": "AppTokenForInterview", "json-strict-mode": false, "json-verbose-response": false]] as [String: Any]
        
        guard let data = try? JSONSerialization.data(withJSONObject: argumentsDictionary, options: .prettyPrinted) else {
            self.delegate?.errorGettingData(error: "Could not serialize argument dictionary.")
            return
        }
        guard let url = URL(string: "https://2016.api.levelmoney.com/api/v2/core/get-all-transactions") else {
            self.delegate?.errorGettingData(error: "Could not create URL from string.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = data
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.delegate?.errorGettingData(error: error.localizedDescription)
                return
            }
            guard let data = data else {
                self.delegate?.errorGettingData(error: "Error: Data object is nil.")
                return
            }
            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any] else {
                self.delegate?.errorGettingData(error: "Error: Problem serializing JSON data.")
                return
            }
            guard let transactions = jsonDictionary["transactions"] as? [[String: Any]] else {
                self.delegate?.errorGettingData(error: "Error: Problem reading transactions JSON data.")
                return
            }

            for transaction in transactions {
                
                guard let amount = transaction["amount"] as? Int else {return}
                guard let isPending = transaction["is-pending"] as? Bool else {return}
                guard let cleared = transaction["clear-date"] as? Int else {return}
                guard let transactionID = transaction["transaction-id"] as? String else {return}
                guard let categorization = transaction["categorization"] as? String else {return}
                guard let merchant = transaction["merchant"] as? String else {return}
                guard let time = transaction["transaction-time"] as? String else {return}
                
                guard let transactionTime = self.transactionTimeFormatter.date(from: time) else {
                    self.delegate?.errorGettingData(error: "Could not convert transaction time to Date().")
                    break
                }
                
                var transactionType: TransactionTypes
                if merchant == "Krispy Kreme Donuts" || merchant == "DUNKIN #336784" {
                    transactionType = .donutShop
                } else {
                    transactionType = .unknown
                }
                
                let monthAndYear = String(time.characters.prefix(7))
                tempSectionKeys.updateValue(true, forKey: monthAndYear)
                
                let clearedDate = Date(timeIntervalSince1970: TimeInterval(cleared))
                
                let transactionObject = TransactionObject(amount: amount, isPending: isPending, clearDate: clearedDate, id: transactionID, categorization: categorization, merchant: merchant, transactionType: transactionType, transactionTime: transactionTime)
                
                self.aggregateTotals(monthAndYear: monthAndYear, total: amount, category: transactionType)
                
                if var monthArray = tempDataSource[monthAndYear] {
                    monthArray.append(transactionObject)
                    monthArray.sort(by: { (first, second) -> Bool in
                        return first.transactionTime > second.transactionTime
                    })
                    tempDataSource[monthAndYear] = monthArray
                } else {
                    tempDataSource.updateValue([transactionObject], forKey: monthAndYear)
                }
                
                self.sectionKeys = tempSectionKeys
                self.dataSource = tempDataSource
                self.delegate?.completedLoadingData()
            }
        }.resume()
    }
    
    func aggregateTotals(monthAndYear: String, total: Int, category: TransactionTypes) {
        
        if let monthAggregator = transactionTotals[monthAndYear] {
            if category == .donutShop {
                if total > 0 {
                    monthAggregator.incomeWithDonuts += total
                } else {
                    monthAggregator.spendingWithDonuts += total
                }
            } else {
                if total > 0 {
                    monthAggregator.incomeWithDonuts += total
                    monthAggregator.incomeWithoutDonuts += total
                } else {
                    monthAggregator.spendingWithDonuts += total
                    monthAggregator.spendingWithoutDonuts += total
                }
            }
        } else {
            let monthAggregator = MonthAggregator(monthAndYear: monthAndYear)
            if category == .donutShop {
                if total > 0 {
                    monthAggregator.incomeWithDonuts = total
                } else {
                    monthAggregator.spendingWithDonuts = total
                }
            } else {
                if total > 0 {
                    monthAggregator.incomeWithDonuts = total
                    monthAggregator.incomeWithoutDonuts = total
                } else {
                    monthAggregator.spendingWithDonuts = total
                    monthAggregator.spendingWithoutDonuts = total
                }
            }
            transactionTotals.updateValue(monthAggregator, forKey: monthAndYear)
        }
    }
    
}

protocol TransactionContainerDelegate {
    func completedLoadingData()
    func errorGettingData(error: String)
}


