//
//  TotalsHeaderView.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/4/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class TotalsHeaderView: UITableViewHeaderFooterView {
    
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
    
    let spendingTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Spent")
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
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Income")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let donutToggleTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Toggle Donuts")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let donutToggleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.75
        button.layer.shadowOffset = CGSize(width: 2, height: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var showDonutTransactions = true
    
    var monthAggregator: MonthAggregator?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        refreshViews()
        super.layoutSubviews()
    }
    
    func setupViews() {
        self.addSubview(donutToggleTitleLabel)
        self.addSubview(donutToggleButton)
        self.addSubview(spendingTitleLabel)
        self.addSubview(spendingLabel)
        self.addSubview(incomeTitleLabel)
        self.addSubview(incomeLabel)
        self.addSubview(yearLabel)
        self.addSubview(monthLabel)
                
        let viewsDictionary = ["v0": donutToggleTitleLabel,"v1": donutToggleButton, "v2": spendingTitleLabel, "v3": spendingLabel,"v4": incomeTitleLabel,"v5": incomeLabel, "v6": yearLabel, "v7": monthLabel]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-4-[v1(44)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v2][v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v4][v5]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v6][v7]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[v0(66)][v2(100)][v4(100)][v6]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-11-[v1(44)]-11-[v3(100)][v5(100)][v7]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func refreshViews() {
        guard let monthAggregator = self.monthAggregator else {return}
        if showDonutTransactions == true {
            spendingTitleLabel.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Spent")
            spendingLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.spendingWithDonuts)
            incomeLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.incomeWithDonuts)
            donutToggleButton.layer.shadowOpacity = 0.75
            donutToggleButton.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        } else {
            spendingTitleLabel.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Spent Sans Donuts")
            spendingLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.spendingWithoutDonuts)
            incomeLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.incomeWithoutDonuts)
            donutToggleButton.layer.shadowOpacity = 0.0
            donutToggleButton.backgroundColor = .brown
        }
    }
    
    func setupHeader(monthAggregator: MonthAggregator) {
        self.monthAggregator = monthAggregator
        if showDonutTransactions == true {
            spendingLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.spendingWithDonuts)
            incomeLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.incomeWithDonuts)
            yearLabel.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: String(monthAggregator.monthAndYear.characters.dropLast(3)))
            monthLabel.attributedText = AttributedStringSingleton.shared.getMonthString(monthAndYear: monthAggregator.monthAndYear, creditCardPayment: false)
        } else {
            spendingLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.spendingWithoutDonuts)
            incomeLabel.attributedText = AttributedStringSingleton.shared.transactionTotalsAttributedString(amount: monthAggregator.incomeWithoutDonuts)
            yearLabel.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: String(monthAggregator.monthAndYear.characters.dropLast(3)))
            monthLabel.attributedText = AttributedStringSingleton.shared.getMonthString(monthAndYear: monthAggregator.monthAndYear, creditCardPayment: false)
        }
    }

}
