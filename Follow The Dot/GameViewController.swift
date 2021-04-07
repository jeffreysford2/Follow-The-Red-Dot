//
//  GameViewController.swift
//  Follow The Dot
//
//  Created by Jeffrey Ford on 3/16/20.
//  Copyright © 2020 Jeffrey Ford. All rights reserved.
//

import UIKit
import SpriteKit
//import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
 

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    

     override func viewDidLoad() {
            
        super.viewDidLoad()
        
        authPlayer()
            
            if let view = self.view as! SKView? {

                // Load the SKScene from 'GameScene.sks'

                let scene = GameScene(size: CGSize(width: 1536, height: 2048))

                    // Set the scale mode to scale to fit the window

                    scene.scaleMode = .aspectFill
                    
                    // Present the scene

                    view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = false

                view.showsNodeCount = false
            }

        }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            }
            else{
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    
}

