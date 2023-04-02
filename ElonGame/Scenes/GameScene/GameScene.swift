//
//  GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player:SKNode?
    var joystic:SKNode?
    var joysticKnob:SKNode?
    
    var joysticAction:Bool = false
    
    var knobRadius:CGFloat = 50 
    
    var previusTimeInterval:TimeInterval = 0
    var playerIsFacingRight = true
    let playerSpeed:Double = 4
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.declareUI()
        print(self.view?.frame.width, " rgtefrdwfvrgt")

    }
    
    func declareUI() {
        player = childNode(withName: "player")
        joystic = childNode(withName: "joystic")
        joysticKnob = joystic?.childNode(withName: "controllIndicator")
    }
    
    

}


extension GameScene {
    func resetKnobPosition() {
        print("resetKnobPosition")
        let initPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joysticKnob?.run(moveBack)
        joysticAction = false
    }
}


extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime:Double = currentTime - previusTimeInterval
        previusTimeInterval = deltaTime
        print(deltaTime, " hntgrfedxcfvg")
        guard let knob = joysticKnob else { return }
        
        let xPosition = Double(knob.position.x)
        let dx = deltaTime * xPosition * playerSpeed
        let displeisment = CGVector(dx: dx, dy: 0)
        if displeisment.dx != 0 {
            print(displeisment.dx, "grfedws")
        }
        let move = SKAction.move(by: displeisment, duration: 0)
        //player?.run(move)
        
        
        let faceAction:SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            
            let faceMovement = SKAction.scaleX(to: -1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else if movingRight && !playerIsFacingRight {
             playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
    }
}
