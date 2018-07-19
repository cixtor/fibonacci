//
//  Grid.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import Foundation

typealias IteratorBlock = (M2Position) -> Void

class Grid: NSObject {
    /** The dimension of the grid. */
    var dimension: Int = 0

    /** The scene in which the game happens. */
    weak var scene: M2Scene?

    /* The 2-D grid that keeps track of all cells and tiles. */
    private var grid: [AnyHashable] = []

    /**
     * Initializes a new grid with the given dimension.
     *
     * @param dimension The desired dimension, i.e. # cells in a row or column.
     */
    init(dimension: Int) {
        super.init()

        // Set up the grid with all empty cells.
        grid = [AnyHashable](repeating: 0, count: dimension)

        for i in 0..<dimension {
            var array = [AnyHashable](repeating: 0, count: dimension)
            for j in 0..<dimension {
                array.append(M2Cell(position: M2PositionMake(i, j)))
            }
            grid.append(array)
        }

        // Record the dimension of the grid.
        self.dimension = dimension
    }

    // MARK: - Iterator

    /**
     * Iterates over the grid and calls the block, which takes in the M2Position
     * of the current cell. Has the option to iterate in the reverse order.
     *
     * @param block The block to be applied to each cell position.
     * @param reverse If YES, iterate in the reverse order.
     */
    func forEach(_ block: IteratorBlock, reverseOrder reverse: Bool) {
        if !reverse {
            for i in 0..<dimension {
                for j in 0..<dimension {
                    block(M2PositionMake(i, j))
                }
            }
        } else {
            var i = dimension - 1
            while i >= 0 {
                var j = dimension - 1
                while j >= 0 {
                    block(M2PositionMake(i, j))
                    j -= 1
                }
                i -= 1
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
    func cell(at position: M2Position) -> M2Cell? {
        if position.x >= dimension || position.y >= dimension || position.x < 0 || position.y < 0 {
            return nil
        }

        return grid[position.x][position.y] as? M2Cell
    }

    /**
     * Returns the tile at the specified position.
     *
     * @param position The position we are interested in.
     * @return The tile at the position. If position out of bound or cell empty, returns nil.
     */
    func tile(at position: M2Position) -> M2Tile? {
        let cell: M2Cell? = self.cell(at: position)
        return cell != nil ? cell?.tile : nil
    }

    /**
     * Returns a randomly chosen cell that's available.
     *
     * @return A randomly chosen available cell, or nil if no cell is available.
     */
    func randomAvailableCell() -> M2Cell? {
        let availableCells = self.availableCells()

        if availableCells.count != 0 {
            return availableCells[arc4random_uniform(availableCells.count)] as? M2Cell
        }

        return nil
    }

    // MARK: - Cell availability

    /**
     * Whether there are any available cells in the grid.
     *
     * @return YES if there are at least one cell available.
     */
    func hasAvailableCells() -> Bool {
        return availableCells().count != 0
    }

    /**
     * Returns all available cells in an array.
     *
     * @return The array of all available cells. If no cell is available, returns empty array.
     */
    func availableCells() -> [Any]? {
        var array = [AnyHashable](repeating: 0, count: dimension * dimension)

        forEach({ position in
            let cell: M2Cell? = self.cell(at: position)

            if cell?.tile == nil {
                if let aCell = cell {
                    if let aCell = cell {
                        array.append(aCell)
                    }
                }
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
        let cell: M2Cell? = randomAvailableCell()

        if cell != nil {
            let tile = M2Tile.insertNewTile(to: cell)
            scene.addChild(tile)
            let delayAction = delay ? SKAction.wait(forDuration: TimeInterval(GSTATE.animationDuration() * 3)) : SKAction.wait(forDuration: 0)
            let move = SKAction.move(by: CGVectorMake(Int(-GSTATE.tileSize) / 2, Int(-GSTATE.tileSize) / 2), duration: TimeInterval(GSTATE.animationDuration()))
            let scale = SKAction.scale(to: 1, duration: TimeInterval(GSTATE.animationDuration()))
            tile.runAction(SKAction.sequence([delayAction, SKAction.group([move, scale])]))
        }
    }

    /**
     * Removes all tiles in the grid from the scene.
     *
     * @param animated If YES, animate the removal.
     */
    func removeAllTiles(animated: Bool) {
        forEach({ position in
            let tile: M2Tile? = self.tile(at: position)
            if tile != nil {
                tile?.remove(animated: animated)
            }
        }, reverseOrder: false)
    }
}
