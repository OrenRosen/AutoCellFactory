//: Playground - noun: a place where people can play

import UIKit


let arr = ["orem", "sdsad", "asds"]

let enums = arr.enumerate().filter { (index, str) -> Bool in
    return index == 1
}
