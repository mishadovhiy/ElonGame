//
//  Collisions.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 30.04.2023.
//

import Foundation

struct PhysicCategory {
    enum Mask:UInt32 {
        case killing, player, reward, ground, bullet, all
        var bitmask:UInt32 { 1 << self.rawVal }
        var rawVal: UInt32 {
            switch self {
            case .all: return .max
            default: return self.rawValue
            }
        }
    }
    let masks:(first:UInt32, second:UInt32)
    func matches(_ first:Mask, _ second:Mask) -> Bool {
        return (first.bitmask == self.masks.first && second.bitmask == self.masks.second) || (first.bitmask == self.masks.second && second.bitmask == self.masks.first)
    }
    
}
