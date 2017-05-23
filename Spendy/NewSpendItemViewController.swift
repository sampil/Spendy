//
//  NewSpendItemViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 23.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class NewSpendItemViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    
    @IBOutlet weak var currentIconImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    let realm = try! Realm()

    /*
     This value is either passed by `SpendTableViewController` in `prepare(for:sender:)`     
     */
    var spendItem: SpendItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Disable SaveButton if text field is empty
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    
    //MARK: Actions
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func iconButtonTapped(_ sender: UIButton) {
        
        // Hide keyboard
        nameTextField.resignFirstResponder()
        
        // Select new icon
        if let newIcon = sender.currentImage {
            currentIconImage.image = newIcon
        }
        
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: UITextField) {
        
        // Enables Save button if name is not empty while typing
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // Apply new spendItem priperties
        let name = nameTextField.text ?? ""
        let icon = currentIconImage.image ?? #imageLiteral(resourceName: "finance")
        let convertedIcon = UIImagePNGRepresentation(icon) as NSData?
        
        // Set the spend item to be passed to SpendTableViewController after the unwind segue.
        spendItem = SpendItem()
        
        if let spendItem = spendItem {
            spendItem.name = name
            spendItem.icon = convertedIcon
            spendItem.orderPostion = realm.objects(SpendItem.self).count - 1
            print("spend item passed")
            
            try! realm.write {
                realm.add(spendItem)
            }
        }
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState () {
        
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    


}
