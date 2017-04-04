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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1][v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0][v3(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1][v3(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v3][v3(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0][v4(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1][v4(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v3][v4(70)]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setupCell(transactionObject: TransactionObject) {
        self.merchantLabelView.text = transactionObject.merchant
        self.transactionTimeView.text = transactionObject.transactionTime.description
        self.amountView.text = String(transactionObject.amount)
        self.transactionIDView.text = transactionObject.id
        if transactionObject.isPending {
            self.isPendingView.backgroundColor = .blue
        } else {
            self.isPendingView.backgroundColor = .green
        }
    }
 
}
