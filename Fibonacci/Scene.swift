//
//  Scene.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import SpriteKit

// The min distance in one direction for an effective swipe.
let EFFECTIVE_SWIPE_DISTANCE_THRESHOLD = 20.0

// The max ratio between the translation in x and y directions
// to make a swipe valid. i.e. diagonal swipes are invalid.
let VALID_SWIPE_DIRECTION_THRESHOLD = 2.0

class Scene: SKScene {
    weak var controller: M2ViewController?
    
    /** The game manager that controls all the logic of the game. */
    private var manager: M2GameManager?
    
    /**
     * Each swipe triggers at most one action, and we don't wait the swipe to complete
     * before triggering the action (otherwise the user may swipe a long way but nothing
     * happens). So after a swipe is done, we turn this flag to NO to prevent further
     * moves by the same swipe.
     */
    private var hasPendingSwipe = false
    
    /** The current board node. */
    private var board: SKSpriteNode?
    
    init(size: CGSize) {
        super.init(size: size)
        manager = M2GameManager()
    }
    
    func loadBoard(with grid: M2Grid?) {
        // Remove the current board if there is one.
        if board != nil {
            board?.removeFromParent()
        }
        
        let image: UIImage? = M2GridView.gridImage(with: grid)
        var backgroundTexture: SKTexture? = nil
        
        if let anImage = image?.cgImage {
            backgroundTexture = SKTexture(cgImage: anImage)
        }
        
        board = SKSpriteNode(texture: backgroundTexture)
        board?.setScale(1 / UIScreen.main.scale)
        //This solves the Scaling problem in 6Plus and 6S Plus
        board?.position = CGPoint(x: frame.midX, y: frame.midY)
        if let aBoard = board {
            addChild(aBoard)
        }
    }
    
    func startNewGame() {
        manager?.startNewSession(with: self)
    }
    
    // MARK: - Swipe handling
    
    // @TODO: It makes more sense to move these logic stuff to the view controller.
    
    func didMove(to view: SKView) {
        if view == self.view {
            // Add swipe recognizer immediately after we move to this scene.
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(M2Scene.handleSwipe(_:)))
            self.view.addGestureRecognizer(recognizer)
            return
        }
        
        // If we are moving away, remove the gesture recognizer to prevent unwanted behaviors.
        for recognizer: UIGestureRecognizer in self.view.gestureRecognizers {
            self.view.removeGestureRecognizer(recognizer)
        }
    }
    
    @objc func handleSwipe(_ swipe: UIPanGestureRecognizer?) {
        if swipe?.state == .began {
            hasPendingSwipe = true
        } else if swipe?.state == .changed {
            commitTranslation(swipe?.translation(in: view))
        }
    }
    
    func commitTranslation(_ translation: CGPoint) {
        if !hasPendingSwipe {
            return
        }
        
        let absX = CGFloat(fabs(Float(translation.x)))
        let absY = CGFloat(fabs(Float(translation.y)))
        
        // Swipe too short. Don't do anything.
        if max(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD {
            return
        }
        
        // We only accept horizontal or vertical swipes, but not diagonal ones.
        if Double(absX) > Double(absY) * VALID_SWIPE_DIRECTION_THRESHOLD {
            translation.x < 0 ? manager?.move(toDirection: M2DirectionLeft) : manager?.move(toDirection: M2DirectionRight)
        } else if Double(absY) > Double(absX) * VALID_SWIPE_DIRECTION_THRESHOLD {
            translation.y < 0 ? manager?.move(toDirection: M2DirectionUp) : manager?.move(toDirection: M2DirectionDown)
        }
        
        hasPendingSwipe = false
    }
}
