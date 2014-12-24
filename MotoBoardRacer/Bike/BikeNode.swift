//
//  BikeNode.swift
//  MotoBoardRacer
//
//  Created by Esteban Martínez on 15/12/14.
//  Copyright (c) 2014 com.deportebi. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion


class BikeNode: SKSpriteNode {
    
    var bikeSpriteNode:SKSpriteNode!
    private let mark:SKShapeNode!
    private let influenceCircle:SKShapeNode!
    private var curvePath:CGMutablePathRef!
    private var curve:SKShapeNode!
    
    private var P0:CGFloat!
    private var P1:CGFloat!
    private var C0:CGFloat!
    private var C1:CGFloat!
    
    private var C0_Circle:SKShapeNode!
    private var C1_Circle:SKShapeNode!
    
    var wayPoints: [CGPoint] = []
    var velocity = CGPoint(x: 0, y: 0)
    
   
    
    
    init(imageName: NSString) {
        
        let texture = SKTexture(imageNamed: imageName)
        
        super.init(texture: nil, color: nil, size: texture.size())
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //self.position.y = -200

        
        
        
        self.bikeSpriteNode = SKSpriteNode(texture: texture);
        self.mark = SKShapeNode(circleOfRadius: 5)
        self.mark.fillColor = UIColor.blueColor()
        self.mark.strokeColor = UIColor.blackColor()
        
        
        self.influenceCircle = SKShapeNode(circleOfRadius: 50)
        self.influenceCircle.fillColor = UIColor.clearColor()
        self.influenceCircle.strokeColor = UIColor.whiteColor()
        
        self.C0_Circle = SKShapeNode(circleOfRadius: 5)
        self.C0_Circle.fillColor = UIColor.yellowColor()
        self.C0_Circle.strokeColor = UIColor.blackColor()
        
        self.C1_Circle = SKShapeNode(circleOfRadius: 5)
        self.C1_Circle.fillColor = UIColor.greenColor()
        self.C1_Circle.strokeColor = UIColor.blackColor()
        
        self.C0_Circle.position.y = bikeSpriteNode.position.y+55
        self.C1_Circle.position.y = bikeSpriteNode.position.y+110
        
        self.bikeSpriteNode.alpha = 1.0;
        
        
        curvePath = CGPathCreateMutable();
        
        //calculateControlPoints()
        CGPathMoveToPoint(curvePath, nil, bikeSpriteNode.position.x, bikeSpriteNode.position.y);
        
        CGPathAddCurveToPoint(curvePath, nil, 0, bikeSpriteNode.position.y+55, 0, bikeSpriteNode.position.y+110, bikeSpriteNode.position.x, bikeSpriteNode.position.y+165);
        
        self.curve = SKShapeNode(path: curvePath);

        
        self.addChild(bikeSpriteNode)
        
        self.addChild(mark)
        self.mark.name = "mark"
        //self.mark.position.y = 150
        self.mark.position.y = self.bikeSpriteNode.position.y + 165
        
        self.addChild(C0_Circle)
        self.addChild(C1_Circle)
        
        self.addChild(influenceCircle)
        //self.influenceCircle.position.y = 150
        self.influenceCircle.position.x = self.mark.position.x
        self.influenceCircle.position.y = self.mark.position.y
        
        self.addChild(curve)
        curve.strokeColor = UIColor.whiteColor()
        
        self.mark.zPosition = 1;
        self.influenceCircle.zPosition = 1
        self.curve.zPosition = 1
        self.C0_Circle.zPosition = 1
        self.C1_Circle.zPosition = 1
        self.bikeSpriteNode.zPosition = 1
        
        
        
        self.userInteractionEnabled = true;
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        let nodeCharacter = self.nodesAtPoint(touchLocation);
        
        var distance = hypot(touchLocation.x - self.influenceCircle.position.x, touchLocation.y - self.influenceCircle.position.y);
        
        if (distance < 50)
        {
            self.mark.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
           
        }
        
      
    }
    
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        
        var distance = hypot(touchLocation.x - self.influenceCircle.position.x, touchLocation.y - self.influenceCircle.position.y);
        
        if (distance < 50)
        {
            self.mark.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
            
            curvePath = CGPathCreateMutable();
            CGPathMoveToPoint(curvePath, nil, 0, 0);
            CGPathAddCurveToPoint(curvePath, nil, 0, 55, 0, 110, touchLocation.x, touchLocation.y)
            self.curve.path = curvePath
        }
        
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        
        let moveBikeAction = SKAction.followPath(self.curve.path, asOffset: true, orientToPath: true, duration: 1.0)
        
        self.bikeSpriteNode.runAction(moveBikeAction, completion: {
        
            var worldPoint = self.parent?.convertPoint(self.bikeSpriteNode.position, fromNode: self)
            
            self.position.x = worldPoint!.x
            self.position.y = worldPoint!.y
            self.zRotation += self.bikeSpriteNode.zRotation
            self.bikeSpriteNode.position = CGPointZero
            self.bikeSpriteNode.zRotation = 0
            
            self.influenceCircle.position = self.mark.position
            
            self.calculateControlPoints()
            
            
        })
        

    }
    
    
    func calculateControlPoints()
    {
       // C1 = (
        
        println("Dsitance: \(hypot(self.mark.position.x - self.bikeSpriteNode.position.x, self.mark.position.y - self.bikeSpriteNode.position.y))")
        
        let distance = hypot(self.mark.position.x - self.bikeSpriteNode.position.x, self.mark.position.y - self.bikeSpriteNode.position.y)
        
        
        curvePath = CGPathCreateMutable();
        CGPathMoveToPoint(curvePath, nil, 0, 0);
        CGPathAddCurveToPoint(curvePath, nil, 0, distance*0.33, 0, distance*0.66, self.mark.position.x, self.mark.position.y)
        self.curve.path = curvePath
        
        
        self.C0_Circle.position.y = distance*0.33
        
        
        self.C1_Circle.position.y = distance*0.66
        
        //hypot(self.mark.position.x - self.bikeSpriteNode.position.x, self.mark.position.y - self.bikeSpriteNode.position.y)
        
        /*
        CGFloat SDistanceBetweenPoints(CGPoint first, CGPoint second) {
        return hypotf(second.x - first.x, second.y - first.y);
        }
        */
    }

    
    
}
