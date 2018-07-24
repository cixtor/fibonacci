//
//  GameManager.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit
import Foundation

enum Direction : Int {
    case up
    case left
    case down
    case right
}

/**
 * Helper function that checks the termination condition of either counting up or down.
 *
 * @param value The current i value.
 * @param countUp If YES, we are counting up.
 * @param upper The upper bound of i.
 * @param lower The lower bound of i.
 * @return YES if the counting is still in progress. NO if it should terminate.
 */
func iterate(value: Int, countUp: Bool, upper: Int, lower: Int) -> Bool {
    return countUp ? value < upper : value > lower
}

class GameManager: NSObject {
    /** True if game over. */
    private var over = false

    /** True if won game. */
    private var won = false

    /** True if user chooses to keep playing after winning. */
    private var keepPlaying = false

    /** The current score. */
    private var score: Int = 0

    /** The points earned by the user in the current round. */
    private var pendingScore: Int = 0

    /** The grid on which everything happens. */
    private var grid: Grid?

    /** The display link to add tiles after removing all existing tiles. */
    private var addTileDisplayLink: CADisplayLink?

    // MARK: - Setup

    /**
     * Starts a new session with the provided scene.
     *
     * @param scene The scene in which the game happens.
     */
    func startNewSession(with scene: Scene?) {
        if grid != nil {
            grid?.removeAllTiles(animated: false)
        }

        if !(grid != nil) || grid?.dimension != GSTATE.dimension {
            grid = Grid(dimension: GSTATE.dimension)
            grid?.scene = scene!
        }

        scene?.loadBoard(with: grid)

        // Set the initial state for the game.
        score = 0
        over = false
        won = false
        keepPlaying = false

        // Existing tile removal is async and happens in the next screen refresh, so we'd wait a bit.
        addTileDisplayLink = CADisplayLink(target: self, selector: #selector(self.addTwoRandomTiles))
        addTileDisplayLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }

    @objc func addTwoRandomTiles() {
        // If the scene only has one child (the board), we can proceed with
        // adding new tiles since all old ones are removed. After adding new
        // tiles, remove the displaylink.
        if (grid?.scene.children.count)! <= 1 {
            grid?.insertTileAtRandomAvailablePosition(withDelay: false)
            grid?.insertTileAtRandomAvailablePosition(withDelay: false)
            addTileDisplayLink?.invalidate()
        }
    }

    // MARK: - Actions

    /**
     * Moves all movable tiles to the desired direction, then add one more tile
     * to the grid?. Also refreshes score and checks game status (won/lost).
     *
     * @param direction The direction of the move (up, right, down, left).
     */
    func move(to direction: Direction) {
        var tile: Tile? = nil

        // Remember that the coordinate system of SpriteKit is the reverse of that of UIKit.
        let reverse: Bool = direction == Direction.up || direction == Direction.right
        let unit: Int = reverse ? 1 : -1

        if direction == Direction.up || direction == Direction.down {
            grid?.forEach({ position in
                if (tile = grid?.tile(at: position)) != nil {
                    // Find farthest position to move to.
                    var target = position.x
                    var i = position.x + unit

                    while iterate(value: i, countUp: reverse, upper: (grid?.dimension)!, lower: -1) {
                        let t: Tile? = grid?.tile(at: PositionMake(i, position.y))

                        // Empty cell; we can move at least to here.
                        if t == nil {
                            target = i
                        } else {
                            var level: Int = 0
                            if GSTATE.gameType == GameType.powerOf3 {
                                let further: Position = PositionMake(i + unit, position.y)
                                let ft: Tile? = grid?.tile(at: further)
                                if ft != nil {
                                    level = tile?.merge3(to: t, andTile: ft) ?? 0
                                }
                            } else {
                                level = tile?.merge(to: t) ?? 0
                            }

                            if level != 0 {
                                target = position.x
                                pendingScore = GSTATE.value(forLevel: level)
                            }

                            break
                        }

                        i += unit
                    }

                    // The current tile is movable.
                    if target != position.x {
                        tile?.move(to: grid?.cell(at: PositionMake(target, position.y)))
                        pendingScore += 1
                    }
                }
            }, reverseOrder: reverse)
        } else {
            grid?.forEach({ position in
                if (tile = grid?.tile(at: position)) != nil {
                    var target = position.y
                    var i = position.y + unit

                    while iterate(value: i, countUp: reverse, upper: (grid?.dimension)!, lower: -1) {
                        let t: Tile? = grid?.tile(at: PositionMake(position.x, i))

                        if t == nil {
                            target = i
                        } else {
                            var level: Int = 0
                            if GSTATE.gameType == GameType.powerOf3 {
                                let further: Position = PositionMake(position.x, i + unit)
                                let ft: Tile? = grid?.tile(at: further)
                                if ft != nil {
                                    level = tile?.merge3(to: t, andTile: ft) ?? 0
                                }
                            } else {
                                level = tile?.merge(to: t) ?? 0
                            }
                            if level != 0 {
                                target = position.y
                                pendingScore = GSTATE.value(forLevel: level)
                            }
                            break
                        }

                        i += unit
                    }

                    // The current tile is movable.
                    if target != position.y {
                        tile?.move(to: grid?.cell(at: PositionMake(position.x, target)))
                        pendingScore += 1
                    }
                }
            }, reverseOrder: reverse)
        }

        // Cannot move to the given direction. Abort.
        if pendingScore < 1 {
            return
        }

        // Commit tile movements.
        grid?.forEach({ position in
            let tile: Tile? = grid?.tile(at: position)
            if tile != nil {
                tile?.commitPendingActions()
                if (tile?.level)! >= GSTATE.winningLevel() {
                    won = true
                }
            }
        }, reverseOrder: reverse)

        // Increment score.
        materializePendingScore()

        // Check post-move status.
        if !keepPlaying && won {
            // We set `keepPlaying` to YES. If the user decides not to keep playing,
            // we will be starting a new game, so the current state is no longer relevant.
            keepPlaying = true
            grid?.scene.controller?.endGame(true)
        }

        // Add one more tile to the grid?.
        grid?.insertTileAtRandomAvailablePosition(withDelay: true)

        if GSTATE.dimension == 5 && GSTATE.gameType == GameType.powerOf2 {
            grid?.insertTileAtRandomAvailablePosition(withDelay: true)
        }

        if !movesAvailable() {
            grid?.scene.controller?.endGame(false)
        }
    }

    // MARK: - Score

    func materializePendingScore() {
        score += pendingScore
        pendingScore = 0
        grid?.scene.controller?.updateScore(score)
    }

    // MARK: - State checkers

    /**
     * Whether there are moves available.
     *
     * A move is available if either there is an empty cell, or there are
     * adjacent matching cells. The check for matching cells is more expensive,
     * so it is only performed when there is no available cell.
     *
     * @return YES if there are moves available.
     */
    func movesAvailable() -> Bool {
        return (grid?.hasAvailableCells())! || adjacentMatchesAvailable()
    }

    /**
     * Whether there are adjacent matches available.
     *
     * An adjacent match is present when two cells that share an edge can be
     * merged. We do not consider cases in which two mergable cells are separated
     * by some empty cells, as that should be covered by the `cellsAvailable`
     * function.
     *
     * @return YES if there are adjacent matches available.
     */
    func adjacentMatchesAvailable() -> Bool {
        for i in 0..<(grid?.dimension)! {
            for j in 0..<(grid?.dimension)! {
                // Due to symmetry, we only need to check for tiles to the right and down.
                let tile: Tile? = grid?.tile(at: PositionMake(i, j))

                // Continue with next iteration if the tile does not exist. Note that this means that
                // the cell is empty. For our current usage, it will never happen. It is only in place
                // in case we want to use this function by itself.
                if tile == nil {
                    continue
                }

                if GSTATE.gameType == GameType.powerOf3 {
                    if (
                        tile?.canMerge(with: grid?.tile(at: PositionMake(i + 1, j))) != nil
                        && tile?.canMerge(with: grid?.tile(at: PositionMake(i + 2, j))) != nil
                    ) || (
                        tile?.canMerge(with: grid?.tile(at: PositionMake(i, j + 1))) != nil
                        && tile?.canMerge(with: grid?.tile(at: PositionMake(i, j + 2))) != nil
                    ) {
                        return true
                    }
                } else {
                    if tile?.canMerge(with: grid?.tile(at: PositionMake(i + 1, j))) != nil
                    || tile?.canMerge(with: grid?.tile(at: PositionMake(i, j + 1))) != nil {
                        return true
                    }
                }
            }
        }

        // Nothing is found.
        return false
    }
}
