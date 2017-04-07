//
//  AttributedStringSingleton.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/4/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class AttributedStringSingleton {
    
    static let shared = AttributedStringSingleton()

    func transactionAmountAttributedString(amount: Int) -> NSAttributedString {
        
        let debitAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 65/255, blue: 12/255, alpha: 1)
        ]
        
        let creditAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 65/255, green: 183/255, blue: 68/255, alpha: 1)
        ]
        
        var string: NSMutableAttributedString
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        guard let dollars = formatter.string(from: NSNumber(value: Float(amount)/Float(10000))) else {return NSMutableAttributedString(string: "Error")}
        
        if amount > 0 {
            string = NSMutableAttributedString(string: dollars, attributes: creditAttributes)
        } else {
            string = NSMutableAttributedString(string: dollars, attributes: debitAttributes)
        }
        
        return string
    }
    
    func transactionTotalsAttributedString(amount: Int) -> NSAttributedString {
        
        let debitAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 65/255, blue: 12/255, alpha: 1)
        ]
        
        let creditAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 65/255, green: 183/255, blue: 68/255, alpha: 1)
        ]
        
        var string: NSMutableAttributedString
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        guard let dollars = formatter.string(from: NSNumber(value: Float(amount)/Float(10000))) else {return NSMutableAttributedString(string: "Error")}
        
        if amount >= 0 {
            string = NSMutableAttributedString(string: dollars, attributes: creditAttributes)
        } else {
            string = NSMutableAttributedString(string: dollars, attributes: debitAttributes)
        }
        
        return string
    }
    
    func creditCardPaymentAmountAttributedString(amount: Int) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        var string: NSMutableAttributedString
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        guard let dollars = formatter.string(from: NSNumber(value: Float(amount)/Float(10000))) else {return NSMutableAttributedString(string: "Error")}
        
        string = NSMutableAttributedString(string: dollars, attributes: copyAttributes)

        return string
    }
    
    func transactionMerchantAttributedString(merchant: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]

        let string = NSMutableAttributedString(string: merchant, attributes: copyAttributes)
        
        return string
    }
    
    func transactionDateAttributedString(date: Date) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        let dateString = formatter.string(from: date)
        
        let string = NSMutableAttributedString(string: dateString, attributes: copyAttributes)
        
        return string
    }
    
    func transactionIDAttributedString(id: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        let string = NSMutableAttributedString(string: id, attributes: copyAttributes)
        
        return string
    }
    
    func transactionPendingAttributedString(isPending: Bool) -> NSAttributedString {
        
        var string: NSMutableAttributedString
        
        let isPendingAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 65/255, blue: 12/255, alpha: 1)
        ]
        
        let isNotPendingAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 65/255, green: 183/255, blue: 68/255, alpha: 1)
        ]
        
        if isPending == true {
            string = NSMutableAttributedString(string: "Pending", attributes: isPendingAttributes)
        } else {
            string = NSMutableAttributedString(string: "Cleared", attributes: isNotPendingAttributes)
        }
        
        return string
    }
    
    func transactionTitleAttributedString(title: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8),
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        
        let string = NSMutableAttributedString(string: title, attributes: copyAttributes)
        
        return string
    }
    
    func creditCardPaymentsTitleAttributedString(title: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let string = NSMutableAttributedString(string: title, attributes: copyAttributes)
        
        return string
    }
    
    func transactionNavigationBarAttributedString(title: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let string = NSMutableAttributedString(string: title, attributes: copyAttributes)
        
        return string
    }
    
    func creditCardPaymentsHeaderTitleAttributedString(title: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let string = NSMutableAttributedString(string: title, attributes: copyAttributes)
        
        return string
    }
    
    func getMonthString(monthAndYear: String, creditCardPayment: Bool) -> NSAttributedString {
        var month = String(monthAndYear.characters.dropFirst(5))
        
        switch month {
        case "01":
            month = "January"
        case "02":
            month = "February"
        case "03":
            month = "March"
        case "04":
            month = "April"
        case "05":
            month = "May"
        case "06":
            month = "June"
        case "07":
            month = "July"
        case "08":
            month = "September"
        case "09":
            month = "August"
        case "10":
            month = "October"
        case "11":
            month = "November"
        case "12":
            month = "December"
        default:
            month = "Monthless"
        }
        let transactionsAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        let creditCardPaymentsAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            NSForegroundColorAttributeName: UIColor.white
        ]
        var string: NSMutableAttributedString
        if creditCardPayment {
            string = NSMutableAttributedString(string: month, attributes: creditCardPaymentsAttributes)
        } else {
            string = NSMutableAttributedString(string: month, attributes: transactionsAttributes)
        }
        
        return string
    }

}
