//
//  GameScene.swift
//  ZombieConga
//
//  Created by Parrot on 2019-01-29.
//  Copyright © 2019 Parrot. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var bg: SKSpriteNode!
    var zombie: SKSpriteNode!
    var grandMa: SKSpriteNode!
    var cat: SKSpriteNode!
    var livesLable: SKLabelNode!
    var scoreLable: SKLabelNode!
    var mouseX:CGFloat = 0
    var mouseY:CGFloat = 0
    var delay: Int = 0
    var cats:[SKSpriteNode] = []

    var lives = 500;
    var score = 0;
    override func didMove(to view: SKView) {
        //1. Set the background color of the app
        self.backgroundColor = SKColor.black;
        
                
        //2. Setup Zombie
        self.zombie = SKSpriteNode(imageNamed: "zombie1")
        self.zombie.position = CGPoint(x:1000,y:1000)
        addChild(self.zombie)
        
        //3. Setup Grandma
        self.grandMa = SKSpriteNode(imageNamed: "enemy")
        self.grandMa.position = CGPoint(x:size.width-100,y:size.height/2)
        addChild(self.grandMa)
        
        //4. Setup Lives Label
        self.livesLable = SKLabelNode(text: "Lives Remaining: \(lives)")
        self.livesLable.fontSize = 65
        self.livesLable.color = UIColor.orange
        self.livesLable.position = CGPoint(x:400,y:size.height-300)
        addChild(livesLable)

        self.scoreLable = SKLabelNode(text: "Score: \(self.score)")
        self.scoreLable.fontSize = 65
        self.scoreLable.color = UIColor.orange
        self.scoreLable.position = CGPoint(x:400,y:size.height-400)
        addChild(scoreLable)

        //5. Make the animation for grandma's movement
        let   move1 = SKAction.move(to: CGPoint(x:size.width/2,y: 360), duration: 2)
        let   move2 = SKAction.move(to: CGPoint(x:100,y: size.height/2), duration: 2)
        let   move3 = SKAction.move(to: CGPoint(x:size.width/2,y: 360), duration: 2)
        let   move4 = SKAction.move(to: CGPoint(x:size.width-100,y: size.height/2), duration: 2)
        let grandMaAnimation = SKAction.sequence([move1,move2,move3,move4])
        let grandMaLoop = SKAction.repeatForever(grandMaAnimation)
        grandMa.run(grandMaLoop)
    }

    override func update(_ currentTime: TimeInterval){
        if(currentTime.ulp == 1){
            print("Wind it up")
        }
        //1. Increase the delay/counter
        self.delay = self.delay + 1
        //2. Move zombie to mouse tap point
        moveZombieToPoint(x: self.mouseX, y: self.mouseY)
        
        //3. Detect Collision
        if(self.zombie.frame.intersects(self.grandMa.frame)){
            print("Collision occured")
            if(self.lives>0){
            //4. Decrease lives by one
            self.lives = self.lives - 1
            livesLable.text = "Lives Remaining: \(lives)"
            }
        }
        //5. Spawn Random Cats every 100th frame
        if(delay%70 == 0){
            spawnCat()
        }
        
        //6. Detect Cat and Zombie Collision
        for cat in cats {
            if(cat.frame.intersects(self.zombie.frame)){
                //Collision between zombie and one cat
                
                //1. Increase Score
                self.score = self.score + 10
                scoreLable.text = "Score: \(score)"

                //2. Remove cat from screen
                cat.removeFromParent()
                //3. Remove cat from Array
                let index = cats.index(of: cat)
                cats.remove(at: index!)
            }
            
        }
        
    }

    func moveZombieToPoint(x: CGFloat,y: CGFloat){
        let a = (self.mouseX - self.zombie.position.x);
        let b = (self.mouseY - self.zombie.position.y)
        let distance = sqrt((a*a)+(b*b))
        let xn = (a/distance)
        let yn = (b/distance)
        self.zombie.position.x = self.zombie.position.x + (xn*10);
        self.zombie.position.y = self.zombie.position.y + (yn*10);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var locationTouched = touches.first
        if(locationTouched == nil)        {
            return
        }
        let mousePosition = locationTouched!.location(in: self)
        print("MOUSE X : \(mousePosition.x)")
        print("MOUSE Y : \(mousePosition.y)")
        self.mouseX = mousePosition.x
        self.mouseY = mousePosition.y
    }

      
       
         
        func spawnCat() {
            // Add a cat to a static location
            let cat = SKSpriteNode(imageNamed: "cat")
    
            // generate a random x position
            let randomXPos = Int.random(in: 00 ... 1800)
            let randomYPos = Int.random(in: 00 ... 1800)
            cat.position = CGPoint(x:randomXPos, y:randomYPos)
    
            // add the cat to the screen
            addChild(cat)
    
            // add the cat to the array
            self.cats.append(cat)
    
        }
        
}
