//
//  PlayerNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 27.04.2023.
//

import SpriteKit
import GameplayKit
protocol PlayerNodeProtocol {
    func died()
}
class PlayerNode: SKSpriteNode {
    var lifes = 5
    private let regularSpeed: CGFloat = 5
    var isFacingRight = true
    var walkingSpeed:CGFloat {
        isSuperSpeed ? 10 : regularSpeed
    }
    var isSuperSpeed:Bool = false
    private var timer:Timer?
    var canSpawnBullets = true
    var state:GKStateMachine!

    var delegate:PlayerNodeProtocol?
    
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
        if !canSpawnBullets { return }
        canSpawnBullets = false
        let Bullet = BulletNode(imageNamed: "fireBlue")
        if !isFacingRight {
            Bullet.zRotation = CGFloat(M_PI_2)*2
        }
        Bullet.player = self
        Bullet.name = "bullet"
        Bullet.color = .red
        Bullet.size = .init(width: 20, height: 15)
        Bullet.position = CGPoint(x: self.position.x + (30 * (isFacingRight ? 1 : -1)), y: self.position.y)
        
        let toX = 20 * (isFacingRight ? 1 : -1)
        //let action = SKAction.moveTo(x: toX, duration: 3)
        let action = SKAction.applyImpulse(.init(dx: toX, dy: 0), at: .init(x: 3, y: 0), duration: 1)
        
        // SKAction.applyForce(.init(dx: 5 * (isFacingRight ? 1 : -1), dy: 0), duration: 10)
        let actionDone = SKAction.run {
            Bullet.remove()
        }
        Bullet.run(SKAction.sequence([action, actionDone]))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.allowsRotation = false
        Bullet.physicsBody?.categoryBitMask = PhysicCategory.Mask.bullet.bitmask
        Bullet.physicsBody?.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = true
        GameViewController.shared?.scene?.addChild(Bullet)
    }
    
    
    func bulletTouched() {
        lifes -= 1
        if lifes <= 0 {
            die()
        }
    }
    
    func die() {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        
        self.run(dieAction)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            self.delegate?.died()
            self.removeFromParent()
        })
        
    }
    
    var isMeteorHitted = false
    func meteorHit() {
        state.enter(StunnedState.self)
        isMeteorHitted = true
        lifes -= 1
        if lifes != 0 {
            invincible()
        } else  {
            die()
        }
        
    }
    
    
    func invincible() {
        self.physicsBody?.categoryBitMask = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.isMeteorHitted = false
            self.physicsBody?.categoryBitMask = 2
        }
    }
    
    
    func jump(isSecond:Bool = false) {
        self.run(.applyForce(CGVector(dx: 0, dy: !isSecond ? 350 : 400), duration: 0.1))
        self.run(Sound.jump.action)
    }
    
    func move(xPosition:CGFloat, deltaTime: TimeInterval) {
        if floor(xPosition.positive) != 0 {
            state.enter(WalkingState.self)
        } else {
            state.enter(IdleState.self)
        }
        
        let move = SKAction.move(by: .init(dx: deltaTime * xPosition * walkingSpeed, dy: 0), duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && isFacingRight {
            isFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        }
        else if movingRight && !isFacingRight {
            isFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        self.run(faceAction)
    }


    func sceneMoved() {
        state = GKStateMachine(states: [
            JumpingState(playerNode: self),
            WalkingState(playerNode: self),
            IdleState(playerNode: self),
            LandingState(playerNode: self),
            StunnedState(playerNode: self)
        ])
        state.enter(IdleState.self)
    }

}


class EnemyNode:PlayerNode {
    
}



class BulletNode:SKSpriteNode {
    var player:PlayerNode? 
    var touchedEnemy = false
    
    func remove() {
        player?.canSpawnBullets = true
        self.removeFromParent()
    }
}
