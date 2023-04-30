//
//  PlayerNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 27.04.2023.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    private let regularSpeed: CGFloat = 5
    var isFacingRight = true
    var walkingSpeed:CGFloat {
        isSuperSpeed ? 15 : regularSpeed
    }
    var isSuperSpeed:Bool = false
    
    private var timer:Timer?
    
    func startSuperSpeed() -> Bool {
        if timer == nil {
            isSuperSpeed = true
            timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false, block: { t in
                self.timer?.invalidate()
                self.timer = nil
                self.isSuperSpeed = false
            })
            return true
        } else {
            return false
        }
        
    }
    
    
    func spawnBullet(){
        let Bullet = SKSpriteNode(imageNamed: "fireBlue")
        if !isFacingRight {
            Bullet.zRotation = CGFloat(M_PI_2)*2
        }
        
        Bullet.color = .red
        Bullet.size = .init(width: 20, height: 15)
        Bullet.position = CGPoint(x: self.position.x + (30 * (isFacingRight ? 1 : -1)), y: self.position.y)
        
        let toX = ((GameViewController.shared?.view.frame.width ?? 15) * (isFacingRight ? 1 : -1)) + self.position.x
        let action = SKAction.moveTo(x: toX, duration: 3)
        let actionDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicCategory.Mask.bullet.bitmask
        Bullet.physicsBody?.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = true
        GameViewController.shared?.scene?.addChild(Bullet)
    }
}
