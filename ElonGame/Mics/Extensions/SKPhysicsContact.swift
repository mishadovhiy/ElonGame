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
        if self.bodyA.node?.name?.contains(name) ?? false {
            return self.bodyA.node
        } else if self.bodyB.node?.name?.contains(name) ?? false {
            return self.bodyB.node
        } else {
            return nil
        }
    }
}


extension SKNode {
    var intName:Int {
        for i in 0..<10 {
            if self.name?.contains("\(i)") ?? false {
                return i
            }
        }
        return 0
    }
}
