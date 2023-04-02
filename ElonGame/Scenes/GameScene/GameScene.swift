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
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.declareUI()
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
        let moveBack = SKAction.move(to: initPoint, duration: 0.3)
        moveBack.timingMode = .linear
        joysticKnob?.run(moveBack)
        joysticAction = false
    }
}
