//
//  GameScene.swift
//  Project26
//
//  Created by Ákos Morvai on 2022. 07. 10..
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

enum LevelFileCharacters: String.Element {
    case wall = "x"
    case vortex = "v"
    case star = "s"
    case finish = "f"
    case space = " "
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelLabel: SKLabelNode!
    var levelNumber = 1 {
        didSet {
            levelLabel.text = "Level \(levelNumber)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level 1"
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 16, y: 768 - 30)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let newPosition = lastTouchPosition - player.position
            let dif = CGPoint(x: newPosition.x, y: newPosition.y)
            physicsWorld.gravity = CGVector(dx: dif.x / 100, dy: dif.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player{
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            for node in children.reversed() {
                if node.name == "wall" || node.name == "star" || node.name == "vortex" || node.name == "player" || node.name == "finish" {
                    node.removeFromParent()
                }
            }
            
            levelNumber += 1
            loadLevel()
            createPlayer()
            
            isGameOver = false
        }
    }
    
    func loadLevel() {
        guard let levelUrl = Bundle.main.url(forResource: "level\(levelNumber)", withExtension: "txt"),
              let levelString = try? String(contentsOf: levelUrl) else { fatalError("Could not find or load level\(levelNumber).txt") }
        let lines = levelString.components(separatedBy: "\n").dropLast()
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                                
                switch letter {
                    case LevelFileCharacters.wall.rawValue:
                        let node = SKSpriteNode(imageNamed: "block")
                        node.name = "wall"
                        node.position = position
                        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                        node.physicsBody?.isDynamic = false
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                        
                        addChild(node)
                    case LevelFileCharacters.vortex.rawValue:
                        let node = SKSpriteNode(imageNamed: "vortex")
                        node.name = "vortex"
                        node.position = position
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        node.physicsBody?.isDynamic = false
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        
                        addChild(node)
                    case LevelFileCharacters.star.rawValue:
                        let node = SKSpriteNode(imageNamed: "star")
                        node.name = "star"
                        node.position = position
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        node.physicsBody?.isDynamic = false
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        
                        addChild(node)
                    case LevelFileCharacters.finish.rawValue:
                        let node = SKSpriteNode(imageNamed: "finish")
                        node.name = "finish"
                        node.position = position
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        node.physicsBody?.isDynamic = false
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        
                        addChild(node)
                    case LevelFileCharacters.space.rawValue:
                        continue
                    default:
                        fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.name = "player"
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
}
