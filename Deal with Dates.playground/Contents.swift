//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// How to store images?

//enum ItemIcons: UIImage {
//    case icon = #imageLiteral(resourceName: "favicon.png")
//}

var itemIcons = ["grocery": #imageLiteral(resourceName: "favicon.png"), "rent": #imageLiteral(resourceName: "favicon.png")]




// Spend Item class
class SpendItem {
    
    // Properties
    var name: String
    var icon: UIImage
    
    init (name: String, icon: UIImage) {
        self.name = name
        self.icon = icon
    }
}

// Testing SpendItem

let grocery = SpendItem(name: "Grocery", icon: #imageLiteral(resourceName: "favicon.png"))
let rent = SpendItem(name: "Rent", icon: #imageLiteral(resourceName: "favicon.png"))
let gifts = SpendItem(name: "Gifts", icon: #imageLiteral(resourceName: "favicon.png"))

var spendItems = [SpendItem]()

spendItems.append(grocery)
spendItems.append(rent)
spendItems.append(gifts)

grocery.name
grocery.icon


// Expense class
class Expense {
    
    // Properties
    var spendItem: SpendItem
    var value: Double
    var dateTime: Date
    
    init (spendItem: SpendItem, value: Double, dateTime: Date) {
        self.spendItem = spendItem
        self.value = value
        self.dateTime = dateTime
    }
}


// new expenses

var expenses = [Expense]()

let expense1 = Expense(spendItem: grocery, value: 33.0, dateTime: (Date() - 24*60*60))
expenses.append(expense1)
let expense2 = Expense(spendItem: grocery, value: 45.0, dateTime: Date())
expenses.append(expense2)
let expense3 = Expense(spendItem: rent, value: 2.3, dateTime: (Date() - 30*24*60*60))
expenses.append(expense3)
let expense4 = Expense(spendItem: gifts, value: 22.55, dateTime: Date())
expenses.append(expense4)



// Report for current month

// Find start of month date

let userCalendar = Calendar.current
let currentDate = Date()
print(currentDate)


let currentDateComponents = userCalendar.dateComponents([.year, .month, .timeZone], from: currentDate)

let startOfCurrentMonthComponents = DateComponents(
    timeZone: currentDateComponents.timeZone,
    year: currentDateComponents.year,
    month: currentDateComponents.month,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0)

guard let startOfCurrentMonth = userCalendar.date(from: startOfCurrentMonthComponents) else {
    fatalError()
}

// check
startOfCurrentMonth

// get current month string
let month = userCalendar.component(.month, from: currentDate)
let dateFormatter = DateFormatter()
let months = dateFormatter.monthSymbols
let string = months![month-1]
print(string)


// Calculate sum of transactions and assemple all expenses in the array

var sum = 0.0
var currentMonthExpenses = [Expense]()

for expense in expenses {
    if expense.dateTime > startOfCurrentMonth {
        sum += expense.value
        currentMonthExpenses.append(expense)
    }
}

// sort by date
currentMonthExpenses.sort(by: { $0.dateTime > $1.dateTime })

// check
sum
currentMonthExpenses
let firstRowExpense = currentMonthExpenses[1]
firstRowExpense.value
firstRowExpense.spendItem.name
firstRowExpense.spendItem.icon
firstRowExpense.dateTime
currentMonthExpenses[0]
currentMonthExpenses[1]
currentMonthExpenses[2]
