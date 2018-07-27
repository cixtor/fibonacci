//
//  Grid.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import SpriteKit
import Foundation

typealias IteratorBlock = (Position) -> Void

class Grid: NSObject {
    /** The dimension of the grid. */
    var dimension: Int = 0

    /* The 2-D grid that keeps track of all cells and tiles. */
    var grid : [[Cell]] = []

    /** The scene in which the game happens. */
    var scene: Scene = Scene(size: CGSize.zero)

    /**
     * Initializes a new grid with the given dimension.
     *
     * @param dimension The desired dimension, i.e. # cells in a row or column.
     */
    init(dimension: Int) {
        super.init()

        // Set up the grid with all empty cells.
        grid = [[Cell]]()

        for i in 0..<dimension {
            var array = [Cell]()
            for j in 0..<dimension {
                array.append(Cell(position: PositionMake(i, j)))
            }
            grid.append(array)
        }

        // Record the dimension of the grid.
        self.dimension = dimension
    }

    // MARK: - Iterator

    /**
     * Iterates over the grid and calls the block, which takes in the Position
     * of the current cell. Has the option to iterate in the reverse order.
     *
     * @param block The block to be applied to each cell position.
     * @param reverse If YES, iterate in the reverse order.
     */
    func forEach(_ block: IteratorBlock, reverseOrder reverse: Bool) {
        if !reverse {
            for i in 0..<dimension {
                for j in 0..<dimension {
                    block(PositionMake(i, j))
                }
            }
            return
        }

        for i in (0..<(dimension - 1)).reversed() {
            for j in (0..<(dimension - 1)).reversed() {
                block(PositionMake(i, j))
            }
        }
    }

    // MARK: - Position helpers

    /**
     * Returns the cell at the specified position.
     *
     * @param position The position we are interested in.
     * @return The cell at the position. If position out of bound, returns nil.
     */
    func cell(at position: Position) -> Cell? {
        if position.x >= dimension
            || position.y >= dimension
            || position.x < 0
            || position.y < 0 {
            return nil
        }

        return grid[position.x][position.y]
    }

    /**
     * Returns the tile at the specified position.
     *
     * @param position The position we are interested in.
     * @return The tile at the position. If position out of bound or cell empty, returns nil.
     */
    func tile(at position: Position) -> Tile? {
        let cell: Cell? = self.cell(at: position)
        return cell != nil ? cell?.tile : nil
    }

    // MARK: - Cell availability

    /**
     * Whether there are any available cells in the grid.
     *
     * @return YES if there are at least one cell available.
     */
    func hasAvailableCells() -> Bool {
        return self.availableCells().count != 0
    }

    /**
     * Returns a randomly chosen cell that's available.
     *
     * @return A randomly chosen available cell, or nil if no cell is available.
     */
    func randomAvailableCell() -> Cell? {
        let cells = self.availableCells()

        if cells.count == 0 {
            return nil
        }

        return cells[Int(arc4random_uniform(UInt32(cells.count)))]
    }

    /**
     * Returns all available cells in an array.
     *
     * @return The array of all available cells. If no cell is available, returns empty array.
     */
    func availableCells() -> [Cell] {
        var array = [Cell]()

        array.reserveCapacity(dimension * dimension)

        forEach({ position in
            let cell: Cell? = self.cell(at: position)
            if cell?.tile != nil {
                array.append(cell!)
            }
        }, reverseOrder: false)

        return array
    }

    // MARK: - Cell manipulation

    /**
     * Inserts a new tile at a randomly chosen position that's available.
     *
     * @param delay If YES, adds twice `animationDuration` long delay before the insertion.
     */
    func insertTileAtRandomAvailablePosition(withDelay delay: Bool) {
        let cell: Cell? = randomAvailableCell()

        if cell == nil {
            return
        }

        let tile = Tile.insertNewTile(to: cell)

        scene.addChild(tile)

        let delayAction = delay
            ? SKAction.wait(forDuration: TimeInterval(GSTATE.animationDuration * 3))
            : SKAction.wait(forDuration: 0)
        let move = SKAction.move(
            by: CGVector(dx: -GSTATE.tileSize() / 2, dy: -GSTATE.tileSize() / 2),
            duration: TimeInterval(GSTATE.animationDuration)
        )
        let scale = SKAction.scale(to: 1, duration: TimeInterval(GSTATE.animationDuration))
        tile.run(SKAction.sequence([delayAction, SKAction.group([move, scale])]))
    }

    /**
     * Removes all tiles in the grid from the scene.
     *
     * @param animated If YES, animate the removal.
     */
    func removeAllTiles(animated: Bool) {
        forEach({ position in
            let tile: Tile? = self.tile(at: position)
            if tile != nil {
                tile?.remove(animated: animated)
            }
        }, reverseOrder: false)
    }
}
