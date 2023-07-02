//
//  GameOver.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 24.04.2023.
//

import SpriteKit

class GameOverScene:SuperScene {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
            GameViewController.shared?.loadScene(i:1)
        })
    }
}
