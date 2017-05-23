//
//  SpendItem.swift
//  Spendy
//
//  Created by Семен Пилюков on 18.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import RealmSwift

class SpendItem: Object {
    
    // Class for persisting in Realm Data Base.
    // Icon needed to be converted to 'NSData' before storing
    dynamic var name: String?
    dynamic var icon: NSData?
    dynamic var orderPostion = 0
}
