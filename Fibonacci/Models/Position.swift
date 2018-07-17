//
//  Position.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

typealias Position = var x: Int var y: Int

func PositionMake(x: Int, _ y: Int) -> Position {
    var position: Position
    position.x = x
    position.y = y
    return position
}
