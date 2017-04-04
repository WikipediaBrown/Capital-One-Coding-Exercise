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
        label.alpha = 0.9
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Loading..."
        return label
    }()
    
    let transactionTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let transactionsNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.barTintColor = .red
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

}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TransactionContainer.shared.dataKeys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        defaultView.textLabel?.text = "not working"
        guard let transactionTotals = TransactionContainer.shared.transactionTotals[TransactionContainer.shared.dataKeys[section]] else {return defaultView}
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "totalsHeader")
        view?.textLabel?.text = "\(transactionTotals.monthAndYear) Total Spending: \(transactionTotals.spendingWithDonuts)"
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
        print(transaction.merchant)
        cell.setupCell(transactionObject: transaction)
        return cell
    }
}

extension AccountViewController: TransactionContainerDelegate {
    
    func errorGettingData(error: String) {
        print(error)
    }
    
    func completedLoadingData() {
        DispatchQueue.main.async(){
            self.loadingOverlay.text = "Completed"
            self.transactionTableView.reloadData()
            
            UIView.animate(withDuration: 3, animations: {
                self.loadingOverlay.alpha = 0
            })
        }
    }
}
