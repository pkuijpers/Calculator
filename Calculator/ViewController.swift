//
//  ViewController.swift
//  Calculator
//
//  Created by Pieter Kuijpers on 29-04-15.
//  Copyright (c) 2015 Pi-Q. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
    
    @IBOutlet public weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    @IBOutlet public weak var piButton: UIButton!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            display.text! += digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func appendDecimalPoint() {
        if display.text!.rangeOfString(".") == nil {
            display.text! += "."
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func appendPi() {
        if userIsInTheMiddleOfTyping {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            enter()
        }
        
        var performed = false
        switch operation {
        case "×": performed = performOperation { $1 * $0 }
        case "÷": performed = performOperation { $1 / $0 }
        case "+": performed = performOperation { $1 + $0 }
        case "−": performed = performOperation { $1 - $0 }
        case "√": performed = performOperation { $0 >= 0 ? sqrt($0) : $0 }
        case "sin": performed = performOperation { sin($0) }
        case "cos": performed = performOperation { cos($0) }
        default: break
        }
        
        if performed {
            appendToHistory(operation)
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) -> Bool {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
            return true
        } else {
            return false
        }
    }
    
    private func performOperation(operation: Double -> Double) -> Bool {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
            return true
        } else {
            return false
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        operandStack.append(displayValue)
        if userIsInTheMiddleOfTyping {
            appendToHistory(display.text!)
        }
        userIsInTheMiddleOfTyping = false
        println("operandStack = \(operandStack)")
    }
    
    private func appendToHistory(item: String) {
        println("History is: |\(history.text)|")
        if history.text == nil {
            history.text = item
        } else {
            history.text! += " \(item)"
        }
    }
    
    var displayValue: Double {
        get {
            let formatter = NSNumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            return formatter.numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
}

