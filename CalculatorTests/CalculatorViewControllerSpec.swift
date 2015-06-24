//
//  CalculatorViewControllerSpec.swift
//  Calculator
//
//  Created by Pieter Kuijpers on 14-05-15.
//  Copyright (c) 2015 Pi-Q. All rights reserved.
//

import Quick
import Nimble
import Calculator

class CalculatorViewControllerSpec: QuickSpec {
    override func spec() {
        var cvc: ViewController!
        let mockBrain = MockCalculatorBrain()
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            cvc = storyboard.instantiateViewControllerWithIdentifier("CalculatorViewControllerId") as! ViewController
            cvc.brain = mockBrain
            let _ = cvc.view
        }
        
        describe("CalculatorViewController") {
            it("can be created") {
                expect(cvc).notTo(beNil())
            }
        }
        
        describe("display") {
            it("is wired") {
                expect(cvc.display).notTo(beNil())
            }
        }
        
        describe("Pi button") {
            it("is wired") {
                expect(cvc.piButton).notTo(beNil())
            }
        }
        
        describe("sin button") {
            it("is wired") {
                expect(cvc.sinButton).notTo(beNil())
            }
            it("is connected to operate: action") {
                if let actions = cvc.sinButton.actionsForTarget(cvc, forControlEvent: UIControlEvents.TouchUpInside) {
                   expect(actions).to(contain("operate:"))
                }
            }
            it("executes the sin operation") {
                cvc.operate(cvc.sinButton)
                
                expect(mockBrain.lastSymbol).to(equal(CalculatorBrain.Symbol.Sin))
                expect(cvc.display.text).to(equal("99.0"))
            }
        }
        
        describe("displayValue") {
            it("contains the displayed value") {
                cvc.display.text = "123"
                
                expect(cvc.displayValue).to(equal(123))
            }
            
            it("is nil when nothing is displayed") {
                cvc.display.text = "";
                
                expect(cvc.displayValue).to(beNil())
            }
            it("clears the display when set to nil") {
                cvc.display.text = "123"
                
                cvc.displayValue = nil
                
                expect(cvc.display.text).to(equal(""))
            }
        }
    }
    
    class MockCalculatorBrain: CalculatorBrain {
        var lastSymbol: Symbol?
        override func performOperation(symbol: CalculatorBrain.Symbol) -> Double? {
            lastSymbol = symbol
            return 99.0
        }
        
    }
}