//
//  TransactionTableViewCell.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/4/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    let merchantTitleLabelView: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Merchant")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let merchantLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionTimeTitleView: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Date")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionTimeView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountTitleView: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Transaction Amount")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionIDTitleView: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringSingleton.shared.transactionTitleAttributedString(title: "Transaction Number")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionIDView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isPendingView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews() {
        self.addSubview(merchantTitleLabelView)
        self.addSubview(merchantLabelView)
        self.addSubview(transactionTimeTitleView)
        self.addSubview(transactionTimeView)
        self.addSubview(transactionIDTitleView)
        self.addSubview(transactionIDView)
        self.addSubview(amountTitleView)
        self.addSubview(amountView)
        self.addSubview(isPendingView)
        self.addSubview(seperatorView)

        let viewsDictionary = ["v0": merchantTitleLabelView,"v1": merchantLabelView, "v2": transactionTimeTitleView, "v3": transactionTimeView,"v4": transactionIDTitleView,"v5": transactionIDView, "v6": amountTitleView, "v7": amountView,"v8": isPendingView, "v9": seperatorView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1][v2][v3][v4][v5][v9(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v6][v7][v8]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v4]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v5]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v6]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v7]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v8]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v9]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setupCell(transactionObject: TransactionObject) {
        self.merchantLabelView.attributedText = AttributedStringSingleton.shared.transactionMerchantAttributedString(merchant: transactionObject.merchant)
        self.transactionTimeView.attributedText = AttributedStringSingleton.shared.transactionDateAttributedString(date: transactionObject.transactionTime)
        self.amountView.attributedText = AttributedStringSingleton.shared.transactionAmountAttributedString(amount: transactionObject.amount)
        self.transactionIDView.attributedText = AttributedStringSingleton.shared.transactionIDAttributedString(id: transactionObject.id)
        self.isPendingView.attributedText = AttributedStringSingleton.shared.transactionPendingAttributedString(isPending: transactionObject.isPending)
    }
 
}
