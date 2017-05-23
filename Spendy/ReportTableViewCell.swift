//
//  ReportTableViewCell.swift
//  Spendy
//
//  Created by Семен Пилюков on 21.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var spendItemImage: UIImageView!
    @IBOutlet weak var spendItemNameLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
