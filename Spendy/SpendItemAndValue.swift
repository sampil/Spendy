//
//  SpendItemAndValue.swift
//  Spendy
//
//  Created by Семен Пилюков on 22.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import Foundation

class SpendItemAndValue {
    
    let spendItem: SpendItem
    let expensesValue: Double
    
    init(spendItem: SpendItem, expensesValue: Double) {
        self.spendItem = spendItem
        self.expensesValue = expensesValue
    }
}
