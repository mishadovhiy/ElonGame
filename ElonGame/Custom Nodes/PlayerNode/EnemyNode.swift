//
//  EnemyNode.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 29.06.2023.
//

import SpriteKit
import GameplayKit

class EnemyNode:PlayerNode {
    
    private var isMoving = false
    private var walkCount = 0
    private var walkDirRight:Bool = .random()

    var walkDirHolder:Bool = false
    
    func walk(completion:@escaping()->()) {
        isMoving = true
        walkCount += 1
        move(xPosition: self.walkDirRight ? 1.5 : -1.5, deltaTime: 6, duration: 0.6)
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { _ in
            self.isMoving = false
            completion()
        })
    }
    func randomWalking() {
        self.walk {
            Timer.scheduledTimer(withTimeInterval: self.walkCount <= 100 ? 0 : 5, repeats: false, block: { _ in
                if !self.died {
                    self.randomWalking()
                }
                if self.walkCount > 100 {
                    self.walkDirRight = self.shootingFromRight ?? self.walkDirHolder
                    self.walkCount = 0
                }
                if self.shootingFromRight != self.walkDirRight {
                    self.walkDirRight = self.shootingFromRight ?? self.walkDirHolder
                    self.walkCount = 0
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
    
    override func sceneMoved() {
        super.sceneMoved()
        self.walkDirHolder = walkDirRight
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            self.randomWalking()

        })

    }
    
}