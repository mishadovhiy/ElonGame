//
//  BulletNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 29.06.2023.
//

import SpriteKit
import GameplayKit

class BulletNode:SKSpriteNode {
    var player:PlayerNode?
    var touchedEnemy = false
    
    func remove() {
        player?.canSpawnBullets = true
        self.removeFromParent()
    }
}
