//
//  CalculatorBrainSpec.swift
//  Calculator
//
//  Created by Pieter Kuijpers on 17-05-15.
//  Copyright (c) 2015 Pi-Q. All rights reserved.
//

import Quick
import Nimble
import Calculator

class CalculatorBrainSpec: QuickSpec {
    override func spec() {
        describe("CalculatorBrain") {
            
            let brain = CalculatorBrain()
            
            it("can be created") {
                expect(brain).notTo(beNil())
            }
            
            context("with an empty stack") {
                it("returns nil for sin") {
                    expect(brain.performOperation(CalculatorBrain.Symbol.Sin)).to(beNil())
                }
            }
            
            context("with an single number on the stack") {
                it("calculates the sin") {
                    brain.pushOperand(1.0)
                    expect(brain.performOperation(CalculatorBrain.Symbol.Sin)).to(equal(sin(1.0)))
                }
            }
        }
    }
}