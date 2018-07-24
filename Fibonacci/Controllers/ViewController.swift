//
//  ViewController.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import SpriteKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var targetScore: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var scoreView: ScoreView!
    @IBOutlet var bestView: ScoreView!
    @IBOutlet var overlay: Overlay!
    @IBOutlet var overlayBackground: UIImageView!

    private var scene: Scene = Scene.init(size: CGSize.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateState()

        bestView.score.text = "\(Settings.integer(forKey: "Best Score"))"

        restartButton.layer.cornerRadius = CGFloat(GSTATE.cornerRadius)
        restartButton.layer.masksToBounds = true

        settingsButton.layer.cornerRadius = CGFloat(GSTATE.cornerRadius)
        settingsButton.layer.masksToBounds = true

        overlay.isHidden = true
        overlayBackground.isHidden = true

        // Configure the view.
        let skView = view as? SKView

        // Create and configure the scene.
        let scene = Scene(size: skView?.bounds.size ?? CGSize.zero)
        scene.scaleMode = SKSceneScaleMode.aspectFill

        // Present the scene.
        skView?.presentScene(scene)

        self.updateScore(0)

        scene.startNewGame()

        self.scene = scene
        self.scene.controller = self
    }

    func updateState() {
        scoreView.updateAppearance()
        bestView.updateAppearance()

        restartButton.backgroundColor = GSTATE.buttonColor()

        if let aSize = UIFont(name: GSTATE.boldFontName(), size: 14) {
            restartButton.titleLabel?.font = aSize
        }

        settingsButton.backgroundColor = GSTATE.buttonColor()

        if let aSize = UIFont(name: GSTATE.boldFontName(), size: 14) {
            settingsButton.titleLabel?.font = aSize
        }

        targetScore.textColor = GSTATE.buttonColor()

        let target = GSTATE.value(forLevel: GSTATE.winningLevel())

        if target > 100000 {
            targetScore.font = UIFont(name: GSTATE.boldFontName(), size: 34)
        } else if target < 10000 {
            targetScore.font = UIFont(name: GSTATE.boldFontName(), size: 42)
        } else {
            targetScore.font = UIFont(name: GSTATE.boldFontName(), size: 40)
        }

        targetScore.text = "\(target)"

        subtitle.textColor = GSTATE.buttonColor()
        subtitle.font = UIFont(name: GSTATE.regularFontName(), size: 14)
        subtitle.text = "Join the numbers to get to \(target)!"

        overlay.message.font = UIFont(name: GSTATE.boldFontName(), size: 36)

        if let aSize = UIFont(name: GSTATE.boldFontName(), size: 17) {
            overlay.keepPlaying.titleLabel?.font = aSize
        }

        if let aSize = UIFont(name: GSTATE.boldFontName(), size: 17) {
            overlay.restartGame.titleLabel?.font = aSize
        }

        overlay.message.textColor = GSTATE.buttonColor()
        overlay.keepPlaying.setTitleColor(GSTATE.buttonColor(), for: .normal)
        overlay.restartGame.setTitleColor(GSTATE.buttonColor(), for: .normal)
    }

    func updateScore(_ score: Int) {
        scoreView.score.text = "\(score)"

        if Settings.integer(forKey: "Best Score") < score {
            Settings.set(score, forKey: "Best Score")
            bestView.score.text = "\(score)"
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
        (view as? SKView)?.isPaused = true
    }

    @IBAction func restart(_ sender: Any) {
        hideOverlay()
        updateScore(0)
        scene.startNewGame()
    }

    @IBAction func keepPlaying(_ sender: Any) {
        hideOverlay()
    }

    @IBAction func done(_ segue: UIStoryboardSegue) {
        (view as? SKView)?.isPaused = false
        if GSTATE.needRefresh {
            GSTATE.load()
            updateState()
            updateScore(0)
            scene.startNewGame()
        }
    }

    func endGame(_ won: Bool) {
        overlay.isHidden = false
        overlay.alpha = 0
        overlayBackground.isHidden = false
        overlayBackground.alpha = 0

        if !won {
            overlay.keepPlaying.isHidden = true
            overlay.message.text = "Game Over"
        } else {
            overlay.keepPlaying.isHidden = false
            overlay.message.text = "You Win!"
        }

        // Fake the overlay background as a mask on the board.
        overlayBackground.image = GridView.gridImageWithOverlay()

        // Center the overlay in the board.
        let vertical: CGFloat = UIScreen.main.bounds.size.height - CGFloat(GSTATE.vOffset)
        let side = Int(GSTATE.dimension * (GSTATE.tileSize() + GSTATE.borderWidth) + GSTATE.borderWidth)
        overlay.center = CGPoint(x: CGFloat(GSTATE.hOffset + side / 2), y: vertical - CGFloat(side / 2))

        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
            self.overlay.alpha = 1
            self.overlayBackground.alpha = 1
        }) { finished in
            // Freeze the current game.
            (self.view as? SKView)?.isPaused = true
        }
    }

    func hideOverlay() {
        (view as? SKView)?.isPaused = false

        if !overlay.isHidden {
            UIView.animate(withDuration: 0.5, animations: {
                self.overlay.alpha = 0
                self.overlayBackground.alpha = 0
            }) { finished in
                self.overlay.isHidden = true
                self.overlayBackground.isHidden = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
