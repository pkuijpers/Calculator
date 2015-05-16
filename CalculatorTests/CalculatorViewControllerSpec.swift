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
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            cvc = storyboard.instantiateViewControllerWithIdentifier("CalculatorViewControllerId") as! ViewController
            let _ = cvc.view
        }
        
        describe("A CalculatorViewController") {
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
    }
}