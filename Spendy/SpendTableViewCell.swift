//
//  SpendTableViewCell.swift
//  Spendy
//
//  Created by Семен Пилюков on 24.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit

class SpendTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var spendItemIcon: UIImageView!
    @IBOutlet weak var spendItemNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
