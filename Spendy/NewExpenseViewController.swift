//
//  NewExpenseViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 13.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import RealmSwift

class NewExpenseViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties

    @IBOutlet weak var spendItemImage: UIImageView!
    @IBOutlet weak var spendItemNameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `SpendTableViewController` in `prepare(for:sender:)`
     WE NEED ONLY EXPENSE
     */
    var spendItem: SpendItem?
    var expense: Expense?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup expense name icon and name
        if let icon = spendItem?.icon {
            spendItemImage.image = UIImage(data: icon as Data, scale:1.0)
        }
        if let name = spendItem?.name {
            spendItemNameLabel.text = name
        }
        if let value = expense?.value {
            valueTextField.text = String(value)
        }
        
        // Become texfield delegate
        valueTextField.delegate = self
        
        // Make texfield in focus
        valueTextField.becomeFirstResponder()
        
        // Update Save Button.
        updateSaveButtonState()
    }
    
    //Textfield delegates
    
    // Verify textfield's text while editing
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        // Max 2 fractional digits allowed
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
        let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.characters.count))
        guard matches.count == 0 else { return false }
        
        // Only digits allowed
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let array = textField.text?.characters.map { String($0) }
            var decimalCount = 0
            for character in array! {
                if character == "." {
                    decimalCount += 1
                }
            }
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            if textField.text != nil {
                return true
            }
            return false
        }
    }

    
    //MARK: Actions
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func textFieldEditing(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Save new Expense to data base, lots of optionals
//        expense?.value = Double((valueTextField.text)!)!
//        
//        try! realm.write {
//            realm.add(expense!)
//        }
        
        if let currentSpendItem = spendItem {
            if let currentTextValue = valueTextField.text {
                if let value = Double(currentTextValue) {
                    let expense = Expense(value: ["spendItem" : currentSpendItem, "value" : value, "date" : Date()])
                    try! realm.write {
                        realm.add(expense)
                    }
                }
            }
        }
     }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState () {
        
        // Disable the Save button if the value text field is empty or invalid
        let text = valueTextField.text ?? ""
        let textEndsWithDecimal = text.hasSuffix(".")
        if text.isEmpty || textEndsWithDecimal {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}
