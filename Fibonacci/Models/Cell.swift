//
//  Cell.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import Foundation

class Cell: NSObject {
    /** The position of the cell. */
    var position: Position?

    /** The tile in the cell, if any. */
    var tile: Tile?

    /**
     * Initialize a Cell at the specified position with no tile in it.
     *
     * @param position The position of the cell.
     */
    init(position: Position) {
        super.init()
        self.position = position
        tile = nil
    }

    func setTile(_ tile: Tile?) {
        if tile != nil {
            tile?.cell = self
        }
    }
}
