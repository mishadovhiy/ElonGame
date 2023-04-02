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


