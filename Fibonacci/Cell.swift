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
    var position: M2Position?
    
    /** The tile in the cell, if any. */
    var tile: M2Tile?
    
    /**
     * Initialize a M2Cell at the specified position with no tile in it.
     *
     * @param position The position of the cell.
     */
    init(position: M2Position) {
        super.init()
        self.position = position
        tile = nil
    }
    
    func setTile(_ tile: M2Tile?) {
        _tile = tile
        
        if tile != nil {
            tile?.cell = self
        }
    }
}
