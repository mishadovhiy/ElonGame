//
//  SKPhysicsContactDelegate_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 14.04.2023.
//

import SpriteKit
import GameplayKit

extension GameScene:SKPhysicsContactDelegate {
    
    struct Collisions {
        enum Mask:Int {
            case killing, player, reward, ground
            var bitmask:UInt32 { 1 << self.rawValue }
        }
        let masks:(first:UInt32, second:UInt32)
        func matches(_ first:Mask, _ second:Mask) -> Bool {
            return (first.bitmask == self.masks.first && second.bitmask == self.masks.second) || (first.bitmask == self.masks.second && second.bitmask == self.masks.first)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collisions = Collisions(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        if collisions.matches(.player, .killing) {
            let die = SKAction.move(to: .init(x: -300, y: -100), duration: 0)
            player?.run(die)
        }
    }
    
}
