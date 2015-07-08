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
            
            var brain: CalculatorBrain!
            
            beforeEach {
                brain = CalculatorBrain()
            }
            
            it("can be created") {
                expect(brain).notTo(beNil())
            }
            
            describe("pushOperand with a variable") {
                it("accepts variable operands") {
                    expect(brain.pushOperand("x")).to(beNil())
                }
                
                context("with variableValues set") {
                    beforeEach {
                        brain.variableValues["x"] = 35.0
                        brain.variableValues["y"] = 17.0
                    }
                    it("returns the variable value") {
                        expect(brain.pushOperand("x")).to(equal(35.0))
                    }
                    it("performs calculations using variable values") {
                        brain.pushOperand("x")
                        let result = brain.performOperation(CalculatorBrain.Symbol.SquareRoot)
                        expect(result).to(beCloseTo(sqrt(35.0)))
                    }
                    it("performs calculations using multiple variable values") {
                        brain.pushOperand("x")
                        brain.pushOperand("y")
                        let result = brain.performOperation(CalculatorBrain.Symbol.Minus)
                        expect(result).to(equal(18.0))
                    }
                }
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
                it("calculates the cos") {
                    brain.pushOperand(1.0)
                    expect(brain.performOperation(CalculatorBrain.Symbol.Cos)).to(equal(cos(1.0)))
                }
            }
        }
    }
}