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
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 65/255, blue: 12/255, alpha: 1)
        ]
        
        let creditAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 65/255, green: 183/255, blue: 68/255, alpha: 1)
        ]
        
        var string: NSMutableAttributedString
        
        let formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        guard let dollars = formatter.string(from: NSNumber(value: Float(amount)/Float(100))) else {return NSMutableAttributedString(string: "Error")}
        
        if amount > 0 {
            string = NSMutableAttributedString(string: dollars, attributes: creditAttributes)
        } else {
            string = NSMutableAttributedString(string: dollars, attributes: debitAttributes)
        }
        
        return string
    }
    
    func transactionMerchantAttributedString(merchant: String) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout),
            NSForegroundColorAttributeName: UIColor.darkText
        ]

        let string = NSMutableAttributedString(string: merchant, attributes: copyAttributes)
        
        return string
    }
    
    func transactionDateAttributedString(date: Date) -> NSAttributedString {
        
        let copyAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1),
            NSForegroundColorAttributeName: UIColor.darkText
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
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: .footnote),
            NSForegroundColorAttributeName: UIColor.darkText
        ]
        
        let string = NSMutableAttributedString(string: id, attributes: copyAttributes)
        
        return string
    }
    
    func transactionPendingAttributedString(isPending: Bool) -> NSAttributedString {
        
        var string: NSMutableAttributedString
        
        let isPendingAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 200/255, green: 65/255, blue: 12/255, alpha: 1)
        ]
        
        let isNotPendingAttributes = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline),
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 65/255, green: 183/255, blue: 68/255, alpha: 1)
        ]
        
        if isPending == true {
            string = NSMutableAttributedString(string: "Pending", attributes: isPendingAttributes)
        } else {
            string = NSMutableAttributedString(string: "Cleared", attributes: isNotPendingAttributes)
        }
        
        return string
    }

}
