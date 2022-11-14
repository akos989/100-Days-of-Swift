//
//  Bird.swift
//  Consolidation 7
//
//  Created by Ákos Morvai on 2022. 05. 24..
//

import UIKit
import SpriteKit

enum Speed: Int {
    case Slow = 1, Fast = 2
    
    func getVelocity(for direction: Int) -> Int {
        let velocity = self == Speed.Slow ? 400 : 700
        return velocity * direction
    }
}

enum Type {
    case Good, Bad
    
    func getPoints(for speed: Speed) -> Int {
        if self == Type.Bad {
            return -1
        } else {
            return speed.rawValue
        }
    }
}

class Bird: SKNode {
    let linePositionDictionary = [0: 600, 1: 360, 2: 100]
    
    var spriteNode: SKSpriteNode!
    
    var movementSpeed = Speed.Slow
    var type = Type.Good
    
    var isOffScreen: Bool {
        return spriteNode.position.x < -300 || spriteNode.position.x > 1500
    }
    
    func configure(lineNumber: Int) {
        if Int.random(in: 0...5) > 1 {
            spriteNode = SKSpriteNode(imageNamed: "duck")
        } else {
            spriteNode = SKSpriteNode(imageNamed: "pigeon")
            type = Type.Bad
        }
        
        if Int.random(in: 0...4) <= 1 {
            movementSpeed = Speed.Fast
        }
        
        var xPosition = 1200
        var speedDirection = -1
        if lineNumber == 1 {
            spriteNode.xScale = -1.0
            speedDirection = 1
            xPosition = -100
        }
        
        spriteNode.position = CGPoint(x: xPosition, y: linePositionDictionary[lineNumber] ?? 700)
        spriteNode.name = "bird"
        addChild(spriteNode)
        
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.size)
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.velocity = CGVector(dx: movementSpeed.getVelocity(for: speedDirection), dy: 0)
        spriteNode.physicsBody?.linearDamping = 0
    }
    
    func tapped() -> Int {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = spriteNode.position
        parent?.addChild(explosion)
        
        let delay = SKAction.wait(forDuration: 1.5)
        let removeExplosion = SKAction.run {
            [weak explosion] in
            explosion?.removeFromParent()
        }
        let removeExplosionSequence = SKAction.sequence([delay, removeExplosion])
        parent?.run(removeExplosionSequence)
        
        spriteNode.removeFromParent()

        return type.getPoints(for: movementSpeed)
    }
}
