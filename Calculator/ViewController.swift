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
    @IBOutlet public weak var history: UILabel!
    
    @IBOutlet public weak var piButton: UIButton!
    @IBOutlet public weak var sinButton: UIButton!
    @IBOutlet public weak var cosButton: UIButton!
    
    var userIsInTheMiddleOfTyping = false
    public var brain = CalculatorBrain()
    
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
    
    @IBAction public func appendPi() {
        if userIsInTheMiddleOfTyping {
            enter()
        }
        displayValue = M_PI
        brain.pushOperand(M_PI)
        appendToHistory("π")
    }
    
    @IBAction public func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if let symbol = CalculatorBrain.Symbol(rawValue: operation) {
                if userIsInTheMiddleOfTyping {
                    enter()
                }
                
                let result = brain.performOperation(symbol)
                displayValue = result
                if (result != nil) {
                    appendToHistory(operation)
                }
            } else {
                println("Unknown operation \(operation)")
            }
            
        }
    }
    
    @IBAction public func enter() {
        if userIsInTheMiddleOfTyping {
            appendToHistory(display.text!)
        }
        userIsInTheMiddleOfTyping = false
        if let value = displayValue {
            displayValue = brain.pushOperand(value)
        }
    }
    
    private func appendToHistory(item: String) {
        println("History is: |\(history.text)|")
        if history.text == nil || history.text!.isEmpty {
            history.text = item
        } else {
            history.text! += " \(item)"
        }
    }
    
    public var displayValue: Double? {
        get {
            let formatter = NSNumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            return formatter.numberFromString(display.text!)?.doubleValue
        }
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = ""
            }
        }
    }
}

