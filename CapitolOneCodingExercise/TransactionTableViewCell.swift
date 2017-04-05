//
//  TransactionTableViewCell.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/4/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    let merchantLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let transactionTimeView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountView: UILabel = {
        let label = UILabel()
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
        self.addSubview(merchantLabelView)
        self.addSubview(transactionTimeView)
        self.addSubview(amountView)
        self.addSubview(transactionIDView)
        self.addSubview(isPendingView)

        let viewsDictionary = ["v0": merchantLabelView, "v1": transactionTimeView,"v2": amountView, "v3": transactionIDView,"v4": isPendingView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1][v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v3][v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setupCell(transactionObject: TransactionObject) {
        self.merchantLabelView.attributedText = AttributedStringSingleton.shared.transactionMerchantAttributedString(merchant: transactionObject.merchant)
        self.transactionTimeView.attributedText = AttributedStringSingleton.shared.transactionDateAttributedString(date: transactionObject.transactionTime)
        self.amountView.attributedText = AttributedStringSingleton.shared.transactionAmountAttributedString(amount: transactionObject.amount)
        self.transactionIDView.attributedText = AttributedStringSingleton.shared.transactionIDAttributedString(id: transactionObject.id)
        self.isPendingView.attributedText = AttributedStringSingleton.shared.transactionPendingAttributedString(isPending: transactionObject.isPending)
    }
 
}
