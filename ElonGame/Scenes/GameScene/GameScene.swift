//
//  GameScene.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 02.04.2023.
//

import SpriteKit
import GameplayKit
import CoreMotion
import UIKit

class GameScene: SuperScene {
    
    var player : PlayerNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    /*
     var joystick : UIView? {
         return GameViewController.shared?.joysticView
     }
     var joystickKnob : UIView? {
         return GameViewController.shared?.knobView
     }
     */
    var cameraNode:SKCameraNode?
    var mount3:SKNode?
    var mount1:SKNode?
    var mount2:SKNode?
    var stars:SKNode?
    var moon:SKNode?
    var flour:SKNode?
    
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    let scoreLabel:SKLabelNode = .init()
    
    var score:Int = 0
    
    var joystickAction = false
    var knobRadius : CGFloat = 50.0
    var previousTimeInterval : TimeInterval = 0
    var touching = false
    
    var rewardCount:Int = 0
    var currentScene:Int = 0
    var backgroundPlayer:AudioPlayer?
    var presenting:Bool = false
    var jumpTouched = false

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        presenting = true
        physicsWorld.contactDelegate = self
        setChilds()
        createEnemies()
        setupMeteor()
        additionalUI()

        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false, block: { _ in
            self.player?.removeShapeFromTexture(shapeRect: .init(x: 15, y: 25, width: 10, height: 10))
        })
        let end = childNode(withName: "endZone") as! SKSpriteNode
        end.removeShapeFromTexture(shapeRect: .init(x: 10, y: 100, width: 100, height: 5000))
    }
    
    override func removeFromParent() {
        presenting = false
        self.removeAllActions()
        backgroundPlayer?.stop()
        self.removeAllChildren()
        super.removeFromParent()
    }
    
    
    
    func showDieScene() {
        GameViewController.shared?.scene = nil
        let scene = SKScene(fileNamed: "GameOver")
        self.removeFromParent()
        self.view?.presentScene(scene)
        
    }
    
    func checkNextScene(force:Bool = false) {
        print("scssceneewded\nscore:\(score) rewardCount:\(rewardCount)")
        if score >= self.rewardCount || force  {
            if force {
                GameViewController.shared?.currentScene = 1
            } else {
                GameViewController.shared?.currentScene += 1
            }
            run(Sound.levelUp.action)
            
            removeFromParent()
            DispatchQueue.main.async {
                GameViewController.shared?.loadScene(i:GameViewController.shared?.currentScene ?? 0)
            }
        }
    }
    
    func hitted(by:SKSpriteNode? = nil) {
        player?.meteorHit(by: by)
        loseHeart()
    }
    
  //  var pausedOn = false
    func pause(_ pause:Bool = true) {
        isPaused = pause
        enumerateChildNodes(withName: "meteor", using: {node,point in
            node.physicsBody?.affectedByGravity = !pause
        })
        
        enumerateChildNodes(withName: "enemy", using: {node,point in
            if let enemy = node as? EnemyNode {
                enemy.isPaused = pause
                node.physicsBody?.affectedByGravity = !pause
                if !pause {
                    enemy.randomWalking()
                }
            }
        })
    }
    
    
    func deviceMotionChanged(new:Double) {
        print(new, " grvewedws")

    }
}

extension SKSpriteNode {
    @objc func removeShapeFromTexture(shapeRect: CGRect, set:Bool = true) {
        guard let cgImage = self.texture?.cgImage() else {
            return
        }
        print("removeShapeFromTexture")
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return
        }
        print("removeShapeFromTexture11")

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Iterate through pixels and remove the shape
        for y in Int(shapeRect.origin.y)..<Int(shapeRect.origin.y + shapeRect.size.height) {
            for x in Int(shapeRect.origin.x)..<Int(shapeRect.origin.x + shapeRect.size.width) {
                let pixelIndex = (y * width + x) * bytesPerPixel
                if pixelData.count - 1 >= pixelIndex {
                    pixelData[pixelIndex] = 0 // Set red channel to 0 (remove shape)

                } else {
                    pixelData[pixelData.count - 1] = 0 // Set red channel to 0 (remove shape)

                }
            }
        }
        
        // Create a new CGImage from the modified pixel data
        if let newCGImage = context.makeImage(),
           let imgUI:UIImage? = .init(cgImage: newCGImage),
           let img = imgUI?.cgImage
        {
            print("removeShapeFromTexture11 setted ", imgUI.jpegData(compressionQuality: 1))
            (self as? PlayerNode)?.updatingDamage = true
            self.texture = .init(cgImage: img)
        } else {
            return
        }
    }

}
