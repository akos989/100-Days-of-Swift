//
//  GameScene.swift
//  Consolidation 7
//
//  Created by Ákos Morvai on 2022. 05. 24..
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer?
    var timeLabel: SKLabelNode!
    var remainingTime = 60 {
        didSet {
            timeLabel.text = "\(remainingTime)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 10, y: 730)
        scoreLabel.fontSize = 35
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 1000, y: 730)
        timeLabel.fontSize = 35
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.text = "60"
        addChild(timeLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reduceGameTime), userInfo: nil, repeats: true)
        
        physicsWorld.gravity = .zero
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let tappedNode = nodes(at: location).first,
              let birdNode = tappedNode.parent as? Bird else { return }
        
        score += birdNode.tapped()
        birdNode.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            guard let birdNode = node as? Bird else {
                continue }
            if birdNode.isOffScreen {
                node.removeFromParent()
            }
        }
    }
    
    @objc func reduceGameTime() {
        remainingTime -= 1
        if remainingTime <= 0 {
            gameTimer?.invalidate()
        }
    }
    
    @objc func createEnemy() {
        guard remainingTime > 0 else { return }
        
        if Int.random(in: 0...2) > 0 {
            let newBird = Bird()
            newBird.configure(lineNumber: 0)
            addChild(newBird)
        }
        if Int.random(in: 0...2) > 0 {
            let newBird = Bird()
            newBird.configure(lineNumber: 1)
            addChild(newBird)
        }
        if Int.random(in: 0...2) > 0 {
            let newBird = Bird()
            newBird.configure(lineNumber: 2)
            addChild(newBird)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }
}
