//
//  GameScene.swift
//  Project 17
//
//  Created by Ákos Morvai on 2022. 05. 07..
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
   
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var enemyCountInLevel = 0
    var enemyCreateTime = 1.0
    
    var firstTouchLocation: CGPoint!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: enemyCreateTime, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch = touches.first else { return }
        firstTouchLocation = firstTouch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let locationOffset = CGPoint(x: location.x - firstTouchLocation.x, y: location.y - firstTouchLocation.y)
        var playerNewLocation = CGPoint(x: player.position.x + locationOffset.x, y: player.position.y + locationOffset.y)
        
        if playerNewLocation.y < 100 {
            playerNewLocation.y = 100
        } else if playerNewLocation.y > 668 {
            playerNewLocation.y = 668
        }
        
        if playerNewLocation.x < 70 {
            playerNewLocation.x = 70
        } else if playerNewLocation.x > 950 {
            playerNewLocation.x = 950
        }
        
        player.position = playerNewLocation
        firstTouchLocation = location
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()
    }
    
    @objc func createEnemy() {
        if enemyCountInLevel >= 10 {
            gameTimer?.invalidate()
            enemyCreateTime -= 0.05
            if enemyCreateTime <= 0.25 {
                enemyCreateTime = 0.5
            }
            gameTimer = Timer.scheduledTimer(timeInterval: enemyCreateTime, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            enemyCountInLevel = 0
        }
        
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        enemyCountInLevel += 1
    }
}
