//
//  TransactionsNavigationBar.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/5/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class TransactionsNavigationBar: UINavigationBar {
    
    let spendingTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionNavigationBarAttributedString(title: "Average Spending Per Month")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let spendingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionNavigationBarAttributedString(title: "Average Income Per Month")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let showCreditCardTransactionsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = UIScreen.main.bounds.width/18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.addSubview(spendingTitleLabel)
        self.addSubview(spendingLabel)
        self.addSubview(incomeTitleLabel)
        self.addSubview(incomeLabel)
        self.addSubview(showCreditCardTransactionsButton)

        let viewsDictionary = ["v0": spendingTitleLabel,"v1": spendingLabel, "v2": incomeTitleLabel, "v3": incomeLabel, "v4": showCreditCardTransactionsButton]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v2][v3]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v4(\(UIScreen.main.bounds.width/9))]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\((UIScreen.main.bounds.width/9)*4)-[v4]-\((UIScreen.main.bounds.width/9)*4)-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))

    }

}
