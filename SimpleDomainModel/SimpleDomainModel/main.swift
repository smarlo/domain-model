//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    let rates:[String : Double] = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    let newAmount = self.amount * (Int(rates[to]! / rates[self.currency]!))
    return Money(amount: newAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if self.currency != to.currency {
        let newCurrency = self.convert(to.currency)
        return Money(amount: newCurrency.amount + to.amount, currency: to.currency)
    } else {
        return Money(amount: self.amount + to.amount, currency: self.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if self.currency != from.currency {
      let newCurrency = self.convert(from.currency)
      return Money(amount: from.amount - newCurrency.amount, currency: from.currency)
    } else {
      return Money(amount: from.amount - self.amount, currency: self.currency)
    }
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let rate):
        return Int(rate * Double(hours))
    case .Salary(let rate):
        return rate
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let rate):
        self.type = JobType.Hourly(rate + amt)
    case .Salary(let rate):
        self.type = JobType.Salary(rate + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
        if self.age >= 16 {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job?.title ?? nil)) spouse:\(String(describing: self._spouse?.firstName ?? nil))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.age >= 18 && spouse2.age >= 18) {
        if spouse1._spouse == nil && spouse2._spouse == nil {
            spouse1._spouse = spouse2
            spouse2._spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var childAdded = false
    for member in members {
        if member.age >= 21 {
            members.append(Person(firstName: child.firstName, lastName: child.lastName, age: 0))
            childAdded = true
        }
    }
    return childAdded
  }
  
  open func householdIncome() -> Int {
    var income:Int = 0
    for person in members {
        if person.job != nil {
            income += person._job!.calculateIncome(2000)
        }
    }
    return income
  }
}





