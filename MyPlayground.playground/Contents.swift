//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let n = 6

for index in 0..<n {
    for spases in 0..<(n - index - 1) {
        print(" ", terminator: "")
    }
    for dashes in 0...index {
        print("#", terminator: "")
    }
    print("")
}
