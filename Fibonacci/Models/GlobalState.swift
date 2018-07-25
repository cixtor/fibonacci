//
//  GlobalState.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit
import Foundation

let GSTATE = GlobalState()
let Settings = UserDefaults.standard
let NotifCtr = NotificationCenter.default

let kBoardSize = "Board Size"
let kBestScore = "Best Score"
let kGameType = "Game Type"
let kTheme = "Theme"

enum GameType : Int {
    case powerOf2 = 0
    case powerOf3 = 1
    case fibonacci = 2
}

class GlobalState: NSObject {
    var dimension: Int = 0
    var borderWidth: Int = 0
    var cornerRadius: Int = 0
    var animationDuration: TimeInterval = 0.0
    var gameType: GameType?
    var hOffset: Int = 0
    var vOffset: Int = 0
    var theme: Int = 0

    var needRefresh = false

    /** The singleton instance of state. */
    // convenience init() {
    //     var state: GlobalState? = nil
    //     var once: Int = 0
    //     if (once == 0) {
    //         state = GlobalState()
    //     }
    //     once = 1
    // }

    override init() {
        super.init()
        setupDefaultState()
        load()
    }

    func setupDefaultState() {
        let defaultValues = [kGameType: 0, kTheme: 0, kBoardSize: 1, kBestScore: 0]
        Settings.register(defaults: defaultValues)
    }

    /** Refreshes global state to reflect user choice. */
    func load() {
        self.dimension = Settings.integer(forKey: kBoardSize) + 3
        self.borderWidth = 5
        self.cornerRadius = 4
        self.animationDuration = 0.1
        self.gameType = GameType(rawValue: Settings.integer(forKey: kGameType))
        self.hOffset = self.horizontalOffset()
        self.vOffset = self.verticalOffset()
        self.theme = Settings.integer(forKey: kTheme)
        self.needRefresh = false
    }

    func tileSize() -> Int {
        return dimension <= 4 ? 66 : 56
    }

    func horizontalOffset() -> Int {
        let width = CGFloat(dimension * (tileSize() + borderWidth) + borderWidth)
        return Int((UIScreen.main.bounds.size.width - width) / 2)
    }

    func verticalOffset() -> Int {
        let height = CGFloat(dimension * (tileSize() + borderWidth) + borderWidth + 120)
        return Int((UIScreen.main.bounds.size.height - height) / 2)
    }

    func winningLevel() -> Int {
        if GSTATE.gameType == GameType.powerOf3 {
            switch dimension {
            case 3:
                return 4
            case 4:
                return 5
            case 5:
                return 6
            default:
                return 5
            }
        }
        let level: Int = 11
        if dimension == 3 {
            return level - 1
        }
        if dimension == 5 {
            return level + 2
        }
        return level
    }

    /**
     * Whether the two levels can merge with each other to form another level.
     * This behavior is commutative.
     *
     * @param level1 The first level.
     * @param level2 The second level.
     * @return YES if the two levels are actionable with each other.
     */
    func isLevel(_ level1: Int, mergeableWithLevel level2: Int) -> Bool {
        if gameType == GameType.fibonacci {
            return abs(level1 - level2) == 1
        }
        return level1 == level2
    }

    /**
     * The resulting level of merging the two incoming levels.
     *
     * @param level1 The first level.
     * @param level2 The second level.
     * @return The resulting level, or 0 if the two levels are not actionable.
     */
    func mergeLevel(_ level1: Int, withLevel level2: Int) -> Int {
        if !isLevel(level1, mergeableWithLevel: level2) {
            return 0
        }
        if gameType == GameType.fibonacci {
            return (level1 + 1 == level2) ? level2 + 1 : level1 + 1
        }
        return level1 + 1
    }

    /**
     * The numerical value of the specified level.
     *
     * @param level The level we are interested in.
     * @return The numerical value of the level.
     */
    func value(forLevel level: Int) -> Int {
        if gameType == GameType.fibonacci {
            var a: Int = 1
            var b: Int = 1
            for _ in 0..<level {
                let c: Int = a + b
                a = b
                b = c
            }
            return b
        } else {
            var value: Int = 1
            let base: Int = gameType == GameType.powerOf2 ? 2 : 3
            for _ in 0..<level {
                value *= base
            }
            return value
        }
    }

    // MARK: - Appearance

    /**
     * The background color of the specified level.
     *
     * @param level The level we are interested in.
     * @return The color of the level.
     */
    func color(forLevel level: Int) -> UIColor? {
        return Theme.themeClass(for: theme).color(forLevel: level)
    }

    /**
     * The text color of the specified level.
     *
     * @param level The level we are interested in.
     * @return The color of the level.
     */
    func textColor(forLevel level: Int) -> UIColor {
        return Theme.themeClass(for: theme).textColor(forLevel: level)
    }

    func backgroundColor() -> UIColor {
        return Theme.themeClass(for: theme).backgroundColor()
    }

    func boardColor() -> UIColor {
        return Theme.themeClass(for: theme).boardColor()
    }

    func scoreBoardColor() -> UIColor {
        return Theme.themeClass(for: theme).scoreBoardColor()
    }

    func buttonColor() -> UIColor {
        return Theme.themeClass(for: theme).buttonColor()
    }

    func boldFontName() -> String {
        return Theme.themeClass(for: theme).boldFontName()
    }

    func regularFontName() -> String {
        return Theme.themeClass(for: theme).regularFontName()
    }

    /**
     * The text size of the specified value.
     *
     * @param value The value we are interested in.
     * @return The text size of the value.
     */
    func textSize(forValue value: Int) -> CGFloat {
        let offset: Int = dimension == 5 ? 2 : 0
        if value < 100 {
            return CGFloat(32 - offset)
        } else if value < 1000 {
            return CGFloat(28 - offset)
        } else if value < 10000 {
            return CGFloat(24 - offset)
        } else if value < 100000 {
            return CGFloat(20 - offset)
        } else if value < 1000000 {
            return CGFloat(16 - offset)
        } else {
            return CGFloat(13 - offset)
        }
    }

    // MARK: - Position to point conversion

    /**
     * The starting location of the position.
     *
     * @param position The position we are interested in.
     * @return The location in points, relative to the grid.
     */
    func locationOf(_ position: Position) -> CGPoint {
        return CGPoint(
            x: xLocationOf(position) + CGFloat(hOffset),
            y: yLocationOf(position) + CGFloat(vOffset)
        )
    }

    /**
     * The starting x location of the position.
     *
     * @param position The position we are interested in.
     * @return The x location in points, relative to the grid.
     */
    func xLocationOf(_ position: Position) -> CGFloat {
        return CGFloat(
            position.y
            * (GSTATE.tileSize() + GSTATE.borderWidth)
            + GSTATE.borderWidth
        )
    }

    /**
     * The starting y location of the position.
     *
     * @param position The position we are interested in.
     * @return The y location in points, relative to the grid.
     */
    func yLocationOf(_ position: Position) -> CGFloat {
        return CGFloat(
            position.x
            * (GSTATE.tileSize() + GSTATE.borderWidth)
            + GSTATE.borderWidth
        )
    }
}
