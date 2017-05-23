//
//  NewExpenseViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 13.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit

class NewExpenseViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var spendItemNameLabel: UILabel!
    @IBOutlet weak var expenseValueLabel: UILabel!
    
    var spendItem: SpendItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let icon = spendItem?.icon {
            iconImage.image = icon
        }
        
        if let name = spendItem?.name {
            spendItemNameLabel.text = name
        }
    }

    //MARK: Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
