//
//  Extensions_GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 24.04.2023.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
      /*  UIView.animate(withDuration: 0.1, animations: {
            self.joystickKnob?.layer.position = initialPoint
        })*/
        joystickAction = false
    }
    
    func increesScore() {
        self.score += 1
        print("scoreeee: ", score)
        self.scoreLabel.text = "\(score)"
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            self.checkNextScene()
        })
    }
    
    func fillHearts(count: Int) {
        for index in 1...count {
            let heart = SKSpriteNode(imageNamed: "heart")
            let xPosition = heart.size.width * CGFloat(index - 1)
            heart.position = CGPoint(x: xPosition, y: 0)
            heartsArray.append(heart)
            heartContainer.addChild(heart)
        }
    }
    
    func loseHeart() {
        if player?.isMeteorHitted ?? false {
            let lastElementIndex = heartsArray.count - 1
            if heartsArray.indices.contains(lastElementIndex - 1) {
                let lastHeart = heartsArray[lastElementIndex]
                lastHeart.removeFromParent()
                heartsArray.remove(at: lastElementIndex)
            } else {
                dying()
            }
        }
    }
    
    
    
    func dying() {
        GameViewController.shared?.scene = nil
        self.removeAllActions()
        self.showDieScene()
    }
    
    func removeJewel(_ node:JewelNode) {
        node.touched = true
        node.physicsBody?.categoryBitMask = 0
        node.removeFromParent()
        increesScore()
        run(Sound.reward.action)
    }
    
    
    
    func createEnemies() {
        
        if !(DB.holder?.settings.game.needEnemies ?? false) {
            return
        }
        let count = (5 * (currentScene + 1))
        let width = (childNode(withName: "flour")?.frame.width ?? 0) / CGFloat(count)
        
        for i in 0..<count {
            let enemy = EnemyNode(imageNamed: "player/0")
            let dific = enemy.difficulty
            
            enemy.size = .init(width: 36 + (dific.n * 10), height: 49 + (dific.n * 10))
            enemy.name = "enemy"
            
            enemy.position = .init(x: width * CGFloat(-1 * i), y: 200)
            enemy.zPosition = 10
            
            let phBody = SKPhysicsBody(circleOfRadius: 20)
            phBody.categoryBitMask = PhysicCategory.Mask.player.bitmask
            phBody.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
            phBody.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
            phBody.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
            phBody.affectedByGravity = true
            phBody.allowsRotation = false
            phBody.restitution = 0.2
            phBody.friction = 1.0
            
            enemy.physicsBody = phBody
            addChild(enemy)
        }
        enumerateChildNodes(withName: "enemy", using: {node,point in
            if let enemy = node as? EnemyNode {
                enemy.delegate = self
                enemy.sceneMoved()
                //     self.rewardCount += 1
            }
        })
    }
    
    
    
    func spawnMeteor() {
        let node = SKSpriteNode(imageNamed: "meteor")
        node.name = "meteor"
        let camPos = camera?.position
        let x = Int(camPos?.x ?? 0)
        let wi = Int(self.size.width)
        let isMinus = x <= 0
        let xr = isMinus ? x * -1 : x
        let randomXPosition = Int.random(in: xr..<(wi + xr))
        //Int(arc4random_uniform(UInt32(self.size.width)))
        node.position = .init(x: randomXPosition * (isMinus ? -1 : 1), y: 270)
        node.anchorPoint = .init(x: 0.5, y: 1)
        node.zPosition = 5
        
        let phBody = SKPhysicsBody(circleOfRadius: 30)
        phBody.categoryBitMask = PhysicCategory.Mask.killing.bitmask
        phBody.collisionBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        phBody.contactTestBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        phBody.fieldBitMask = PhysicCategory.Mask.player.bitmask | PhysicCategory.Mask.ground.bitmask
        phBody.affectedByGravity = true
        phBody.allowsRotation = false
        phBody.restitution = 0.2
        phBody.friction = 1.0
        phBody.density = 0.01//test
        
        node.physicsBody = phBody
        
        addChild(node)
    }
    
    func createMolten(at position:CGPoint) {
        let node = SKSpriteNode(imageNamed: "molten")
        node.position = .init(x: position.x, y: position.y - 60)
        node.zPosition = 4
        
        addChild(node)
        
        let action = SKAction.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: 3.0),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ])
        
        node.run(action)
    }
    
    func additionalUI() {
        enumerateChildNodes(withName: "jewel", using: {_,_ in
            self.rewardCount += 1
        })
        scoreLabel.position = .init(x: (self.cameraNode?.position.x ?? 0) + 310, y: 140)
        scoreLabel.fontColor = .orange
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "\(score)"
        addChild(scoreLabel)
        
        
        heartContainer.position = CGPoint(x: -300, y: 140)
        heartContainer.zPosition = 5
        cameraNode?.addChild(heartContainer)
        fillHearts(count: player?.lifes ?? 1)
        
        if DB.holder?.settings.game.backgroundSound ?? false {
            self.backgroundPlayer = .init(sound: .init(name: "music"), valume: 0.1)
        }
        self.backgroundPlayer?.playSound()
        self.backgroundPlayer?.numberOfLoops = -1
        
        if let state = player?.state.currentState as? PlayerState {
            state.delegate = self
        }
        
    }
    
    func setChilds() {
        player = childNode(withName: "player") as? PlayerNode
        player?.sceneMoved()
        print(player!.walkingSpeed)
        joystick = childNode(withName: "joystic")
        joystickKnob = joystick?.childNode(withName: "controllIndicator")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        
        mount1 = childNode(withName: "mount1")
        mount2 = childNode(withName: "mount2")
        mount3 = childNode(withName: "mount3")
        moon = childNode(withName: "moon")
        stars = childNode(withName: "stars")
        flour = childNode(withName: "flour")
    }
    
    func setupMeteor() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            if self.presenting {
                if (DB.holder?.settings.game.enubleMeteors ?? false) && !self.isPaused {
                    self.spawnMeteor()
                }
                
            } else {
                timer.invalidate()
            }
        })
        
    }
}

extension GameScene:PlayerNodeProtocol {
    func enemyDied() {
        //   increesScore()
    }
    
    
}

extension GameScene:PlayerStateProtocol {
    func endJumping() {
        self.jumpTouched = false
        if !touching {
            print("touching")
            if joystickAction {
                print("resetKnobPosition")
                resetKnobPosition()
            }
        }
    }
}
