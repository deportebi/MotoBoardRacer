//
//  GameScene.swift
//  MotoBoardRacer
//
//  Created by Esteban Martínez on 15/12/14.
//  Copyright (c) 2014 com.deportebi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    var worldNode:SKNode!
    var motorBike:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
       anchorPoint = CGPoint(x: 0.5, y: 0.5)
       // anchorPoint = CGPoint(x: 0, y: 0);
        
        self.worldNode = SKNode()
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds;
        let limitX = NSInteger(screenSize.width/2);
        let limitY = NSInteger(screenSize.height/2);
        println("LIMITX: \(limitX)")
        println("LIMITY: \(limitY)")

        
        
        
        backgroundColor = SKColor.grayColor();
        
        let track:SKSpriteNode = SKSpriteNode(imageNamed: "Track_01.png")
        track.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        track.position.x = -1500
        track.alpha = 1.0
       // addChild(track)

        
        self.motorBike = BikeNode(imageName: "bike.png");
        
        
        //self.motorBike.position.x = 0
        //self.motorBike.position.y = 0
       // addChild(motorBike);
        
        //motorBike.position = getCenterPointWithTarget(motorBike.)
        
       //self.position = getCenterPointWithTarget(motorBike.position)
        
        self.worldNode.addChild(track)
        self.worldNode.addChild(self.motorBike);
        self.addChild(worldNode)
        
        //self.worldNode.position.x = 2000;
        
        centerViewOn(self.motorBike.position)
        
    }
    
    func centerViewOn(centerOn: CGPoint) {
        worldNode.position = getCenterPointWithTarget(centerOn)
    }
    
    func getCenterPointWithTarget(target: CGPoint) -> CGPoint {
        let x = self.motorBike.position.x
        let y = self.motorBike.position.y
        
        return CGPoint(x: -x, y: -y)
    }
    override func didSimulatePhysics() {
        let target = getCenterPointWithTarget(self.motorBike.position)
       // worldNode.position += (target - worldNode.position) * 0.1
        
        worldNode.position.x += (target.x - worldNode.position.x)*0.1
        worldNode.position.y += (target.y - worldNode.position.y)*0.1
        
    }
    
    /*
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    */
    
    
}
