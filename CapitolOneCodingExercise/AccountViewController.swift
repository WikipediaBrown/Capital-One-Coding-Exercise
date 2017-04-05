//
//  AccountViewController.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/3/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    let loadingOverlay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        label.alpha = 0.7
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Loading..."
        return label
    }()
    
    let errorAlert: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: -64, width: Int(UIScreen.main.bounds.width), height: Int(64)))
        label.backgroundColor = .red
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let transactionTableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let transactionsNavigationBar: TransactionsNavigationBar = {
        let navigationBar = TransactionsNavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        
        self.view.addSubview(transactionsNavigationBar)
        self.view.addSubview(transactionTableView)
        self.view.addSubview(loadingOverlay)
        
        TransactionContainer.shared.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        self.transactionTableView.register(TotalsHeaderView.self, forHeaderFooterViewReuseIdentifier: "totalsHeader")
        self.transactionTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "transactionTableViewCell")

        let viewsDictionary = ["v0": transactionTableView, "v1": transactionsNavigationBar, "v2": loadingOverlay]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1(65)][v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    func donutTogglePressed(sender: UIButton) {
        print("start")
        guard let header = sender.superview as? TotalsHeaderView else {return}
        
        DispatchQueue.main.async(){
            if header.showDonutTransactions == true {
                header.showDonutTransactions = false
                header.layoutSubviews()
            } else {
                header.showDonutTransactions = true
                header.layoutSubviews()
            }
        }
        
        print("working nigga")
    }

}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TransactionContainer.shared.dataKeys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        defaultView.textLabel?.text = "not working"
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "totalsHeader") as? TotalsHeaderView else {return defaultView}
        view.donutToggleButton.addTarget(self, action: #selector(donutTogglePressed), for: .touchUpInside)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? TotalsHeaderView else {return}
        guard let monthAggregator = TransactionContainer.shared.transactionTotals[TransactionContainer.shared.dataKeys[section]] else {return }
        header.setupHeader(monthAggregator: monthAggregator)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = TransactionContainer.shared.dataKeys[section]
        guard let array = TransactionContainer.shared.dataSource[date] else {return 0}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        defaultCell.textLabel?.text = "couldn't get cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell") as? TransactionTableViewCell else {return defaultCell}
        guard let transaction = TransactionContainer.shared.dataSource[TransactionContainer.shared.dataKeys[indexPath.section]]?[indexPath.row] else {return defaultCell}
        cell.setupCell(transactionObject: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension AccountViewController: TransactionContainerDelegate {
    
    func errorGettingData(error: String) {
        showError(error: error)
    }
    
    func completedLoadingData() {
        self.loadingOverlay.text = "Completed"
        self.transactionTableView.reloadData()
        self.refreshData()
        UIView.animate(withDuration: 1.4, animations: {
            self.loadingOverlay.alpha = 0
        })
    }
    
    func refreshData() {
        var months = 0
        var averageSpendingWithDonuts = 0
        var averageIncomeWithDonuts = 0
        var averageSpendingWithoutDonuts = 0
        var averageIncomeWithoutDonuts = 0
        
        for monthAggregator in TransactionContainer.shared.transactionTotals {
            averageIncomeWithDonuts += monthAggregator.value.incomeWithDonuts
            averageSpendingWithDonuts += monthAggregator.value.spendingWithDonuts
            averageIncomeWithoutDonuts += monthAggregator.value.incomeWithoutDonuts
            averageSpendingWithoutDonuts += monthAggregator.value.spendingWithoutDonuts
            months += 1
        }
        self.transactionsNavigationBar.spendingLabel.attributedText = AttributedStringSingleton.shared.transactionAmountAttributedString(amount: averageSpendingWithDonuts/months)
        self.transactionsNavigationBar.incomeLabel.attributedText = AttributedStringSingleton.shared.transactionAmountAttributedString(amount: averageIncomeWithDonuts/months)
        self.transactionsNavigationBar.layoutSubviews()
    }
    
    func showError(error: String) {
        errorAlert.text = error
        self.view.addSubview(errorAlert)

        UIView.animate(withDuration: 1, animations: {
            self.errorAlert.center.y += 64
        }) { (true) in
            UIView.animate(withDuration: 1) {
                self.errorAlert.center.y -= 64
            }
        }
        
    }
}
