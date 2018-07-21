//
//  Position.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

struct Position {
    var x: Int = 0
    var y: Int = 0
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

func PositionMake(_ x: Int, _ y: Int) -> Position {
    return Position(x, y)
}
