//
//  SpendTableViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 23.04.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class SpendTableViewController: UITableViewController {

    //MARK: Properties
    let realm = try! Realm()
    
    // Array for storing spend items according to their order position
    // Also used to update order position after rearranging
    var spendItemArray = [SpendItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // CLEAR DATABASE!!!!!!!!!!!!!!!
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        // Load the sample data.
        if realm.objects(SpendItem.self).count < 1 {
            loadSampleSpendItems()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refillSpendItemArray()
        print("ppend item array refilled on apper")
        // Reload the table
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(SpendItem.self).count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpendTableViewCell", for: indexPath) as? SpendTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SpendTableViewCell.")
        }
        
        // Fetches the appropriate spendItem for the data source layout.
        
        let spendItemAtRow = spendItemArray[indexPath.row]
        
        cell.spendItemNameLabel.text = spendItemAtRow.name
        
        // Convert 'icon' from 'NSData?' to 'UIImage'
        if let icon = spendItemAtRow.icon {
            cell.spendItemIcon.image = UIImage(data: icon as Data, scale:1.0)
        }
        
        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let spendItemToDelete = spendItemArray[indexPath.row]
            
            // Delete all expenses for deleting spend Item
            let expensesToDelete = realm.objects(Expense.self).filter("spendItem = %@", spendItemToDelete)
            
            for expense in expensesToDelete {
                try! realm.write {
                    realm.delete(expense)
                }
            }
                
            // Delete spend item from the data source
            try! realm.write {
                realm.delete(spendItemToDelete)
            }
            
            // Delete spend item from array
            spendItemArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateOrderInDB()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        // Rearrange spend items in array.
        let element = spendItemArray.remove(at: fromIndexPath.row)
        spendItemArray.insert(element, at: to.row)
        
        updateOrderInDB()
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddSpendItem":
            os_log("Adding a new spend item", log: OSLog.default, type: .debug)
            
        case "NewExpense":
            guard let destinationNavigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let newExpenseViewController = destinationNavigationController.topViewController as? NewExpenseViewController else {
                fatalError("Unexpected anvigation controller: \(destinationNavigationController.topViewController)")
            }

            guard let selectedMealCell = sender as? SpendTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSpendItem = spendItemArray[indexPath.row]
            // TODO deal with optional
            newExpenseViewController.spendItem = selectedSpendItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToSpendItemList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? NewSpendItemViewController, let spendItem = sourceViewController.spendItem {
            
            // Add a new spend item
            try! realm.write {
                realm.add(spendItem)
            }
        }
    }
    
    //MARK: Private Methods
    
    private func refillSpendItemArray() {
        // Reset the storing array
        spendItemArray = []
        
        // Get spend items from DB in right order
        let spendItems = realm.objects(SpendItem.self).sorted(byKeyPath: "orderPostion")
        
        // Fill array
        for index in 0..<spendItems.count {
            spendItemArray.append(spendItems[index])
        }
    }
    
    // Update orderPostion's according to new array indexes.
    private func updateOrderInDB() {
        for (index, spendItem) in spendItemArray.enumerated() {
            try! realm.write {
                spendItem.orderPostion = index
            }
        }
    }

 
    private func loadSampleSpendItems() {
        
        let sample1 = SpendItem()
        sample1.icon = UIImagePNGRepresentation(#imageLiteral(resourceName: "groceries")) as NSData?
        sample1.name = "Groceries"
        sample1.orderPostion = 0

        
        let sample2 = SpendItem()
        sample2.icon = UIImagePNGRepresentation(#imageLiteral(resourceName: "housing")) as NSData?
        sample2.name = "Housing"
        sample1.orderPostion = 1

        
        let sample3 = SpendItem()
        sample3.icon = UIImagePNGRepresentation(#imageLiteral(resourceName: "transport")) as NSData?
        sample3.name = "Transport"
        sample1.orderPostion = 2

        
        let sample4 = SpendItem()
        sample4.icon = UIImagePNGRepresentation(#imageLiteral(resourceName: "gifts")) as NSData?
        sample4.name = "Gifts"
        sample1.orderPostion = 3

        
        try! realm.write {
            realm.add(sample1)
            realm.add(sample2)
            realm.add(sample3)
            realm.add(sample4)
        }
        
        
    }
}
