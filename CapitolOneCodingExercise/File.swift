//
//  File.swift
//  CapitolOneCodingExercise
//
//  Created by Wikipedia Brown on 4/4/17.
//  Copyright © 2017 Perris Davis. All rights reserved.
//

import Foundation

class MonthAggregator {
    var monthAndYear: String
    var incomeWithDonuts = 0
    var incomeWithoutDonuts = 0
    var spendingWithDonuts = 0
    var spendingWithoutDonuts = 0
    
    init(monthAndYear: String, incomeWithDonuts: Int = 0, incomeWithoutDonuts: Int = 0, spendingWithDonuts: Int = 0, spendingWithoutDonuts: Int = 0) {
        self.monthAndYear = monthAndYear
        if incomeWithDonuts > 0 {self.incomeWithDonuts += incomeWithDonuts}
        if incomeWithoutDonuts > 0 {self.incomeWithoutDonuts += incomeWithoutDonuts}
        if spendingWithDonuts < 0 {self.spendingWithDonuts += spendingWithDonuts}
        if spendingWithoutDonuts < 0 {self.spendingWithoutDonuts += spendingWithoutDonuts}
    }
}
