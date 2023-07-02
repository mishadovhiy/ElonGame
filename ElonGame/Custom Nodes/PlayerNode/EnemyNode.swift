//
//  EnemyNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 29.06.2023.
//

import SpriteKit
import GameplayKit

class EnemyNode:PlayerNode {
    
    let scoreLabel:SKLabelNode = .init()
    private var isMoving = false
    private var walkCount = 0
    private var walkDirRight:Bool = .random()

    var walkDirHolder:Bool = false
    
    override func sceneMoved() {
        super.sceneMoved()
        self.walkDirHolder = walkDirRight
        self.createRangeView()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            self.randomWalking()
            
            Timer.scheduledTimer(withTimeInterval: 3.5 - Double(self.difficulty.n), repeats: true, block: { timer in
                let can = !(self.specialAbility[.shootReceived] ?? false) && !self.died && DB.holder?.settings.game.enamieCanShoot ?? false
                if can {
                    self.spawnBullet()
                }
                if self.died {
                    timer.invalidate()
                }
            })
            
            
        })
        
    }
    
    func walk(completion:@escaping()->()) {
        isMoving = true
        walkCount += 1
        let playerPosition = GameViewController.shared?.scene?.player?.position ?? .zero
        let difference = playerPosition.x - self.position.x
        move(xPosition: difference >= 0 ? 1.5 : -1.5, deltaTime: 6, duration: 0.6)
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { _ in
            self.isMoving = false
            completion()
        })
    }
    func randomWalking() {
        self.walk {
            Timer.scheduledTimer(withTimeInterval: self.walkCount <= 100 ? 0 : 5, repeats: false, block: { _ in
                if !self.isPaused {
                    if !self.died {
                        self.randomWalking()
                    }
                    if self.walkCount > 100 {
                        self.walkDirRight = self.specialAbility[.shootReceived] ?? self.walkDirHolder
                        self.walkCount = 0
                    }
                    if self.self.specialAbility[.shootReceived] != self.walkDirRight {
                        self.walkDirRight = self.specialAbility[.shootReceived] ?? self.walkDirHolder
                        self.walkCount = 0
                    }
                }
                
                
            })
        }
    }
    
    func randomJump() {
        let statee = state.currentState as? PlayerState
        if let stateRes = statee as? JumpingState,
           stateRes.hasFinnished
        {
            state.enter(JumpingState.self)
            jump()
        }
        
    }
    
    
    
    
    func createRangeView() {
        scoreLabel.position = .init(x: 0, y: 0)
        scoreLabel.fontColor = .orange
        scoreLabel.fontSize = 16
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(self.lifes)"
        addChild(scoreLabel)
    }
    
    func scoreChanged(_ newValue:Int) {
        scoreLabel.text = "\(self.lifes)"
    }
    
}
