//
//  CreditCardPaymentsHeaderView.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/6/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class CreditCardPaymentsHeaderView: UITableViewHeaderFooterView {

    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.creditCardPaymentsTitleAttributedString(title: "Payment Amount")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(paymentTitleLabel)
        self.addSubview(paymentLabel)
        self.addSubview(yearLabel)
        self.addSubview(monthLabel)
        
        let viewsDictionary = ["v0": paymentTitleLabel,"v1": paymentLabel, "v2": yearLabel, "v3": monthLabel]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v2][v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setupHeader(transactionObject: TransactionObject) {
            paymentLabel.attributedText = AttributedStringSingleton.shared.creditCardPaymentAmountAttributedString(amount: abs(transactionObject.amount))
            yearLabel.attributedText = AttributedStringSingleton.shared.creditCardPaymentsTitleAttributedString(title: String(transactionObject.monthAndYear.characters.dropLast(3)))
            monthLabel.attributedText = AttributedStringSingleton.shared.getMonthString(monthAndYear: transactionObject.monthAndYear, creditCardPayment: true)
    }

}
