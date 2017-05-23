//
//  ReportTableViewController.swift
//  Spendy
//
//  Created by Семен Пилюков on 21.05.17.
//  Copyright © 2017 Семен Пилюков. All rights reserved.
//

import UIKit
import RealmSwift

class ReportTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var thisMonthTotalValueLabel: UINavigationItem!
    let realm = try! Realm()
    var spendItemsAndValues = [SpendItemAndValue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Fill dictionary of spend items and values for current month
        let startOfCurrentMonth = getStartOfCurrentMonth()
        getSpendItemsAndValues(fromDate: startOfCurrentMonth, toDate: Date())
        
        // Cumpute total sum of expense values
        var totalExpenseSum: Double {
            var sum = 0.0
            for spendItemAndValue in spendItemsAndValues {
                sum += spendItemAndValue.expensesValue
            }
            return sum
        }
        
        // Set title label with month and total value sum
        let currentMonthName = getCurrentMonthName()
        thisMonthTotalValueLabel.title = "\(currentMonthName): $ \(totalExpenseSum)"
        
        // Reload the table
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendItemsAndValues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellID = "ReportTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ReportTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReportTableViewCell.")
        }
        
        let spendItemAndValue = spendItemsAndValues[indexPath.row]
        
        if let icon = spendItemAndValue.spendItem.icon {
            cell.spendItemImage.image = UIImage(data: icon as Data, scale:1.0)
        }
        
        if let name = spendItemAndValue.spendItem.name {
            cell.spendItemNameLabel.text = name
        }
        
        let value = spendItemAndValue.expensesValue

        cell.totalValueLabel.text = formatDoubleValueToCashString(value: value)
        
        return cell
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
    
    private func formatDoubleValueToCashString (value: Double) -> String {
        let string = "$ " + String(value)
        return string
    }
    
    
    // Returns Date of 12:00 am of current month
    // While printing gives TimeZone deviation.
    // Do not have TimeZone deviation when used "as is"
    private func getStartOfCurrentMonth() -> Date {
        
        // Get current date.
        let userCalendar = Calendar.current
        let currentDate = Date()
        
        // Split up current date to components.
        let currentDateComponents = userCalendar.dateComponents([.year, .month, .timeZone], from: currentDate)
        
        // Construct new date components for start of month.
        let startOfCurrentMonthComponents = DateComponents(
            timeZone: currentDateComponents.timeZone,
            year: currentDateComponents.year,
            month: currentDateComponents.month,
            day: 1,
            hour: 0,
            minute: 0,
            second: 0)
        
        // Create new date from components.
        guard let startOfCurrentMonth = userCalendar.date(from: startOfCurrentMonthComponents) else {
            fatalError("Unable to set current micnth")
        }
        
        return startOfCurrentMonth
    }
    
    //Returns string of current month's name.
    private func getCurrentMonthName() -> String {
        
        let userCalendar = Calendar.current
        let month = userCalendar.component(.month, from: Date())
        let dateFormatter = DateFormatter()
        guard let months = dateFormatter.monthSymbols else {
            fatalError("Unable to get month list")
        }
        let string = months[month-1]
        
        return string
    }
    
    //Returns dictionary of total non-zero expense values for each SpendItem for date range
    private func getSpendItemsAndValues(fromDate: Date, toDate: Date) {
        // Create value containers
        var sumOfExpenseValues = 0.0
        
        // Reset storing array
        spendItemsAndValues = []
        
        // Query DB for spend items
        let spendItems = realm.objects(SpendItem.self).sorted(byKeyPath: "orderPostion")
        print("\(spendItems.count) spend Items found")
        
        // Fill 'spendItemsAndValues' array
        for spendItem in spendItems {
            // Get all expenses for current spend item in date range
            let expenses = realm.objects(Expense.self).filter("date BETWEEN {%@, %@} AND spendItem = %@", fromDate, toDate, spendItem)
            print("\(expenses.count) expenses for \(spendItem.name) found")
            
            // If no expenses found, continue to next expense item
            if expenses.isEmpty {
                print("No expenses found")
                continue
            }
            
            // Sum all values of founded expenses
            for expense in expenses {
                sumOfExpenseValues += expense.value
                print("\(expense.value) added to sum \(sumOfExpenseValues)")
            }

            // Add new element to array
            let spendItemsAndValue = SpendItemAndValue.init(spendItem: spendItem, expensesValue: sumOfExpenseValues)
            spendItemsAndValues.append(spendItemsAndValue)
            print("\(spendItemsAndValues.count) elements total")
            
            //Reset sum of expense to prepare for next spend item
            sumOfExpenseValues = 0.0
        }
    }
    
}
