//
//  Collisions.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 30.04.2023.
//

import Foundation

struct PhysicCategory {
    enum Mask:Int {
        case killing, player, reward, ground, bullet
        var bitmask:UInt32 { 1 << self.rawValue }
    }
    let masks:(first:UInt32, second:UInt32)
    func matches(_ first:Mask, _ second:Mask) -> Bool {
        return (first.bitmask == self.masks.first && second.bitmask == self.masks.second) || (first.bitmask == self.masks.second && second.bitmask == self.masks.first)
    }
    
}
