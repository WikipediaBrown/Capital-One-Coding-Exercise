//
//  CreditCardPaymentsViewController.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/6/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class CreditCardPaymentsViewController: UIViewController {
    
    let creditCardPaymentsNavigationBar: TransactionsNavigationBar = {
        let navigationBar = TransactionsNavigationBar()
        navigationBar.barTintColor = UIColor(colorLiteralRed: 140/255, green: 0, blue: 0, alpha: 1)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    let creditCardPaymentsTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(creditCardPaymentsNavigationBar)
        self.view.addSubview(creditCardPaymentsTableView)
        
        self.creditCardPaymentsNavigationBar.incomeLabel.attributedText = AttributedStringSingleton.shared.creditCardPaymentsHeaderTitleAttributedString(title: "Payments")

        self.creditCardPaymentsNavigationBar.incomeTitleLabel.alpha = 0
        self.creditCardPaymentsNavigationBar.spendingLabel.attributedText = AttributedStringSingleton.shared.creditCardPaymentsHeaderTitleAttributedString(title: "Credit Card")
        self.creditCardPaymentsNavigationBar.spendingTitleLabel.alpha = 0
        creditCardPaymentsTableView.dataSource = self
        creditCardPaymentsTableView.delegate = self
        self.creditCardPaymentsNavigationBar.showCreditCardTransactionsButton.backgroundColor = UIColor(colorLiteralRed: 54/255, green: 72/255, blue: 94/255, alpha: 1)
        self.creditCardPaymentsNavigationBar.showCreditCardTransactionsButton.addTarget(self, action: #selector(dismissCreditCardPaymentsButtontapped), for: .touchUpInside)
        
        self.creditCardPaymentsTableView.register(CreditCardPaymentsHeaderView.self, forHeaderFooterViewReuseIdentifier: "creditCardPaymentsHeaderView")
        self.creditCardPaymentsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "transactionTableViewCell")
        
        let viewsDictionary = ["v0": creditCardPaymentsTableView, "v1": creditCardPaymentsNavigationBar]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1(65)][v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func dismissCreditCardPaymentsButtontapped() {
        self.presentingViewController?.dismiss(animated: true, completion: { 
        })
    }

}

extension CreditCardPaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TransactionContainer.shared.creditCardPaymentKeys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        defaultView.textLabel?.text = "not working"
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "creditCardPaymentsHeaderView") as? CreditCardPaymentsHeaderView else {return defaultView}
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? CreditCardPaymentsHeaderView else {return}
        header.backgroundView?.backgroundColor = UIColor(colorLiteralRed: 54/255, green: 72/255, blue: 94/255, alpha: 1)
        let date = TransactionContainer.shared.creditCardPaymentKeys[section]
        guard let transactionArray = TransactionContainer.shared.creditCardPayments[date] else {return}
        let transactionObject = transactionArray[0]
        header.setupHeader(transactionObject: transactionObject)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = TransactionContainer.shared.creditCardPaymentKeys[section]
        guard let array = TransactionContainer.shared.creditCardPayments[date] else {return 0}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        defaultCell.textLabel?.text = "couldn't get cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell") as? TransactionTableViewCell else {return defaultCell}
        guard let transaction = TransactionContainer.shared.creditCardPayments[TransactionContainer.shared.creditCardPaymentKeys[indexPath.section]]?[indexPath.row] else {return defaultCell}
        cell.setupCell(transactionObject: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
