//
//  ViewController.swift
//  Calculator
//
//  Created by Pieter Kuijpers on 29-04-15.
//  Copyright (c) 2015 Pi-Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
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
        switch operation {
        case "×": performOperation { $1 * $0 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $1 + $0 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { $0 >= 0 ? sqrt($0) : $0 }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        operandStack.append(displayValue)
        userIsInTheMiddleOfTyping = false
        println("operandStack = \(operandStack)")
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

