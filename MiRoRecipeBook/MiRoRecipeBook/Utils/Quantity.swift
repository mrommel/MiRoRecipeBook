//
//  Quantity.swift
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 21.12.16.
//  Copyright © 2016 MiRo Soft. All rights reserved.
//

import Foundation

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


enum QuantityType: String {
    case none = ""
    case kilogramms = "K"
    case gramms = "G"
    case liters = "L"
    case milliliters = "M"
    case smallspoons = "T"
    case spoons = "E"
    case pieces = "S"
    case cups = "B"
    case pinch = "P"
    case packet = "C"
    case bottle = "F"
    case slice = "N"
    case can = "D"
    case glas = "X"
    case some = "W"
}

extension QuantityType {
    
    init(fromRawValue rawValue: String) {
        switch rawValue {
        case "K": self = .kilogramms
        case "G": self = .gramms
        case "L": self = .liters
        case "M": self = .milliliters
        case "T": self = .smallspoons
        case "E": self = .spoons
        case "S": self = .pieces
        case "B": self = .cups
        case "P": self = .pinch
        case "C": self = .packet
        case "F": self = .bottle
        case "N": self = .slice
        case "D": self = .can
        case "X": self = .glas
        case "W": self = .some
        default: self = .none
        }
    }
    
    static func build(rawValue:String) -> QuantityType {
        return QuantityType(rawValue: rawValue) ?? .none
    }
}

class Quantity: NSObject {
    
    let quantity: Float
    let type: QuantityType
    
    // static
    let oneFractionDigitFloatFormat = ".1"
    let noFractionDigitFloatFormat = ".0"
    
    init(withQuantity quantity: Float, andType type: QuantityType) {
        self.quantity = quantity
        self.type = type
    }
    
    convenience init(withQuantity quantity: Float, andType type: String) {
        self.init(withQuantity: quantity, andType: QuantityType.build(rawValue: type))
    }
    
    func format(withScale scale: Float) -> String {
        let value = self.quantity * scale
        switch self.type {
        case .kilogramms:
            return "\(value.format(f: oneFractionDigitFloatFormat)) Kg"
        case .gramms:
            return "\(value.format(f: noFractionDigitFloatFormat)) g"
        case .liters:
            return "\(value.format(f: oneFractionDigitFloatFormat)) l"
        case .milliliters:
            return "\(value.format(f: noFractionDigitFloatFormat)) ml"
        case .smallspoons:
            return "\(value.format(f: oneFractionDigitFloatFormat)) TL"
        case .spoons:
            return "\(value.format(f: oneFractionDigitFloatFormat)) EL"
        case .pieces:
            return "\(value.format(f: noFractionDigitFloatFormat))"
        case .cups:
            return "\(value.format(f: noFractionDigitFloatFormat)) Becher"
        case .pinch:
            if value == 1.0 {
                return "1 Prise"
            } else {
                return "\(value.format(f: noFractionDigitFloatFormat)) Prisen"
            }
        case .packet:
            if value == 0.5 {
                return "½ Päckchen"
            } else {
                return "\(value.format(f: noFractionDigitFloatFormat)) Päckchen"
            }
        case .bottle:
            if value == 0.5 {
                return "½ Flasche"
            } else if value == 1.0 {
                return "1 Flasche"
            } else {
                return "\(value.format(f: oneFractionDigitFloatFormat)) Flaschen"
            }
        case .slice:
            if value == 1.0 {
                return "1 Scheibe"
            } else {
                return "\(value.format(f: noFractionDigitFloatFormat)) Scheiben"
            }
        case .can:
            if value == 1.0 {
                return "1 Dose"
            } else {
                return "\(value.format(f: noFractionDigitFloatFormat)) Dosen"
            }
        case .glas:
            if value == 1.0 {
                return "1 Glas"
            } else {
                return "\(value.format(f: noFractionDigitFloatFormat)) Gläser"
            }
        case .some:
            return " "
        default:
            return "???"
        }
    }
}
