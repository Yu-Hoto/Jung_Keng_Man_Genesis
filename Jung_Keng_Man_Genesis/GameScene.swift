//
//  GameScene.swift
//  Jung_Keng_Man_Genesis
//
//  Created by Yu Hoto on 2021/02/09.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var winLabel: SKLabelNode?
    private var loseLabel: SKLabelNode?
    private var drawLabel: SKLabelNode?
    private var rpsSpriteNode: SKSpriteNode = SKSpriteNode(imageNamed: "pa")
    
    var frameDaemon: Int = 0
    let refreshRate: Int = 6
    
    var sceneRunning: Bool = false
    
    let imageNames = ["gu", "choki", "pa"]
    
    func reStart() {
        if let winLabel = winLabel,
           let loseLabel = loseLabel,
           let drawLabel = drawLabel {
            winLabel.alpha = 0
            loseLabel.alpha = 0
            drawLabel.alpha = 0
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        self.winLabel = self.childNode(withName: "//winLabel") as? SKLabelNode
        self.loseLabel = self.childNode(withName: "//loseLabel") as? SKLabelNode
        self.drawLabel = self.childNode(withName: "//drawLabel") as? SKLabelNode
        
        reStart()
        
        rpsSpriteNode.size = CGSize(width: self.frame.width / 1.5, height: self.frame.width / 1.5)
        rpsSpriteNode.anchorPoint = CGPoint(x: 0, y: 0)
        rpsSpriteNode.position = CGPoint(x: 0 - rpsSpriteNode.size.width / 2, y: rpsSpriteNode.size.height / 10 - 100)
        self.addChild(rpsSpriteNode)
        
        let startButtonNode = SKSpriteNode(imageNamed: "startButton")
        startButtonNode.size = CGSize(width: startButtonNode.size.width / 2, height: startButtonNode.size.height / 2)
        startButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        startButtonNode.position = CGPoint(x: 0 - startButtonNode.size.width / 2, y: 0 - startButtonNode.size.height - 100)
        startButtonNode.name = "startButton"
        self.addChild(startButtonNode)
        
        for(index, imageName) in imageNames.enumerated() {
            let forCalcIndex = CGFloat(index - 1)
            let buttonSpriteNode = SKSpriteNode(imageNamed: imageName)
            buttonSpriteNode.size = CGSize(width: 100.0, height: 100.0)
            buttonSpriteNode.anchorPoint = CGPoint(x: 0, y: 0)
            buttonSpriteNode.position = CGPoint(x: (self.frame.width / 4 * forCalcIndex) - 50, y: 0 - self.frame.maxY / 2 - 50)
            buttonSpriteNode.name = imageName
            self.addChild(buttonSpriteNode)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            switch self.atPoint(location).name {
            case "gu":
                finish("gu")
            case "choki":
                finish("choki")
            case "pa":
                finish("pa")
            case "startButton":
                sceneRunning = true
                reStart()
            default:
                break
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        defer {
            if sceneRunning {
                frameDaemon += 1
            }
        }
        
        if frameDaemon % refreshRate == 0 {
            
            let imageName = imageNames[frameDaemon % (refreshRate * 3) / refreshRate]
            let texture = SKTexture(imageNamed: imageName)
            self.rpsSpriteNode.texture = texture
        }
    }
    
    func finish(_ button: String) {
        guard let playerHand = imageNames.firstIndex(of: button) else { return }
        sceneRunning = false
        let enemyHand = frameDaemon % (refreshRate * 3) / refreshRate
        switch playerHand - enemyHand {
        case -2:
            loseLabel?.alpha = 1.0
        case -1:
            winLabel?.alpha = 1.0
        case 0:
            drawLabel?.alpha = 1.0
        case 1:
            loseLabel?.alpha = 1.0
        case 2:
            winLabel?.alpha = 1.0
        default:
            break
        }
    }
}
