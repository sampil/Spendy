//
//  HistoryTableViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 15.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {

    //MARK: Properties
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load samples
        // loadSampleExpenses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Expense.self).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellID = "HistoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? HistoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HistoryTableViewCell.")
        }
        
        // Fetches the appropriate expense for the data source layout.
        // Realm way
        
        // Load expenses array from data base
        let expenses = realm.objects(Expense.self)
        
        // Stay in scope of array length
        if indexPath.row < expenses.count {
            
            // Select expense to appropriate row index
            let expense = expenses[indexPath.row]
            // Gather Spend Item of current expense
            let spendItem = expense.spendItem
            
            // Take data to fill cell, gacefully deal with optionals
            if let icon = spendItem?.icon {
                cell.spendItemImage.image = UIImage(data: icon as Data, scale:1.0)
            }
            
            if let name = spendItem?.name {
                cell.spendItemNameLabel.text = name
            }
            
            cell.expenseValueLabel.text = formatDoubleValueToCashString(value: expense.value)
            
            if let date = expense.date {
                cell.expenseDateLabel.text = formatDateToString(date: date)
            }
        }

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let expensesToRemove = realm.objects(Expense.self)[indexPath.row]
            try! realm.write {
                realm.delete(expensesToRemove)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private Methods
    
    private func formatDateToString (date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    private func formatDoubleValueToCashString (value: Double) -> String {
        let string = "$ " + String(value)
        return string
    }
    
    private func loadSampleExpenses () {
        let sampleExpenseItem = realm.objects(SpendItem.self)[1]
        let sampleExpense1 = Expense(value: ["spendItem" : sampleExpenseItem, "value" : 22.33, "date" : Date()])
        
        try! realm.write {
            realm.add(sampleExpense1)
        }
    }

}
