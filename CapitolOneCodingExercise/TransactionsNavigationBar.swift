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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        barTintColor = UIColor(colorLiteralRed: 54/255, green: 72/255, blue: 94/255, alpha: 1)

        self.addSubview(spendingTitleLabel)
        self.addSubview(spendingLabel)
        self.addSubview(incomeTitleLabel)
        self.addSubview(incomeLabel)
        
        let viewsDictionary = ["v0": spendingTitleLabel,"v1": spendingLabel, "v2": incomeTitleLabel, "v3": incomeLabel]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v2][v3]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }

}
