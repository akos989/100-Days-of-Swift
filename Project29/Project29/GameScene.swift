//
//  GameScene.swift
//  Project29
//
//  Created by Ákos Morvai on 2022. 08. 05..
//

import SpriteKit

enum CollisionType: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    var currentPlayer = 1
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var player1Score = 0
    var player1ScoreLabel: SKLabelNode!
    var player2Score = 0
    var player2ScoreLabel: SKLabelNode!
    
    var gameOver = false
    var gameOverLabel: SKLabelNode!
    
    var wind: CGVector? {
        didSet {
            if let wind = wind {
                print("Wind is \(wind)")
            } else {
                print("No wind")
            }
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
        
        player1ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player1ScoreLabel.horizontalAlignmentMode = .left
        player1ScoreLabel.fontSize = 30
        player1ScoreLabel.position = CGPoint(x: 20, y: 10)
        player1ScoreLabel.text = "Player 1 score: \(player1Score)"
        player1ScoreLabel.scene?.backgroundColor = .black
        player1ScoreLabel.zPosition = 100
        addChild(player1ScoreLabel)
        
        player2ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player2ScoreLabel.horizontalAlignmentMode = .right
        player2ScoreLabel.fontSize = 30
        player2ScoreLabel.position = CGPoint(x: 1004, y: 10)
        player2ScoreLabel.text = "Player 2 score: \(player2Score)"
        player2ScoreLabel.scene?.backgroundColor = .black
        player2ScoreLabel.zPosition = 100
        addChild(player2ScoreLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 50
        gameOverLabel.position = CGPoint(x: 512, y: 300)
        gameOverLabel.text = "Game Over! Winner: "
        gameOverLabel.isHidden = true
        gameOverLabel.zPosition = 100
        addChild(gameOverLabel)
        
        createRandomWind()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if let wind = wind {
            banana.physicsBody?.applyForce(wind)
        }
        
        if abs(banana.position.x) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node,
              let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            player2Score += 1
            if player2Score >= 3 {
                gameOverLabel.text?.append("Player 2")
                gameOverLabel.isHidden = false
                gameOver = true
            }
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            player1Score += 1
            if player1Score >= 3 {
                gameOverLabel.text?.append("Player 1")
                gameOverLabel.isHidden = false
                gameOver = true
            }
            destroy(player: player2)
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        guard !gameOver else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            newGame.player1Score = self.player1Score
            newGame.player2Score = self.player2Score
            
            let transition = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transition)
        }
    }
    
    func changePlayer() {
        guard !gameOver else {
            return
        }
        
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        createRandomWind()
        
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionType.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionType.building.rawValue | CollisionType.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionType.building.rawValue | CollisionType.player.rawValue
        
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let pause = SKAction.wait(forDuration: 0.15)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let pause = SKAction.wait(forDuration: 0.15)
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionType.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionType.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionType.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionType.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
    
    func createRandomWind() {
        if Int.random(in: 1...3) < 3 {
            let randomAngleRadians = Double.random(in: 0...Double.pi)
            let speed = Double.random(in: 1...25)
            wind = CGVector(dx: cos(randomAngleRadians) * speed, dy: sin(randomAngleRadians) * speed)
        } else {
            wind = nil
        }
    }
}
