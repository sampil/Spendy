//
//  Expense.swift
//  Spendy
//
//  Created by Семен Пилюков on 29.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import RealmSwift

class Expense: Object {
    
    //MARK: Properties
    dynamic var spendItem: SpendItem?
    //TODO: add default value for deleted spend items
    // = SpendItemRealmed (value: ["name": "Deleted expense Item", "icon": (UIImagePNGRepresentation(#imageLiteral(resourceName: "finance")) as NSData?)])
    dynamic var value: Double = 0.0
    dynamic var date: Date?
}
