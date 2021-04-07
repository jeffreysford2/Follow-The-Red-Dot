//
//  GameScene.swift
//  Follow The Dot
//
//  Created by Jeffrey Ford on 3/16/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import SpriteKit
import GameplayKit


var currentScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate   {

    let leaderboardID = "FollowTheRedDotLeaderboard"
    
    
    let gameArea: CGRect
    
    var touchCount = 0
    var numberOfRedDots = 50
    var numberOfTouchesBeforeGuess = 2
    
    
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let guessWords = SKLabelNode(fontNamed: "Futura")
    let winnerWords = SKLabelNode(fontNamed: "Futura")
    let tapWords = SKLabelNode(fontNamed: "Futura")
    let followTheDotWords = SKLabelNode(fontNamed: "Futura")
    let followTheDotWords2 = SKLabelNode(fontNamed: "Futura")
    let beatTheGameWords = SKLabelNode(fontNamed: "Futura")
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var touchable : Bool?
    var nextLevelReady : Bool? = false
    //var arrayRedDots : [SKSpriteNode] = [SKSpriteNode]()
    var arrayRedDots = [SKSpriteNode]()
    //var guessWords : SKSpriteNode?
    var randomXArray: [Double] = []
    var randomYArray: [Double] = []
    
    

    
    //var currentGameState = gameState.preGame
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    override init(size: CGSize){
        
        let maxAspectRatio: CGFloat = 16.0/9.0

        let playableWidth = size.height / maxAspectRatio

        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        //print("game area is \(gameArea)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func didMove(to view: SKView) {
        
        //Following adds the score label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*5/8, y:  scoreLabel.frame.size.height*2)
        //print(self.size.width*7/8)
        //print(scoreLabel.frame.size.height*4)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        touchable = false
        spawnRedDots()
        generateRandomArray()
    }
    
    func generateRandomArray(){
        let left = self.size.width - self.size.width + 350
        let right = self.size.width-350
        let top = self.size.height-100
        let bottom = self.size.height - self.size.height + 100
        
        //var randomXArray: [Double] = []
        //var randomYArray: [Double] = []
        
        for i in 0...2000{

            let randomX = random(min:left, max:right)
            let randomY = random(min:bottom, max: top)
            randomXArray.append(Double(randomX))
            randomYArray.append(Double(randomY))
        }

        

    }
    
    //Function puts dots into position
    func spawnRedDots(){
        addFollowTheDotWords()
        for i in 0...numberOfRedDots{
            let redDot = SKSpriteNode(imageNamed: "red_dot")
            let left = self.size.width - self.size.width + 350
            let right = self.size.width-350
            var randomW = random(min: left, max:right)
            redDot.setScale(0.05)
            redDot.position = CGPoint(x: randomW, y: self.size.height*5/8)
            redDot.zPosition = 2
            redDot.physicsBody = SKPhysicsBody(rectangleOf: redDot.size)
            redDot.physicsBody!.affectedByGravity = false
            arrayRedDots.append(redDot)
            self.addChild(arrayRedDots[i])

        }
        
        //print("new scene size \(self.size)")
        
        let enlarge = SKAction.scale(to: 0.3, duration: 2)
        let shrink = SKAction.scale(to: 0.05, duration: 2)
        let waitToScale = SKAction.wait(forDuration: 2)
        let scaleSequence = SKAction.sequence([waitToScale,enlarge,shrink])
        arrayRedDots[0].run(scaleSequence)
        
        let delay = 7 //Amount of seconds that must pass before touchable
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
            self.touchable = true
            self.addTapWords()
            //self.removeFollowTheDotWords()
        }
        
    }
    
    func addGuessWords(){
        //Following adds the guess words
        guessWords.text = "Guess where the dot is!"
        guessWords.fontSize = 50
        guessWords.fontColor = SKColor.white
        guessWords.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        guessWords.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        guessWords.zPosition = 100
        self.addChild(guessWords)

    }
    
    func removeGuessWords(){
        let deleteGuessWords = SKAction.removeFromParent()
        guessWords.run(deleteGuessWords)

    }
    
    func addWinnerWords(){
        //Following adds the guess words
        winnerWords.text = "Correct!"
        winnerWords.fontSize = 100
        winnerWords.fontColor = SKColor.white
        winnerWords.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        winnerWords.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        winnerWords.zPosition = 100
        self.addChild(winnerWords)

    }
    
    func removeWinnerWords(){
        let deleteWinnerWords = SKAction.removeFromParent()
        winnerWords.run(deleteWinnerWords)

    }
    
    func addTapWords(){
        tapWords.text = "Tap"
        tapWords.fontSize = 40
        tapWords.fontColor = SKColor.white
        tapWords.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapWords.position = CGPoint(x: self.size.width/2, y:  self.size.height/2-100)
        tapWords.zPosition = 100
        self.addChild(tapWords)
    }
    
    func removeTapWords(){
        let deleteTapWords = SKAction.removeFromParent()
        tapWords.run(deleteTapWords)
    }
    
    func addFollowTheDotWords(){
        followTheDotWords.text = "Keep your eyes on the expanding dot!"
        followTheDotWords.fontSize = 45
        followTheDotWords.fontColor = SKColor.white
        followTheDotWords.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        followTheDotWords.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        followTheDotWords.zPosition = 100
        self.addChild(followTheDotWords)
        
        followTheDotWords2.text = "Tap to move the dots!"
        followTheDotWords2.fontSize = 45
        followTheDotWords2.fontColor = SKColor.white
        followTheDotWords2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        followTheDotWords2.position = CGPoint(x: self.size.width/2, y:  self.size.height/2-55)
        followTheDotWords2.zPosition = 100
        self.addChild(followTheDotWords2)
    }
    
    func removeFollowTheDotWords(){
        let deleteFollowTheDotWords = SKAction.removeFromParent()
        followTheDotWords.run(deleteFollowTheDotWords)
        followTheDotWords2.run(deleteFollowTheDotWords)
    }
    
    func spawnFiveDots(){

        for i in numberOfRedDots - 4...numberOfRedDots{

            let redDot = SKSpriteNode(imageNamed: "red_dot")
            let left = self.size.width - self.size.width + 350
            let right = self.size.width-350
            var randomW = random(min: left, max:right)
            redDot.setScale(0.05)
            redDot.position = CGPoint(x: randomW, y: self.size.height*5/8)
            redDot.zPosition = 2
            redDot.physicsBody = SKPhysicsBody(rectangleOf: redDot.size)
            redDot.physicsBody!.affectedByGravity = false
            arrayRedDots.append(redDot)
            self.addChild(arrayRedDots[i])
            //print(arrayRedDots[i].position)
        }
        touchable = true
        
    }
    
    func startNextLevel(){
        
        var delay = 3 // seconds to wait before firing
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                              
                              
                        
            self.numberOfTouchesBeforeGuess += 1
            
            self.numberOfRedDots += 5
            self.touchCount = 0
            self.nextLevelReady = true
            self.removeWinnerWords()
            self.addTapWords()
            
        }
    }
    
    
    
    //Function called when it is time to guess where the dot is
    func guessTime(){
        let hold1 = 2
        let hold2 = 2
        self.touchable = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(hold1)) {
            
            self.addGuessWords()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(hold2)) {
                    self.removeGuessWords()
                    self.touchable = true

            }
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func runWinner(){
        beatTheGameWords.text = "WINNER!!!"
        beatTheGameWords.fontSize = 70
        beatTheGameWords.fontColor = SKColor.white
        beatTheGameWords.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        beatTheGameWords.position = CGPoint(x: self.size.width/2, y:  self.size.height/2)
        beatTheGameWords.zPosition = 100
        self.addChild(beatTheGameWords)
            
            
        var delay = 25 // seconds to wait before firing
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
            self.runGameOver()
                
        }
         
        for i in 0...numberOfRedDots{

            
            let xEnd1 = randomXArray[i+touchCount*2+currentScore]
            let yEnd1 = randomYArray[i+touchCount*2+currentScore]
            let endPoint1 = CGPoint(x: xEnd1, y: yEnd1)
            let moveRedDots1 = SKAction.move(to: endPoint1, duration: 2)
            let wait = SKAction.wait(forDuration: 2)
            let moveSequence1 = SKAction.sequence([moveRedDots1])
            let xEnd2 = randomXArray[i+touchCount*2+currentScore+1]
            let yEnd2 = randomYArray[i+touchCount*2+currentScore+1]
            let endPoint2 = CGPoint(x: xEnd2, y: yEnd2)
            let moveRedDots2 = SKAction.move(to: endPoint2, duration: 2)
            let moveSequence2 = SKAction.sequence([moveRedDots2])
            let xEnd3 = randomXArray[i+touchCount*2+currentScore+2]
            let yEnd3 = randomYArray[i+touchCount*2+currentScore+2]
            let endPoint3 = CGPoint(x: xEnd3, y: yEnd3)
            let moveRedDots3 = SKAction.move(to: endPoint3, duration: 2)
            
            let xEnd4 = randomXArray[i+touchCount*2+currentScore+3]
            let yEnd4 = randomYArray[i+touchCount*2+currentScore+3]
            let endPoint4 = CGPoint(x: xEnd4, y: yEnd4)
            let moveRedDots4 = SKAction.move(to: endPoint4, duration: 2)
            
            let moveSequence4 = SKAction.sequence([moveRedDots4])
            let xEnd5 = randomXArray[i+touchCount*2+currentScore+4]
            let yEnd5 = randomYArray[i+touchCount*2+currentScore+4]
            let endPoint5 = CGPoint(x: xEnd5, y: yEnd5)
            let moveRedDots5 = SKAction.move(to: endPoint5, duration: 2)
            let moveSequence5 = SKAction.sequence([moveRedDots5])
            let xEnd6 = randomXArray[i+touchCount*2+currentScore+5]
            let yEnd6 = randomYArray[i+touchCount*2+currentScore+5]
            let endPoint6 = CGPoint(x: xEnd6, y: yEnd6)
            let moveRedDots6 = SKAction.move(to: endPoint6, duration: 2)
            
            
            
            
            
            
            let moveSequence = SKAction.sequence([moveRedDots1,moveRedDots2,moveRedDots3,moveRedDots4,moveRedDots5,moveRedDots6,moveRedDots1,moveRedDots2,moveRedDots3,moveRedDots4,moveRedDots5,moveRedDots6])
            
            
            
            
            arrayRedDots[i].run(moveSequence)


        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

        
        if nextLevelReady!{
            spawnFiveDots()
            nextLevelReady = false
            return
        }
        
        
        
        if touchable! {
            removeFollowTheDotWords()
            if touchCount % (numberOfTouchesBeforeGuess) == 0 && touchCount > 0{
                
                removeTapWords()
               
                touchable = false
                
                let distance = CGPointDistance(from: arrayRedDots[0].position, to: pos)
                
                if distance < 80 {
                    touchable = false
                    
                    addScore()
                    if numberOfRedDots == 200 {
                        runWinner()
                        return
                    }
                    addWinnerWords()
                    self.startNextLevel()
                    return
                    
                } else{
                    
                    let enlarge = SKAction.scale(to: 1, duration: 2)
                    let shrink = SKAction.scale(to: 0.05, duration: 2)
                    let wait = SKAction.wait(forDuration: 0.5)
                    let scaleSequence = SKAction.sequence([wait,enlarge,shrink])
                    arrayRedDots[0].run(scaleSequence)
                    
                    var delay = 6 // seconds to wait before firing
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                        self.runGameOver()
                        
                    }
                }
                
                
                let enlarge = SKAction.scale(to: 0.5, duration: 2)
                let shrink = SKAction.scale(to: 0.05, duration: 2)
                let waitToScale = SKAction.wait(forDuration: 2)
                let scaleSequence = SKAction.sequence([waitToScale,enlarge,shrink])
                arrayRedDots[0].run(scaleSequence)
                
                let delay = 7 // seconds to wait before firing
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                    self.touchable = true
                }
                
                
                
            }else{
                
                touchable = false

                removeTapWords()
                for i in 0...numberOfRedDots{

                    
                    let xEnd = randomXArray[i+touchCount*2+currentScore]
                    let yEnd = randomYArray[i+touchCount*2+currentScore]

                    let endPoint = CGPoint(x: xEnd, y: yEnd)
                    let moveRedDots = SKAction.move(to: endPoint, duration: 2)

                    let moveSequence = SKAction.sequence([moveRedDots])
                    arrayRedDots[i].run(moveSequence)

                    let delay = 2 // seconds to wait before firing
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
                        //self.addTapWords()

                        if self.touchCount % self.numberOfTouchesBeforeGuess != 0{
                            
                            self.touchable = true
                        }
                    }
                }
            }
        
            touchCount += 1
            //print(touchCount)
            if touchCount == numberOfTouchesBeforeGuess{
                self.touchable = false
              
                guessTime()
            }
        }
    }
    
    func addScore(){
        currentScore += 5
        scoreLabel.text = "Score: \(currentScore)"
    }

    func runGameOver(){
            let changeSceneAction = SKAction.run(changeSceneToGameOver)
            let waitToChangeScene = SKAction.wait(forDuration: 1)
            let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
            self.run(changeSceneAction)
        }
        
        
        
        func changeSceneToGameOver(){
            let sceneToMoveTo = GameOverScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            //print("sceneToMoveTo.size = \(sceneToMoveTo.size)")
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches {
            self.touchDown(atPoint: t.location(in: self))

        }

    }
    

 }
