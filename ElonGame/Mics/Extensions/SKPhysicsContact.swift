//
//  SKPhysicsContact.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 16.04.2023.
//

import SpriteKit
import GameplayKit

extension SKPhysicsContact {
    func matched(name:String) -> SKNode? {
        if self.bodyA.node?.name == "meteor" {
            return self.bodyA.node
        } else if self.bodyB.node?.name == "meteor" {
            return self.bodyB.node
        } else {
            return nil
        }
    }
}