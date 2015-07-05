//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Pieter Kuijpers on 16-05-15.
//  Copyright (c) 2015 Pi-Q. All rights reserved.
//

import Foundation

public class CalculatorBrain
{
    public enum Symbol: String {
        case Plus = "+"
        case Minus = "−"
        case Multiply = "×"
        case Divide = "÷"
        case SquareRoot = "√"
        case Sin = "sin"
        case Cos = "cos"
    }
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(Symbol, Double -> Double)
        case BinaryOperation(Symbol, (Double, Double) -> Double)
        
        var description: String {
            switch self {
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol.rawValue
            case .BinaryOperation(let symbol, _):
                return symbol.rawValue
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [Symbol:Op]()
    
    public init() {
        knownOps[Symbol.Multiply] = Op.BinaryOperation(Symbol.Multiply, *)
        knownOps[Symbol.Plus] = Op.BinaryOperation(Symbol.Plus, +)
        knownOps[Symbol.Divide] = Op.BinaryOperation(Symbol.Divide, { $1 / $0 })
        knownOps[Symbol.Minus] = Op.BinaryOperation(Symbol.Minus, { $1 - $0 })
        knownOps[Symbol.SquareRoot] = Op.UnaryOperation(Symbol.SquareRoot, sqrt)
        knownOps[Symbol.Sin] = Op.UnaryOperation(Symbol.Sin, sin)
        knownOps[Symbol.Cos] = Op.UnaryOperation(Symbol.Cos, cos)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation( _, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1evaluation = evaluate(remainingOps)
                if let operand1 = op1evaluation.result {
                    let op2evaluation = evaluate(op1evaluation.remainingOps)
                    if let operand2 = op2evaluation.result {
                       return (operation(operand1, operand2), op2evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    public func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    public func performOperation(symbol: Symbol) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}