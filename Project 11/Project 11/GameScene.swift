//
//  GameScene.swift
//  Project 11
//
//  Created by Ákos Morvai on 2022. 04. 14..
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballNumberLabel: SKLabelNode!
    var ballNumber = 5 {
        didSet {
            ballNumberLabel.text = "Balls left: \(ballNumber)"
            if ballNumber == 0 {
                endGame()
            }
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode = true {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
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
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        ballNumberLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballNumberLabel.text = "Balls left: \(ballNumber)"
        ballNumberLabel.horizontalAlignmentMode = .right
        ballNumberLabel.position = CGPoint(x: 980, y: 600)
        addChild(ballNumberLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Done"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        for (xCoordinate, isGood) in [(128, true), (384, false), (640, true), (896, false)] {
            makeSlot(at: CGPoint(x: xCoordinate, y: 0), isGood: isGood)
        }
        for xCoordinate in [0, 256, 512, 768, 1024] {
            makeBouncer(at: CGPoint(x: xCoordinate, y: 0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(
                    color: UIColor(
                        red: CGFloat.random(in: 0...1),
                        green: CGFloat.random(in: 0...1),
                        blue: CGFloat.random(in: 0...1),
                        alpha: 1),
                    size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.restitution = CGFloat.random(in: 0...1)
                box.physicsBody?.isDynamic = false
                box.name = "obstacle"
                addChild(box)
            } else {
                let ballColorNames = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
                let ball = SKSpriteNode(imageNamed: ballColorNames.randomElement() ?? "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = CGPoint(x: location.x, y: size.height)
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        bouncer.physicsBody?.restitution = 1.0
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    private func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.zPosition = 0
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        switch object.name {
        case "good":
            destroy(ball: ball)
            ballNumber += 1
        case "bad":
            destroy(ball: ball)
            ballNumber -= 1
        case "obstacle":
            destroy(ball: ball)
            object.removeFromParent()
            score += 1
            ballNumber -= 1
        default:
            return
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func endGame() {
        let ac = UIAlertController(title: "Game ended", message: "Your end score is \(score)", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "New game", style: .default) {
            [weak self] _ in
            self?.newGame()
        })
        if let gameViewController = view?.window?.rootViewController as? GameViewController {
            gameViewController.showAlert(alertController: ac)
        }
    }
    
    func newGame() {
        score = 0
        ballNumber = 0
        let obstacles = children.filter { node in
            return node.name == "obstacle"
        }
        removeChildren(in: obstacles)
    }
}
