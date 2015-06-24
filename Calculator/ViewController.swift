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
    @IBOutlet public weak var sinButton: UIButton!
    
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
    
    @IBAction func appendPi() {
        if userIsInTheMiddleOfTyping {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    @IBAction public func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if let symbol = CalculatorBrain.Symbol(rawValue: operation) {
                if userIsInTheMiddleOfTyping {
                    enter()
                }
                
                if let result = brain.performOperation(symbol) {
                    displayValue = result
                    appendToHistory(operation)
                } else {
                    displayValue = 0
                }
            } else {
                println("Unknown operation \(operation)")
            }
            
        }
    }
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTyping {
            appendToHistory(display.text!)
        }
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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

