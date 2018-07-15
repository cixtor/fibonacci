//
//  Theme.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import Foundation

protocol Theme: NSObjectProtocol {
    /** The background color of the board base. */
    static func boardColor() -> UIColor?
    
    /** The background color of the entire scene. */
    static func backgroundColor() -> UIColor?
    
    /** The background color of the score board. */
    static func scoreBoardColor() -> UIColor?
    
    /** The background color of the button. */
    static func buttonColor() -> UIColor?
    
    /** The name of the bold font. */
    static func boldFontName() -> String?
    
    /** The name of the regular font. */
    static func regularFontName() -> String?
    
    /**
     * The color for the given level. If level is greater than 15, return the color for Level 15.
     *
     * @param level The level of the tile.
     */
    static func color(forLevel level: Int) -> UIColor?
    
    /**
     * The text color for the given level. If level is greater than 15, return the color for Level 15.
     *
     * @param level The level of the tile.
     */
    static func textColor(forLevel level: Int) -> UIColor?
}

func RGB(r: Any, g: Any, b: Any) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

func HEX(c: Any) -> UIColor {
    return UIColor(red: ((c >> 16) & 0xff) / 255.0, green: ((c >> 8) & 0xff) / 255.0, blue: (c & 0xff) / 255.0, alpha: 1.0)
}

class Theme: NSObject {
    /**
     * The theme we are using.
     *
     * @param type The index of the theme.
     */
    class func themeClass(forType type: Int) -> AnyClass {
        switch type {
        case 1:
            return VibrantTheme.self
        case 2:
            return JoyfulTheme.self
        default:
            return DefaultTheme.self
        }
    }
}
