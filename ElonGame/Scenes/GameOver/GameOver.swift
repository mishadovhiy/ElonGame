//
//  GameOver.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 24.04.2023.
//

import SpriteKit

class GameOverScene:SKScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            let scene = GameScene(fileNamed: "Level1")
            self.view?.presentScene(scene)
            self.removeAllActions()
            
        })
    }
}
