//
//  GameOverScene.swift
//  Follow The Dot
//
//  Created by Jeffrey Ford on 3/16/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
let leaderboardLabel = SKLabelNode(fontNamed: "The Bold Font")

class GameOverScene: SKScene, GKGameCenterControllerDelegate{
   
    
    override func didMove(to view: SKView) {
        
        print("Test 1")
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 120
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(currentScore)"
        scoreLabel.fontSize = 75
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if currentScore > highScoreNumber{
            highScoreNumber = currentScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
            if GKLocalPlayer.local.isAuthenticated {
                
                let scoreReporter = GKScore(leaderboardIdentifier: "FollowTheRedDotLeaderboard")
                scoreReporter.value = Int64(currentScore)
                let scoreArray : [GKScore] = [scoreReporter]
                GKScore.report(scoreArray, withCompletionHandler: nil)
                
                
            }
            
        }
        
        
        leaderboardLabel.text = "Check out the leaderboard!"
        leaderboardLabel.fontSize = 50
        leaderboardLabel.fontColor = SKColor.green
        leaderboardLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.1)
        leaderboardLabel.zPosition = 1
        self.addChild(leaderboardLabel)
        
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 75
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.5)
        self.addChild(highScoreLabel)
        
        //let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.40)
        self.addChild(restartLabel)
        
        currentScore = 0
        
    }
    
    func showLeaderboard(){
        let viewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
                
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                print("self.size = \(self.size)")
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                
            }
         
            if leaderboardLabel.contains(pointOfTouch){
                showLeaderboard()
            }
            
        }
    
    }
    
    
    
}
