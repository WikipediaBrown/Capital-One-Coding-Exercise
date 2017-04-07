//
//  TransactionContainer.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/3/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class TransactionContainer: NSObject {
    
    typealias TransactionDataSource = [String: [TransactionObject]]
    typealias TransactionTotals = [String: MonthAggregator]
    typealias ObjectKeys = [String: Bool]
    typealias TransactionDictionary = [String: Any]
    
    static let shared = TransactionContainer()
    var delegate: TransactionContainerDelegate?

    var processingProgress: Float = 0.0 {
        didSet {
            DispatchQueue.main.async(){
                self.delegate?.gettingAndProcessingRecords(withPercentageComplete: self.processingProgress)
            }
        }
    }
    
    private let session = URLSession(configuration: .ephemeral)
    
    var dataSource = TransactionDataSource()
    var transactionTotals = TransactionTotals()
    var creditCardPayments = TransactionDataSource()
    private var sectionKeys = ObjectKeys() {
        didSet {
           dataKeys = Array(sectionKeys.keys).sorted().reversed()
        }
    }
    var dataKeys = [String]()
    
    private var creditCardPaymentSectionKeys = ObjectKeys() {
        didSet {
            creditCardPaymentKeys = Array(creditCardPaymentSectionKeys.keys).sorted().reversed()
        }
    }
    var creditCardPaymentKeys = [String]()
    
    private let transactionTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        return formatter
    }()
    
    func getAccountData() {
        
        let argumentsDictionary = ["args": [ "uid": 1110590645, "token": "C49D97196322A2DCE8543074FDFA1BA1", "api-token": "AppTokenForInterview", "json-strict-mode": false, "json-verbose-response": false]] as TransactionDictionary
        
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
                    self.sendError(error: error.localizedDescription)
                return
            }
            guard
                let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! TransactionDictionary,
                let transactions = jsonDictionary["transactions"] as? [TransactionDictionary]
            else {
                self.sendError(error: "The transaction data is Kurupt like the rapper.")
            return
            }

            self.processDataFromAPI(transactions: transactions)
        }.resume()
    }
    
    private func sendError(error: String) {
        DispatchQueue.main.async(){
            self.delegate?.errorGettingData(error: error)
        }
    }
    
    private func aggregateTotals(monthAndYear: String, total: Int, category: TransactionTypes) {
        
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
    
    private func processDataFromAPI(transactions: [TransactionDictionary]) {
        
        var tempDataSource = TransactionDataSource()
        var tempSectionKeys = ObjectKeys()
        var tempCreditCardPaymentSectionKeys = ObjectKeys()
        var tempCreditCardTransactions = [TransactionObject]()
        var tempCreditCardPayments = TransactionDataSource()

        var creditCardTransactionsHolder = [TransactionObject]()
        
        let totalTransactionsToProcess = transactions.count
        var totalTransactionsProcessed = 0
        
        
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
            
            let transactionObject = TransactionObject(amount: amount, isPending: isPending, clearDate: clearedDate, id: transactionID, categorization: categorization, merchant: merchant, transactionType: transactionType, transactionTime: transactionTime, monthAndYear: monthAndYear)
            
            if transactionObject.merchant == "CC Payment" || transactionObject.merchant == "Credit Card Payment" || transactionObject.categorization == "CC Payment" || transactionObject.categorization == "Credit Card Payment" {
                creditCardTransactionsHolder.append(transactionObject)
            } else {
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
            }
            totalTransactionsProcessed += 1
            processingProgress = (Float(totalTransactionsProcessed)/Float(totalTransactionsToProcess))/4
        }
        
        creditCardTransactionsHolder.sort { (this, that) -> Bool in
            return this.transactionTime > that.transactionTime
        }
        
        let checkingArray = creditCardTransactionsHolder.sorted { (this, that) -> Bool in
            return this.transactionTime > that.transactionTime
        }
        
        let totalTransactionsToCheck = checkingArray.count
        var totalTransactionsChecked = 0
        
        for checkThisIndex in stride(from: checkingArray.count - 1, through: 0, by: -1) {
            for againstThisIndex in stride(from: checkingArray.count - 1, through: 0, by: -1) {
                let checkThisTransaction = checkingArray[checkThisIndex]
                let againstThisTransaction = checkingArray[againstThisIndex]
                let interval = abs(checkThisTransaction.transactionTime.timeIntervalSince(againstThisTransaction.transactionTime))
                if interval < 86400 && -checkThisTransaction.amount == againstThisTransaction.amount {
                    if checkThisIndex < againstThisIndex {
                        guard let i = creditCardTransactionsHolder.index(where: { (object) -> Bool in
                            return checkThisTransaction.id == object.id
                        }) else {break}
                        guard let j = creditCardTransactionsHolder.index(where: { (object) -> Bool in
                            return againstThisTransaction.id == object.id
                        }) else {break}
                        tempCreditCardTransactions.append(creditCardTransactionsHolder.remove(at: i))
                        tempCreditCardTransactions.append(creditCardTransactionsHolder.remove(at: j))
                    } else {
                        guard let i = creditCardTransactionsHolder.index(where: { (object) -> Bool in
                            return checkThisTransaction.id == object.id
                        }) else {break}
                        guard let j = creditCardTransactionsHolder.index(where: { (object) -> Bool in
                            return againstThisTransaction.id == object.id
                        }) else {break}
                        tempCreditCardTransactions.append(creditCardTransactionsHolder.remove(at: i))
                        tempCreditCardTransactions.append(creditCardTransactionsHolder.remove(at: j))
                    }
                    break
                }
            }
            totalTransactionsChecked += 1
            processingProgress = ((Float(totalTransactionsChecked)/Float(totalTransactionsToCheck))/4) + 0.25
        }
        
        let totalTransactionsToPutBack = creditCardTransactionsHolder.count
        var totalTransactionsPutBack = 0
        
        for transaction in creditCardTransactionsHolder {

            self.aggregateTotals(monthAndYear: transaction.monthAndYear, total: transaction.amount, category: transaction.transactionType)
            
            if var monthArray = tempDataSource[transaction.monthAndYear] {
                monthArray.append(transaction)
                monthArray.sort(by: { (first, second) -> Bool in
                    return first.transactionTime > second.transactionTime
                })
                tempDataSource[transaction.monthAndYear] = monthArray
            } else {
                tempDataSource.updateValue([transaction], forKey: transaction.monthAndYear)
            }
            totalTransactionsPutBack += 1
            processingProgress = ((Float(totalTransactionsPutBack)/Float(totalTransactionsToPutBack))/4) + 0.50

        }
        
        let totalCreditCardPaymentsToOrder = tempCreditCardTransactions.count
        var totalCreditCardPaymentsOrdered = 0
        
        for transaction in tempCreditCardTransactions {
            if var monthArray = tempCreditCardPayments[transaction.monthAndYear] {
                monthArray.append(transaction)
                monthArray.sort(by: { (first, second) -> Bool in
                    return first.transactionTime > second.transactionTime
                })
                tempCreditCardPayments[transaction.monthAndYear] = monthArray
            } else {
                tempCreditCardPayments.updateValue([transaction], forKey: transaction.monthAndYear)
            }
            tempCreditCardPaymentSectionKeys.updateValue(true, forKey: transaction.monthAndYear)

            totalCreditCardPaymentsOrdered += 1
            processingProgress = ((Float(totalCreditCardPaymentsOrdered)/Float(totalCreditCardPaymentsToOrder))/4) + 0.75
        }
        self.sectionKeys = tempSectionKeys
        self.dataSource = tempDataSource
        self.creditCardPaymentSectionKeys = tempCreditCardPaymentSectionKeys
        self.creditCardPayments = tempCreditCardPayments
        DispatchQueue.main.async(){
            self.delegate?.completedLoadingData()
        }
    }
    
}

protocol TransactionContainerDelegate {
    func completedLoadingData()
    func errorGettingData(error: String)
    func gettingAndProcessingRecords(withPercentageComplete percent: Float)
}


